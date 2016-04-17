//
//  EditEventViewController.m
//  EventTracker
//
//  Created by Kevin McCafferty on 05/04/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import "EditEventViewController.h"
#import "AddEventViewController.h"
#import <EventKit/EventKit.h>
#import <QuartzCore/QuartzCore.h>

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

@interface EditEventViewController ()

@end

@implementation EditEventViewController

int i = 0;
int calRow = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0f];
    
    //self.editEventName.delegate = self;
    self.editEventDetails.delegate = self;
    
    self.detailsContainer.backgroundColor = [UIColor colorWithRed:237.0/255 green:243.0/255 blue:245.0/255 alpha:1.0f];
    self.detailsContainer.layer.cornerRadius = 3.0f;

    self.editEventName.backgroundColor = [UIColor colorWithRed:237.0/255 green:243.0/255 blue:245.0/255 alpha:1.0f];
    self.editEventName.layer.cornerRadius = 3.0f;
    self.editEventName.textColor = [UIColor colorWithRed:(124/255.0) green:(4/255.0) blue:(6/255.0) alpha:(1)];
        
    self.editEventDetails.backgroundColor = [UIColor whiteColor];
    self.editEventDetails.layer.cornerRadius = 3.0f;
    
    self.editEventName.text = self.editEvent.eventName;
    self.editEventDetails.text = self.editEvent.eventDetails;
    self.eventCalendar = self.editEvent.eventCalendar;
    
}



-(void)viewWillAppear:(BOOL)animated {
    
    _myCalendarArray = [[NSMutableArray alloc] init];

    NSArray *calendarsArray = [[NSArray alloc] init];
    calendarsArray = [_eventStore calendarsForEntityType:EKEntityTypeEvent];
    
    for (EKCalendar *calendar in calendarsArray)
    {
        if (calendar.allowsContentModifications) {
            NSString *calendarTitle = calendar.title;
            [_myCalendarArray addObject:calendarTitle];
            if ([calendar.title isEqualToString: self.editEvent.eventCalendar]) {
                calRow = i;
            }
            i++;
        }
    }
    i = 0;
}



-(void)viewDidAppear:(BOOL)animated
{
    
    [self.calendarPicker selectRow:calRow inComponent:0 animated:YES];
    [self.calendarPicker reloadComponent:0];
    self.editEvent.eventCalendar = [_myCalendarArray objectAtIndex:calRow];
}


-(void)viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        CGRect frameRect = self.editEventDetails.frame;
        frameRect.size.height = 160;
        self.editEventDetails.frame = frameRect;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveEdit:(id)sender {
    self.editEvent.eventName = self.editEventName.text;
    self.editEvent.eventDetails = self.editEventDetails.text;
    
    
    [self.delegate controller:self didUpdateEvent:_editEvent];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelEdit:(id)sender {
    [self.editEventName resignFirstResponder];
    [self.editEventDetails resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_myCalendarArray count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [_myCalendarArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.eventCalendar = [_myCalendarArray objectAtIndex:row];
    self.editEvent.eventCalendar = self.eventCalendar;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
}




@end

