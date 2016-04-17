//
//  EditEventViewController.h
//  EventTracker
//
//  Created by Kevin McCafferty on 05/04/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <EventKit/EventKit.h>
#import "SelectDateViewController.h"

@protocol EditEventViewControllerDelegate;


@interface EditEventViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (weak) id<EditEventViewControllerDelegate> delegate;

@property (strong, nonatomic) Event *editEvent;

@property (weak, nonatomic) IBOutlet UILabel *editEventName;
@property (weak, nonatomic) IBOutlet UITextView *editEventDetails;
@property NSMutableArray *myCalendarArray;
@property NSString *eventCalendar;
//@property (weak, nonatomic) IBOutlet UIScrollView *editScrollView;
@property (weak, nonatomic) IBOutlet UIView *detailsContainer;
@property (weak, nonatomic) IBOutlet UIPickerView *calendarPicker;

@property (weak, nonatomic) EKEventStore *eventStore;

- (IBAction)cancelEdit:(id)sender;


@end


@protocol EditEventViewControllerDelegate <NSObject>
-(void)controller:(EditEventViewController *)controller didUpdateEvent:(Event *)event;
@end
