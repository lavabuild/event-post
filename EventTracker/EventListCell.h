//
//  EventListCell.h
//  EventTracker
//
//  Created by Kevin McCafferty on 29/04/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventName;

@property (weak, nonatomic) IBOutlet UILabel *eventDate;

@end
