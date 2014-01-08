//
//  DPCalendarIconEvent.h
//  DPCalendar
//
//  Created by Ethan Fang on 8/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPCalendarIconEvent : NSObject

@property (nonatomic) UIImage *icon;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@end
