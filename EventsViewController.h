//
//  EventsViewController.h
//  EventTracker
//
//  Created by Kevin McCafferty on 27/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventViewController.h"
#import "EditEventViewController.h"
#import "EventDetailViewController.h"
#import "Event.h"
#import "HistoryTableViewController.h"



@interface EventsViewController : UITableViewController  <AddEventViewControllerDelegate, EditEventViewControllerDelegate, EventDetailViewControllerDelegate, HistoryTableViewControllerDelegate>

- (IBAction)editItem:(id)sender;


@end
