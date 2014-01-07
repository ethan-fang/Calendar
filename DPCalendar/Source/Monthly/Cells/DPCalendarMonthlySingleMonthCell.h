//
//  DPCalendarMonthlyCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPCalendarMonthlyCell.h"

@interface DPCalendarMonthlySingleMonthCell : DPCalendarMonthlyCell

-(void) setDate:(NSDate *)date calendar:(NSCalendar *)calendar events:(NSArray *)events;

@property (nonatomic) NSDate *firstVisiableDateOfMonth;

@property (nonatomic, strong) NSArray *eventColors;

@end
