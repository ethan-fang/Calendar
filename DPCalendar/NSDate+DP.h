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
@end
