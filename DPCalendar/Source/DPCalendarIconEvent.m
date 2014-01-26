//
//  DPCalendarIconEvent.m
//  DPCalendar
//
//  Created by Ethan Fang on 8/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarIconEvent.h"

@implementation DPCalendarIconEvent

-(id)initWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime icon:(UIImage *)icon {
    self = [super init];
    if (self) {
        _startTime = startTime;
        _endTime = endTime;
        _icon = icon;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime icon:(UIImage *)icon bkgColorIndex:(uint)bkgColorIndex{
    self = [super init];
    if (self) {
        _title = title;
        _startTime = startTime;
        _endTime = endTime;
        _icon = icon;
        _bkgColorIndex = bkgColorIndex;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Title:%@, StartTime:%@, EndTime:%@", self.title, self.startTime, self.endTime];
}

@end
