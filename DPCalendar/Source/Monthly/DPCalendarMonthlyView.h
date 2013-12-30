//
//  DPCalendarMonthlyView.h
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DP_MINUTE 60.f
#define DP_HOUR   DP_MINUTE * 60.f
#define DP_DAY    DP_HOUR * 24.f
#define DP_WEEK   DP_DAY * 7.f
#define DP_YEAR   DP_DAY * 365.f

@interface DPCalendarMonthlyView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

//Start date of the calendar view. By default it is 50 years before today
@property (nonatomic, strong) NSDate *startDate;

//End date of the calendar view. By default it is 50 years after today.
@property (nonatomic, strong) NSDate *endDate;

//Current selected date
@property (nonatomic, readonly) NSDate *selectedDate;

//Current selected month
@property (nonatomic, readonly) NSDate *seletecedMonth;

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@property(nonatomic,strong) UIColor *separatorColor;

//Background Color for monthly scroll view
@property(nonatomic, strong) UIColor *monthlyViewBackgroundColor;

@property (nonatomic) CGFloat dayCellHeight;
@property (nonatomic) CGFloat dayHeaderHeight;
@property (nonatomic) CGFloat bottomCellHeight;

@end
