//
//  Event.h
//  EventTracker
//  test github
//  Created by Kevin McCafferty on 27/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property NSString *uuid;
@property NSString *eventName;
@property NSString *eventDetails;
@property NSDate *eventDate;
@property NSString *eventCalendar;


+(Event *)createEventWithName:(NSString *)name detail:(NSString *)detail Date:(NSDate *)date andCalendar:(NSString *)eventCalendar;

@end
