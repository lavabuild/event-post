//
//  EventDetailViewController.h
//  EventTracker
//
//  Created by Kevin McCafferty on 30/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EditEventViewController.h"
#import "SelectDateViewController.h"


@protocol EventDetailViewControllerDelegate;



@interface EventDetailViewController : UIViewController <EditEventViewControllerDelegate, SelectDateViewControllerDelegate>

{
    UIButton *selectDateButton;
}

@property (weak) id<EventDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) Event *currentEvent;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *selectDate;

@property (weak, nonatomic) IBOutlet UIView *elementContainer;
@property (weak, nonatomic) IBOutlet UIView *iconImageContainer;

@property (weak, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *calendarLabel;
@property int indexOfChosen;
@property bool didSelectDate;


@property (weak, nonatomic) EKEventStore *eventStore;


- (IBAction)PostEvent:(id)sender;



@end


@protocol EventDetailViewControllerDelegate <NSObject>
-(void)controller:(EventDetailViewController *)controller didUpdateEvent:(Event *)event;
@end