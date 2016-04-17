//
//  SelectDateViewController.m
//  EventTracker
//
//  Created by Kevin McCafferty on 27/06/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import "SelectDateViewController.h"
#import "EventDetailViewController.h"

@interface SelectDateViewController ()

@end

@implementation SelectDateViewController

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
    self.datePicker.maximumDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


- (IBAction)doneButtonPressed:(id)sender {
    
    self.eventDateSelected = self.datePicker.date;
    [self.delegate controller:self didUpdateDateForEvent:self.eventDateSelected];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end



