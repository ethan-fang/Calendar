//
//  DPCalendarIconEvent.h
//  DPCalendar
//
//  Created by Ethan Fang on 8/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPCalendarIconEvent : NSObject

@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSDate *endTime;
@property (nonatomic, readonly) uint bkgColorIndex;


-(id)initWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime icon:(UIImage *)icon;
-(id)initWithTitle:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime icon:(UIImage *)icon bkgColorIndex:(uint)bkgColorIndex;
@end
