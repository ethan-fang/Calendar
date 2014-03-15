//
//  NSDate+DP.h
//  DPCalendar
//
//  Created by Ethan Fang on 23/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DP_MINUTE 60.f
#define DP_HOUR   DP_MINUTE * 60.f
#define DP_DAY    DP_HOUR * 24.f
#define DP_WEEK   DP_DAY * 7.f
#define DP_YEAR   DP_DAY * 365.f

@interface NSDate (DP)

+ (NSInteger) monthsDifferenceBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSDate *)dateByAddingYears:(int)years months:(int)months days:(int)days;

- (instancetype)dp_firstDateOfMonth:(NSCalendar *)calendar;

- (instancetype)dp_lastDateOfMonth:(NSCalendar *)calendar;

- (instancetype)dp_dateWithDay:(NSUInteger)day calendar:(NSCalendar *)calendar;

- (instancetype)dp_dateWithoutTimeWithCalendar:(NSCalendar *)calendar;

@end
