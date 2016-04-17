//
//  HistoryTableViewController.h
//  EventTracker
//
//  Created by Kevin McCafferty on 12/04/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <EventKit/EventKit.h>

@protocol HistoryTableViewControllerDelegate;

@interface HistoryTableViewController : UITableViewController

@property NSMutableArray *eventsHistory;
@property NSString *chosenEvent;
@property (strong, nonatomic) Event *currentEvent;
@property (weak, nonatomic) EKEventStore *eventStore;
@property (weak) id<HistoryTableViewControllerDelegate> delegate;

@end



@protocol HistoryTableViewControllerDelegate <NSObject>
-(void)controller:(HistoryTableViewController *)controller didUpdateEvent:(Event *)event;
@end