//
//  AddEventViewController.h
//  EventTracker
//
//  Created by Kevin McCafferty on 28/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <EventKit/EventKit.h>

@protocol AddEventViewControllerDelegate;

@interface AddEventViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (weak) id<AddEventViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *elementContainer;

@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextView *eventDetails;
@property NSMutableArray *myCalendarArray;
@property NSString *eventCalendar;
@property (weak, nonatomic) IBOutlet UILabel *detailPlaceholder;

@property (weak, nonatomic) EKEventStore *eventStore;


//@property (weak, nonatomic) IBOutlet UIScrollView *addScrollView;


//- (IBAction)backgroundButton:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end



@protocol AddEventViewControllerDelegate <NSObject>
-(void)controller:(AddEventViewController *)controller didSaveItemWithName:(NSString *)name detail:(NSString *)detail Date:(NSDate *)date andCalendar:(NSString *)eventCalendar;
@end