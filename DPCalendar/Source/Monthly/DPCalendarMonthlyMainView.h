//
//  DPCalendarMonthlyMainView.h
//  DPCalendar
//
//  Created by Ethan Fang on 6/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPCalendarMonthlyMainView : UIView

//Start date of the calendar view. By default it is 50 years before today
@property (nonatomic, strong) NSDate *startDate;

//End date of the calendar view. By default it is 50 years after today.
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic) CGFloat dayCellHeight;
@property (nonatomic) CGFloat dayHeaderHeight;
@property (nonatomic) CGFloat bottomCellHeight;

- (id)initWithFrame:(CGRect)frame dayHeaderHeight:(CGFloat )dayHeaderHeight dayCellHeight:(CGFloat )dayCellHeight bottomCellHeight:(CGFloat) bottomCellHeight;

@end
