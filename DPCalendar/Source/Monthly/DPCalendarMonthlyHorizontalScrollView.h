//
//  DPCalendarMonthlyHorizontalScrollView.h
//  DPCalendar
//
//  Created by Shan Wang on 31/12/2013.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPCalendarMonthlyHorizontalScrollViewDelegate<NSObject>

@optional
- (void) monthSelected:(NSDate *)month;

@end

@interface DPCalendarMonthlyHorizontalScrollView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id<DPCalendarMonthlyHorizontalScrollViewDelegate> scrollViewDelegate;

//Start date of the calendar view. By default it is 50 years before today
@property (nonatomic, strong) NSDate *startDate;

//End date of the calendar view. By default it is 50 years after today.
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSDate *currentMonth;

@property (nonatomic) CGFloat bottomCellHeight;


//functions
- (id) initWithFrame:(CGRect)frame currentMonth:(NSDate *)currentMonth startDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void) scrollToCurrentMonth;
- (void) scrollHorizontalMonthsViewToMonth:(NSDate *)month;
@end

