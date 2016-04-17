//
//  Event.m
//  EventTracker
//  github second commit
//  Created by Kevin McCafferty on 27/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import "Event.h"

@implementation Event


-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.eventName forKey:@"eventName"];
    [coder encodeObject:self.eventDetails forKey:@"eventDetails"];
    [coder encodeObject:self.eventDate forKey:@"eventDate"];
    [coder encodeObject:self.eventCalendar forKey:@"eventCalendar"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        [self setUuid:[decoder decodeObjectForKey:@"uuid"]];
        [self setEventName:[decoder decodeObjectForKey:@"eventName"]];
        [self setEventDetails:[decoder decodeObjectForKey:@"eventDetails"]];
        [self setEventDate:[decoder decodeObjectForKey:@"eventDate"]];
        [self setEventCalendar:[decoder decodeObjectForKey:@"eventCalendar"]];
    }
    return self;
}

+(Event *)createEventWithName:(NSString *)name detail:(NSString *)detail Date:(NSDate *)date andCalendar:(NSString *)eventCalendar {
    // initialize item
    Event *event = [[Event alloc]init];
    [event setEventName:name];
    [event setEventDetails:detail];
    [event setEventDate:date];
    [event setEventCalendar:eventCalendar];
    [event setUuid:[[NSUUID UUID]UUIDString]];
    return event;
}


@end
