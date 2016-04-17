//
//  SelectDateViewController.h
//  EventTracker
//
//  Created by Kevin McCafferty on 27/06/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@protocol SelectDateViewControllerDelegate;


@interface SelectDateViewController : UIViewController

@property (weak) id<SelectDateViewControllerDelegate>delegate;


@property (strong, nonatomic) NSDate *eventDateSelected;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end


@protocol SelectDateViewControllerDelegate <NSObject>
-(void)controller:(SelectDateViewController *)controller didUpdateDateForEvent:(NSDate *)dateSelected;

@end