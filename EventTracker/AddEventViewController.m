//
//  AddEventViewController.m
//  EventTracker
//
//  Created by Kevin McCafferty on 28/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import "AddEventViewController.h"
#import "Event.h"
#import "EventsViewController.h"
#import <EventKit/EventKit.h>
#import <QuartzCore/QuartzCore.h>

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )



@interface AddEventViewController ()

@end

@implementation AddEventViewController


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
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0f];
    
    self.elementContainer.backgroundColor = [UIColor colorWithRed:237.0/255 green:243.0/255 blue:245.0/255 alpha:1.0f];
    self.elementContainer.layer.cornerRadius = 3.0f;

    
    // Self is delegate for UITextFieldDelegate and UITextViewDelegate protocols
    self.eventName.delegate = self;
    self.eventDetails.delegate = self;
    
    self.eventName.backgroundColor = [UIColor whiteColor];
    self.eventName.layer.cornerRadius = 3.0f;
    
    self.eventDetails.backgroundColor = [UIColor whiteColor];
    self.eventDetails.layer.cornerRadius = 3.0f;
    
    
    _myCalendarArray = [[NSMutableArray alloc] init];
    
    NSArray *calendarsArray = [[NSArray alloc] init];
    calendarsArray = [_eventStore calendarsForEntityType:EKEntityTypeEvent];
    
    // Store all calendar titles in myCalendarArray for all calendars that are modifiable.
    for (EKCalendar *calendar in calendarsArray)
    {
        if (calendar.allowsContentModifications) {
            NSString *calendarTitle = calendar.title;
            [_myCalendarArray addObject:calendarTitle];
            
        }
    }
if ([_myCalendarArray count] != 0)
{
    self.eventCalendar = [_myCalendarArray objectAtIndex:0];
}
else
{
    [_myCalendarArray addObject:@"KevtestCal"];
}

}



-(void)viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        CGRect frameRect = self.eventDetails.frame;
        frameRect.size.height = 160;
        self.eventDetails.frame = frameRect;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)save:(id)sender
{

    NSString * textWithoutWhiteSpace = [self.eventName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Check if anything was entered for a name
    if ([textWithoutWhiteSpace length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString (@"No Name", nil)
                                                       message: NSLocalizedString (@"Please enter an Event Name.", nil)
                                                      delegate: self
                                             cancelButtonTitle: NSLocalizedString (@"OK", nil)
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // Extract user input
        NSString *name = [self.eventName text];
        NSString *detail = [self.eventDetails text];
        NSDate *date;
        
        //  Trim white space off name
        NSString *trimmedName = [name stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        
        
        [self.eventName resignFirstResponder];
        [self.eventDetails resignFirstResponder];
        
        // Notify Delegate
        [self.delegate controller:self didSaveItemWithName:trimmedName detail:detail Date:date andCalendar:self.eventCalendar];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (IBAction)cancel:(id)sender {
    [self.eventName resignFirstResponder];
    [self.eventDetails resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];

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
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 44) ? NO : YES;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.detailPlaceholder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.detailPlaceholder.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.detailPlaceholder.hidden = ([txtView.text length] > 0);
}
@end
