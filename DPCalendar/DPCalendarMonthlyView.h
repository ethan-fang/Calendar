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

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, readonly) NSDate *selectedDate;
@property (nonatomic, readonly) NSDate *seletecedMonth;

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate;


@property(nonatomic,strong) UIColor *separatorColor;

@property (nonatomic) CGFloat dayCellHeight;
@property (nonatomic) CGFloat dayHeaderHeight;

@end
