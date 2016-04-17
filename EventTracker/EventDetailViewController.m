//
//  EventDetailViewController.m
//  EventTracker
//
//  Created by Kevin McCafferty on 30/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//
//  BFv.2.3 Fixes issue of only getting events of the last 4 years.

#import <EventKit/EventKit.h>
#import "EventDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Event.h"
#import "EditEventViewController.h"
#import "EventTrackerAppDelegate.h"



@interface EventDetailViewController ()



@end

@implementation EventDetailViewController

{
    NSString *str;
    EKEventStore *store;
    NSArray *sortedArray;
    NSDate *tempDate;
}
int calIndex = 0;
bool calendarFound = NO;





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
    
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    UIColor* mainColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0f];
    
    self.elementContainer.backgroundColor = [UIColor whiteColor];
    self.elementContainer.layer.cornerRadius = 3.0f;
    
    self.iconImageContainer.backgroundColor = mainColor;
    self.iconImageContainer.layer.cornerRadius = 3.0f;
    
    self.calendarLabel.font = [UIFont fontWithName:fontName size:16.0f];
    
    
    self.detailNameLabel.backgroundColor = [UIColor colorWithRed:237.0/255 green:243.0/255 blue:245.0/255 alpha:1.0f];
    self.detailNameLabel.layer.cornerRadius = 3.0f;
    self.detailNameLabel.textColor = [UIColor colorWithRed:(124/255.0) green:(4/255.0) blue:(6/255.0) alpha:1.0f];
    
    self.editButton.backgroundColor = mainColor;
    self.editButton.layer.cornerRadius = 3.0f;
    self.editButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.editButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    
    self.selectDate.backgroundColor = mainColor;
    self.selectDate.layer.cornerRadius = 3.0f;
    self.selectDate.titleLabel.font = [UIFont fontWithName:boldFontName size:16.0f];
    [self.selectDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectDate setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    

    

    // Populate outlets with event details
    self.detailNameLabel.text = self.currentEvent.eventName;
    self.detailDetailLabel.text = self.currentEvent.eventDetails;
    self.calendarLabel.text = self.currentEvent.eventCalendar;
    
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    EKAuthorizationStatus eventAuthStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (eventAuthStatus == EKAuthorizationStatusAuthorized) {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString (@"No Calendar Access", nil)
                                                        message: NSLocalizedString (@"Please allow access to Calendars via Settings > Privacy > Calendars.", nil)
                                                        delegate: self
                                                cancelButtonTitle: NSLocalizedString (@"Cancel", nil)
                                                otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
}


    
    




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"editEvent"]) {
        EditEventViewController *editvc = [segue destinationViewController];
        [editvc setDelegate:self];
        [editvc setEventStore:_eventStore];
        [editvc setEditEvent:_currentEvent];
    }
    if ([segue.identifier isEqualToString:@"dateSelect"]) {
        SelectDateViewController *datevc = [segue destinationViewController];
        [datevc setDelegate:self];
        NSDate *selectedDate;
        [datevc setEventDateSelected:selectedDate];
    }

    
}


-(void)controller:(EditEventViewController *)controller didUpdateEvent:(Event *)event
{
    self.detailNameLabel.text = event.eventName;
    self.detailDetailLabel.text = event.eventDetails;
    self.calendarLabel.text = event.eventCalendar;
    
    // Notify delegate
    [self.delegate controller:self didUpdateEvent:event];
}



-(void)controller:(SelectDateViewController *)controller didUpdateDateForEvent:(NSDate *)selectedDate
{
    self.didSelectDate = TRUE;
    tempDate = selectedDate;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)PostEvent:(id)sender {
    
    NSArray *calendarsArray = [[NSArray alloc] init];
    calendarsArray = [_eventStore calendarsForEntityType:EKEntityTypeEvent];
            
    if ([_eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    NSLog(@"ERROR OCCURRED!");                }
                else if (!granted)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString (@"No Calendar Access", nil)
                                                                   message: NSLocalizedString (@"Please allow access to Calendars via Settings > Privacy > Calendars.", nil)
                                                                  delegate: self
                                                         cancelButtonTitle: NSLocalizedString (@"Cancel", nil)
                                                         otherButtonTitles:nil];
                    [alert show];
                    //NSLog(@"ACCESS DENIED!");    
                }
                else
                {
                    // access granted
                    // do the important stuff here
                    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
                    event.title = self.currentEvent.eventName;
                    event.notes = self.currentEvent.eventDetails;
                    if (self.didSelectDate) {
                        event.startDate = tempDate;
                        self.currentEvent.eventDate = tempDate;
                    }
                    else
                    {
                        event.startDate = [[NSDate alloc] init]; 
                    }
                
                    
                    event.endDate = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
                    event.availability = EKEventAvailabilityFree;
                    
                    
                    // Get index of calendar that matches the calendarLabel
                    int i = 0;
                    for (EKCalendar *calendar in calendarsArray) {
                        if ([calendar.title isEqualToString: _calendarLabel.text]) {
                            calIndex = i;
                            calendarFound = YES;
                        }
                        i++;
                    }
                    
                    // Account for previously available calendar no longer being available.
                    if (!calendarFound) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString (@"Calendar Not Found!", nil)
                                                                       message: NSLocalizedString (@"Please edit and select available calendar.", nil)
                                                                      delegate: self
                                                             cancelButtonTitle: NSLocalizedString (@"OK", nil)
                                                             otherButtonTitles:nil];
                        
                        [alert show];
                    }
                    else
                    {
                        event.calendar = [calendarsArray objectAtIndex:calIndex];
                        
                        NSError *err;
                        
                        // Save event to calendar
                        [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                        
                        self.currentEvent.eventDate = event.startDate;
                        
                        // Store the event id in a string
                        NSString *idStr = [[NSString alloc] initWithFormat:@"%@", event.eventIdentifier];
                        
                        // Convert the string to a NSURL
                        NSURL *url = [[NSURL alloc] initWithString:idStr];
                        
                        // Store event id in the event's url field.
                        event.URL = url;

                        // Recall the event using the event id string
                        EKEvent *ev = [_eventStore eventWithIdentifier:idStr];
                        
                        if(err){
                            NSLog(@"Error: %@",[err localizedDescription]);
                        }
                        else
                        {
                            
                            // store the event identifier in the event url field
                            ev.URL = url;
                        }
                        
                        
                        // Save the event with updated url field.
                        [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                        
                        
                        // Get the latest post date from the events history
                        self.currentEvent.eventDate = [self getHistoryOfEvent];
                        
                        
                        
                        if (!err) {
                            UIAlertView *alert = [[UIAlertView alloc]
                                                  initWithTitle:NSLocalizedString(@"Posted to calendar", nil)
                                                  message:NSLocalizedString(@"Occurrance successfully posted to calendar.", nil)
                                                  //message:@"Occurrance successfully posted to calendar."
                                                  delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                  otherButtonTitles:nil];
                            [alert show];
                        }

                        
                        
                        [self.delegate controller:self didUpdateEvent:_currentEvent];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    calendarFound = NO;
                    
                }
            });
        }];
    }
        else
            // For ios 4 and 5
        {
            // do the important stuff here
            EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
            event.title = self.currentEvent.eventName;
            event.notes = self.currentEvent.eventDetails;
            
            if (self.didSelectDate) {
                event.startDate = tempDate;
                self.currentEvent.eventDate = tempDate;
            }
            else
            {
                event.startDate = [[NSDate alloc] init];
            }
            
            event.endDate = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
            event.availability = EKEventAvailabilityFree;
            
            
            // Get index of calendar that matches the calendarLabel
            int i = 0;
            for (EKCalendar *calendar in calendarsArray) {
                if ([calendar.title isEqualToString: _calendarLabel.text]) {
                    calIndex = i;
                    calendarFound = YES;
                }
                i++;
            }
            
            // Account for previously available calendar no longer being available.
            if (!calendarFound) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString (@"Calendar Not Found!", nil)
                                                               message: NSLocalizedString (@"Please edit and select available calendar.", nil)
                                                              delegate: self
                                                     cancelButtonTitle: NSLocalizedString (@"OK", nil)
                                                     otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                event.calendar = [calendarsArray objectAtIndex:calIndex];
                
                NSError *err;
                
                // Save event to calendar
                [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                
                self.currentEvent.eventDate = event.startDate;
                
                // Store the event id in a string
                NSString *idStr = [[NSString alloc] initWithFormat:@"%@", event.eventIdentifier];
                
                // Convert the string to a NSURL
                NSURL *url = [[NSURL alloc] initWithString:idStr];
                
                // Store event id in the event's url field.
                event.URL = url;
                
                // Recall the event using the event id string
                EKEvent *ev = [_eventStore eventWithIdentifier:idStr];
                
                if(err){
                    NSLog(@"Error: %@",[err localizedDescription]);
                }
                else
                {
                    
                    // store the event identifier in the event url field
                    ev.URL = url;
                }
                
                // Save the event with updated url field.
                [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                
                // Get the latest post date from the events history
                self.currentEvent.eventDate = [self getHistoryOfEvent];
                
                if (!err) {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Posted to calendar", nil)
                                          message:NSLocalizedString(@"Occurrance successfully posted to calendar.", nil)
                                          delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                
                
                [self.delegate controller:self didUpdateEvent:_currentEvent];
                [self.navigationController popViewControllerAnimated:YES];
            }
            calendarFound = NO;

        }

}


-(NSDate *)getHistoryOfEvent
{
    store = [[EKEventStore alloc] init];
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Bug fix start: BFv.2.3
    
    int year = 3; // BFv.2.3
    int month = 0; // BFv.2.3
    int day = 0; // BFv.2.3
    NSInteger thisYear = [[[NSCalendar currentCalendar]
                     components:NSYearCalendarUnit fromDate:[NSDate date]]
                    year];                                                  // BFv.2.3
    int predicateYear = 2004; // BFv.2.3
    
    
    NSArray *events = [[NSArray alloc] init];
    NSMutableArray *eventsAggregate = [[NSMutableArray alloc] init]; // BFv.2.3
    
    // Iterate in 4 year bursts to get all events from 01/01/2004 to current date.  BFv.2.3
    while (predicateYear <= thisYear) {    // BFv.2.3
        
        // Create the start date
        NSCalendar * gregorian = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate: 0];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear: year]; // n years past the reference date of 1-January-2001
        [comps setMonth: month]; // n months past January
        [comps setDay:day]; // n days past the first day of January
        NSDate *startDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        
        
        
        // Create the end date components
        NSDateComponents *oneDayFromNowComponents = [[NSDateComponents alloc] init];
        oneDayFromNowComponents.day = 1;
        NSDate *oneDayFromNow = [calendar dateByAddingComponents:oneDayFromNowComponents
                                                          toDate:[NSDate date]
                                                         options:0];
        
        // Create the predicate from the event store's instance method
        NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate
                                                                endDate:oneDayFromNow
                                                              calendars:nil];
        
        // Fetch all events that fall between the predicate dates.
        events = [store eventsMatchingPredicate:predicate];
        
        // Add these events to the eventsAggregate array. // BFv.2.3
        for (NSArray *pEvents in events) {
            [eventsAggregate addObject:pEvents];
        }
        
        year += 4;  // BFv.2.3
        predicateYear += 4;  // BFv.2.3
        
    }
    
    // Bug fix end: BFv.2.3
    
    NSMutableArray *mutableEvents = [[NSMutableArray alloc]init];
    
    for (EKEvent *ievents in events) {
        if ([ievents.title isEqualToString:[self.currentEvent eventName]]) {
            [mutableEvents addObject:(ievents)];
            [ievents notes];
        }
    }
    
    
    if ([mutableEvents count] == 0) {
        return tempDate;
    } else {
        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"startDate" ascending: NO];
        sortedArray = [mutableEvents sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
        [mutableEvents removeAllObjects];
        [mutableEvents addObjectsFromArray:sortedArray];
        
        EKEvent *ce = [mutableEvents objectAtIndex:0];
        
        
        return [ce startDate];
    }
    
}


- (IBAction)selectDateButton:(id)sender {
}
@end
