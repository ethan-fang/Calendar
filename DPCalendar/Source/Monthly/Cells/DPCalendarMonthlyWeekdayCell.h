//
//  DPCalendarMonthlyWeekdayCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 23/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPCalendarMonthlyCell.h"

@interface DPCalendarMonthlyWeekdayCell : DPCalendarMonthlyCell

@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, assign) NSString *weekday;

@property (nonatomic, strong) UIFont *font;

@end
