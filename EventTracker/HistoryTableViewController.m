//
//  HistoryTableViewController.m
//  EventTracker
//
//  Created by Kevin McCafferty on 12/04/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import "HistoryTableViewController.h"
#import <EventKit/EventKit.h>
#import "HistoryCell.h"
#import "EventTrackerAppDelegate.h"

@interface HistoryTableViewController ()
@property int selectedRowIndex;
@end

@implementation HistoryTableViewController

NSArray *sortedArray;
NSDate *todaysDate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    todaysDate = [[NSDate alloc]init];
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"startDate" ascending: NO];
    sortedArray = [_eventsHistory sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    [_eventsHistory removeAllObjects];
    [_eventsHistory addObjectsFromArray:sortedArray];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_eventsHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"historyCell";
    HistoryCell *cell = (HistoryCell *)[tableView
                                      dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    EKEvent *event;
    event = [_eventsHistory objectAtIndex:indexPath.row];

    
    cell.nameLabel.textColor = [UIColor colorWithRed:(124/255.0) green:(4/255.0) blue:(6/255.0) alpha:(1)];
	cell.nameLabel.text = [event title];
    cell.dateLabel.textColor = [UIColor colorWithRed:(124/255.0) green:(4/255.0) blue:(6/255.0) alpha:(1)];
    
    
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:event.startDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];
    
    
    // The time interval
    NSTimeInterval theTimeInterval = [todaysDate timeIntervalSinceDate:event.startDate];
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSMutableString *timeLapseString1;
    NSMutableString *timeLapseString2;
    
    
    
    if ([breakdownInfo month] > 0) {
        if ([breakdownInfo month] == 1) {
            timeLapseString1 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo month], NSLocalizedString(@"month", nil)];
        } else
        {
          timeLapseString1 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo month], NSLocalizedString(@"months", nil)];
        }
        if ([breakdownInfo day] == 1) {
            timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo day], NSLocalizedString(@"day", nil)];
        }else
        {
         timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo day], NSLocalizedString(@"days", nil)];
        }
        
    }else if ([breakdownInfo day] > 0){
        
        if ([breakdownInfo day] == 1) {
            timeLapseString1 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo day], NSLocalizedString(@"day", nil)];
        } else
        {
            timeLapseString1 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo day], NSLocalizedString(@"days", nil)];
        }
        if ([breakdownInfo hour] == 1) {
            timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo hour], NSLocalizedString(@"hour", nil)];
        }else
        {
            timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo hour], NSLocalizedString(@"hours", nil)];
        }


    }else if ([breakdownInfo hour] > 0){
        
        
        if ([breakdownInfo hour] == 1) {
            timeLapseString1 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo hour], NSLocalizedString(@"hour", nil)];
        } else
        {
            timeLapseString1 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo hour], NSLocalizedString(@"hours", nil)];
        }
        if ([breakdownInfo minute] == 1) {
            timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo minute], NSLocalizedString(@"min", nil)];
        }else
        {
            timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo minute], NSLocalizedString(@"mins", nil)];
        }

        
    }else{
        timeLapseString1 = NULL;
        if ([breakdownInfo minute] == 1) {
            timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo minute], NSLocalizedString(@"min", nil)];

        }else
        {
           timeLapseString2 = [NSMutableString stringWithFormat:@"%ld %@", (long)[breakdownInfo minute], NSLocalizedString(@"mins", nil)];
 
        }
    }

    

    cell.timeSince1.text = timeLapseString1;
    cell.timeSince2.text = timeLapseString2;
	cell.dateLabel.text = dateString;
	cell.detailText.text = [event notes];

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
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
                                                
                        // Get event to be deleted from the array
                        EKEvent *delEvent = [sortedArray objectAtIndex:indexPath.row];
                        
                        // get the event identifier from the events url field
                        NSString *myURLstring = [NSString stringWithFormat:@"%@", delEvent.URL];
                        

                        //EKEventStore* store = [[EKEventStore alloc] init];
                        
                        // Get the event using the event identifier
                        EKEvent* event2 = [self.eventStore eventWithIdentifier:myURLstring];
                       
                        if (event2 != nil) {
                            NSError* err = nil; 
                            [self.eventStore removeEvent:event2 span:EKSpanThisEvent error:&err];
                        }
                        
                        
                        //[self.eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
                        
                        // Delete item from items
                        [_eventsHistory removeObjectAtIndex:[indexPath row]];
                        
                        // Bug fix - deleting history cells not working
                        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"startDate" ascending: NO];
                        sortedArray = [_eventsHistory sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
                        [_eventsHistory removeAllObjects];
                        [_eventsHistory addObjectsFromArray:sortedArray];
                        
                        // Update table view
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                        
                        if ([_eventsHistory count] > 0) {
                            EKEvent *lastEvent = [_eventsHistory objectAtIndex:0];
                            _currentEvent.eventDate = lastEvent.startDate;
                        } else {
                            _currentEvent.eventDate = nil;
                        }
                        [self.delegate controller:self didUpdateEvent:_currentEvent];                        
                    }
                });
            }];
        }
        else
            // For ios 4 and 5
        {
            // do the important stuff here
            // Get event to be deleted from the array
            EKEvent *delEvent = [sortedArray objectAtIndex:indexPath.row];
            
            // get the event identifier from the events url field
            NSString *myURLstring = [NSString stringWithFormat:@"%@", delEvent.URL];
            
            
            // Get the event using the event identifier
            EKEvent* event2 = [self.eventStore eventWithIdentifier:myURLstring];
            
            if (event2 != nil) {
                NSError* err = nil;
                [self.eventStore removeEvent:event2 span:EKSpanThisEvent error:&err];
            }
            
            
            // Delete item from items
            [_eventsHistory removeObjectAtIndex:[indexPath row]];
            
            // Update table view
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            if ([_eventsHistory count] > 0) {
                EKEvent *lastEvent = [_eventsHistory objectAtIndex:0];
                _currentEvent.eventDate = lastEvent.startDate;
            } else {
                _currentEvent.eventDate = nil;
            }
            [self.delegate controller:self didUpdateEvent:_currentEvent];
        }
        
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    _selectedRowIndex = (int)[indexPath row];
    [tableView beginUpdates];
    [tableView endUpdates];
}


-(int)dateDiffrenceFromDate:(NSString *)date1 second:(NSString *)date2 {
    // Manage Date Formation same for both dates
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSDate *startDate = [formatter dateFromString:date1];
    NSDate *endDate = [formatter dateFromString:date2];
    
    
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
    int dayDiff = (int)[difference day];
    
    return dayDiff;
}


@end
