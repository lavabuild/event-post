//
//  HistoryCell.h
//  EventTracker
//
//  Created by Kevin McCafferty on 17/04/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UILabel *timeSince1;
@property (weak, nonatomic) IBOutlet UILabel *timeSince2;

@end
