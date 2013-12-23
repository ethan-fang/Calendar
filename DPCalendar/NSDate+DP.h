//
//  NSDate+DP.h
//  DPCalendar
//
//  Created by Ethan Fang on 23/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DP)

+ (int) monthsDifferenceBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSDate *)dateByAddingYears:(int)years months:(int)months days:(int)days;

- (instancetype)dp_firstDateOfMonth:(NSCalendar *)calendar;

- (instancetype)dp_lastDateOfMonth:(NSCalendar *)calendar;

- (instancetype)dp_dateWithDay:(NSUInteger)day calendar:(NSCalendar *)calendar;
@end
