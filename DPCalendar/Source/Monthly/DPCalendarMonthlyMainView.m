//
//  DPCalendarMonthlyMainView.m
//  DPCalendar
//
//  Created by Ethan Fang on 6/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyMainView.h"
#import "DPCalendarMonthlyHorizontalScrollView.h"
#import "DPCalendarMonthlyView.h"
#import "NSDate+DP.h"

@interface DPCalendarMonthlyMainView()<DPCalendarMonthlyHorizontalScrollViewDelegate,DPCalendarMonthlyViewDelegate>

@property (nonatomic, strong) DPCalendarMonthlyHorizontalScrollView *bottomView;
@property (nonatomic, strong) DPCalendarMonthlyView *monthlyView;
@end

@implementation DPCalendarMonthlyMainView

- (id)initWithFrame:(CGRect)frame dayHeaderHeight:(CGFloat )dayHeaderHeight dayCellHeight:(CGFloat )dayCellHeight bottomCellHeight:(CGFloat) bottomCellHeight{
    self = [super initWithFrame:frame];
    if (self) {
        NSDate *today = [NSDate date];
        self.startDate = [today dateByAddingYears:-50 months:0 days:0];
        self.endDate = [today dateByAddingYears:50 months:0 days:0];
        
        self.dayHeaderHeight = dayHeaderHeight;
        self.dayCellHeight = dayCellHeight;
        self.bottomCellHeight = bottomCellHeight;
        
        [self monthlyView];
        [self bottomView];
    }
    return self;
}

-(DPCalendarMonthlyHorizontalScrollView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[DPCalendarMonthlyHorizontalScrollView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - self.bottomCellHeight, self.bounds.size.width, self.bottomCellHeight) currentMonth:[NSDate new] startDate:self.startDate endDate:self.endDate];
        _bottomView.scrollViewDelegate = self;
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

-(DPCalendarMonthlyView *)monthlyView {
    if (!_monthlyView) {
        float monthsScrollViewHeight = self.dayHeaderHeight + self.dayCellHeight * 6;
        float y = ((self.bounds.size.height - self.bottomCellHeight) < monthsScrollViewHeight) ? 0 : (self.bounds.size.height - self.bottomCellHeight - monthsScrollViewHeight);
        
        _monthlyView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, self.bounds.size.height - self.bottomCellHeight) dayHeaderHeight:self.dayHeaderHeight dayCellHeight:self.dayCellHeight];
        _monthlyView.monthlyViewDelegate = self;
        [self addSubview:_monthlyView];
    }
    return _monthlyView;
}

#pragma mark DPCalendarMonthlyHorizontalScrollViewDelegate
-(void)monthSelected:(NSDate *)month {
    [self.monthlyView scrollToMonth:month];
}

#pragma mark DPCalendarMonthlyViewDelegate 
-(void)didScrollToMonth:(NSDate *)month {
    [self.bottomView scrollHorizontalMonthsViewToMonth:month];
}

@end
