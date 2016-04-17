//
//  EventsViewController.m
//  EventTracker
//
//  Created by Kevin McCafferty on 27/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//
//  BFv.2.3 Fixes issue of only getting events of the last 4 years.

#import <UIKit/UIKit.h>
#import "EventsViewController.h"
#import "Event.h"
#import <EventKit/EventKit.h>
#import "AddEventViewController.h"
#import "EventDetailViewController.h"
#import "HistoryTableViewController.h"
#import "EventListCell.h"

@interface EventsViewController ()
// EVENTS ARRAY
@property NSMutableArray *eventsArray;
@property int chosenIndex;
@end


bool accessGranted;

@implementation EventsViewController

#pragma mark - Initialise

EKEventStore *store;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Load Items
        [self loadItems];
    }
    return self;
}



-(void)resetView
{
    //reset your view components.
    [self.view setNeedsDisplay];
}

-(void)viewWillAppear
{
    [self resetView];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadItems];
    store = [[EKEventStore alloc] init];
    
        if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    NSLog(@"ERROR OCCURRED!");                }
                else if (!granted)
                {
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"No Calendar Access"
//                                                                   message: @"Please allow access to Calendars via Settings > Privacy > Calendars."
//                                                                  delegate: self
//                                                         cancelButtonTitle:@"Cancel"
//                                                         otherButtonTitles:nil];
//                    [alert show];
                    //NSLog(@"ACCESS DENIED!");
                }
                else
                {
                    // access granted
                    // do the important stuff here
                    NSLog(@"allowed ok OCCURRED!");
                    
                }
            });
        }];
    }
    
    
    /* Are there any calendars available to the event store? */
    if ([[store calendarsForEntityType:EKEntityTypeEvent] count] == 0){
        NSLog(@"No calendars are found.");
    }

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // If no calendar exists, create one.
    if ([defaults objectForKey:@"Calendar"] == nil || ![store calendarWithIdentifier:[defaults objectForKey:@"Calendar"]]) // Create Calendar if Needed
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
    return YES;
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if (!accessGranted) {
        accessGranted = YES;
        [self viewDidLoad];
    }
    
    if ([segue.identifier isEqualToString:@"addEvent"]) {
        AddEventViewController *avc = [[[segue destinationViewController]viewControllers]objectAtIndex:0];
        [avc setEventStore:store];
        // Set Delegate
        [avc setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"detailEvent"]) {
        
        EventDetailViewController *edc = [segue destinationViewController];
        [edc setEventStore:store];
        // Set Delegate
        [edc setDelegate:self];
        
        // Get currently selected event from array and pass to CurrentEvent property in EventDetailViewController
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Event *e = [_eventsArray objectAtIndex:path.row];
        [edc setCurrentEvent:e];
        [edc setDidSelectDate:FALSE];
    }
    if ([segue.identifier isEqualToString:@"segueHistory"]) {
        
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
            
        }  // End of while loop
        
        // Bug fix end: BFv.2.3
        
        // Get the event that was choosen, e.g. Bought Home Heating Oil
        Event *ce = [_eventsArray objectAtIndex:_chosenIndex];

        
        HistoryTableViewController *hvc = [segue destinationViewController];
        NSMutableArray *mutableEvents = [[NSMutableArray alloc]init];
        
        for (EKEvent *ievents in eventsAggregate) {
            
            if ([ievents.title isEqualToString:[ce eventName]]) {
                [mutableEvents addObject:(ievents)];
                [ievents notes];
            }
            
        }
        
        if ([mutableEvents count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString (@"No History", nil)
                                                           message: NSLocalizedString (@"No matching items in calendar.", nil)
                                                          delegate: self
                                                 cancelButtonTitle: NSLocalizedString (@"OK", nil)
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
        [hvc setEventStore:store];
        [hvc setEventsHistory:mutableEvents];
        [hvc setChosenEvent:[ce eventName]];
        [hvc setCurrentEvent:ce];
        [hvc setDelegate:self];
            
        
    }
    
}



- (void)alertView:(UIAlertView *)alertV didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //go back a page
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.eventsArray.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventListCell";
    // Use custom cell EventListCell
    EventListCell *cell = (EventListCell *)[tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    cell.shouldIndentWhileEditing = NO;
    
    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    myBackgroundView.backgroundColor = [UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    //}
    cell.backgroundView = myBackgroundView;
    
    // Fetch Event
    Event *event = [self.eventsArray objectAtIndex:indexPath.row];
    
    cell.eventName.lineBreakMode = NSLineBreakByWordWrapping;
    // dark dark red  cell.eventName.textColor = [UIColor colorWithRed:(124/255.0) green:(4/255.0) blue:(6/255.0) alpha:1];
    cell.eventName.textColor = [UIColor colorWithRed:(158/255.0) green:(11/255.0) blue:(15/255.0) alpha:1];
    
    [cell.eventName setFont:[UIFont fontWithName:@"Sansation_Regular" size:20.0]];
    [cell.eventName setText:[event eventName]];
    
    NSDate *todaysDate = [NSDate date];
    UIColor *dateColor;
    
    // Convert dates to strings to compare
    NSString *todaysDateString = [NSDateFormatter localizedStringFromDate:todaysDate dateStyle:NSDateFormatterFullStyle timeStyle:NO];
    NSString *compareDateString = [NSDateFormatter localizedStringFromDate:event.eventDate dateStyle:NSDateFormatterFullStyle timeStyle:NO];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:event.eventDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];
    
    // If post date is today, display "Today at" in green text.
    if ([todaysDateString isEqualToString:compareDateString]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *resultString = [dateFormatter stringFromDate: event.eventDate];
        // green dateColor = [UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(0/255.0) alpha:1];
        dateColor = [UIColor colorWithRed:(254/255.0) green:(104/255.0) blue:(10/255.0) alpha:1]; // orange
        //dateColor = [UIColor darkGrayColor];
        cell.eventDate.textColor = dateColor;
        cell.eventDate.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Today at", nil), resultString];
    }
    else {
        //dateColor = [UIColor colorWithRed:(222/255.0) green:(59/255.0) blue:(47/255.0) alpha:1];
        dateColor = [UIColor darkGrayColor];
        cell.eventDate.textColor = dateColor;
        [cell.eventDate setText:dateString];
    }
    
    return cell;
}



-(NSString *)pathForFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [path lastObject];
    return [documents stringByAppendingPathComponent:@"events.plist"];
}


-(void)loadItems
{
    NSString *filePath = [self pathForFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.eventsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    else
    {
        self.eventsArray = [[NSMutableArray alloc] init];
    }
}


-(void)saveItems
{
    NSString *filePath = [self pathForFile];
    [NSKeyedArchiver archiveRootObject:self.eventsArray toFile:filePath];
}




#pragma mark - My Delegates
// DELEGATES
-(void)controller:(AddEventViewController *)controller didSaveItemWithName:(NSString *)name detail:(NSString *)detail Date:(NSDate *)date andCalendar:(NSString *)eventCalendar;
{
    
    Event *event = [Event createEventWithName:name detail:detail Date:date andCalendar:eventCalendar];
        
    // Add event to the data source
    [self.eventsArray addObject:event];
    // Add Row to the table view
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.eventsArray count] -1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self saveItems];
    
}


-(void)controller:(EditEventViewController *)controller didUpdateEvent:(Event *)event
{
    // Fetch Item
    for (int i = 0; i < [self.eventsArray count]; i++) {
        Event *anEvent = [self.eventsArray objectAtIndex:i];
        if ([[anEvent uuid] isEqualToString:[event uuid]]) {
            // Update Table View Row
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    // Save Items
    [self saveItems];

}




- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _chosenIndex = (int)indexPath.row;
    
    EKAuthorizationStatus eventAuthStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (eventAuthStatus == EKAuthorizationStatusAuthorized) {
       [self performSegueWithIdentifier:@"segueHistory" sender:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString (@"No Calendar Access", nil)
                                                       message: NSLocalizedString (@"Please allow access to Calendars via Settings > Privacy > Calendars.", nil)
                                                      delegate: self
                                             cancelButtonTitle: NSLocalizedString (@"Cancel", nil)
                                             otherButtonTitles:nil];
        [alert show];
    }

    
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Identify segue to perform before going to prepareforsegue
    [self performSegueWithIdentifier:@"detailEvent" sender:nil];
    // Navigation logic may go here. Create and push another view controller.
    /*
    *detailViewController = [[ alloc] initWithNibName:@"" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES
     */
        
    
    
   
}

- (IBAction)editItem:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete item from items
        [self.eventsArray removeObjectAtIndex:[indexPath row]];
        // Update table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        // Save changes to disk
        [self saveItems];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Event *event = [self.eventsArray objectAtIndex:fromIndexPath.row];
    [_eventsArray removeObjectAtIndex:fromIndexPath.row];
    [_eventsArray insertObject:event atIndex:toIndexPath.row];
    [self saveItems];
    
}


@end
