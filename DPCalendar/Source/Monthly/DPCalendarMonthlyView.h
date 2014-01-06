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

@protocol DPCalendarMonthlyViewDelegate <NSObject>

-(void) didScrollToMonth:(NSDate *)month;

@optional
- (void) shouldHighlightItemWithDate:(NSData *)date;
- (void) shouldSelectItemWithDate:(NSDate *)date;
- (void) didSelectItemWithDate:(NSDate *)date;

@end

@interface DPCalendarMonthlyView : UIScrollView<UICollectionViewDataSource, UICollectionViewDelegate>

//Current selected date
@property (nonatomic, readonly) NSDate *selectedDate;

//Current selected month
@property (nonatomic, readonly) NSDate *seletedMonth;

@property(nonatomic,strong) UIColor *separatorColor;

//Background Color for monthly scroll view
@property(nonatomic, strong) UIColor *monthlyViewBackgroundColor;

@property (nonatomic) CGFloat dayCellHeight;
@property (nonatomic) CGFloat dayHeaderHeight;

@property (nonatomic, weak) id<DPCalendarMonthlyViewDelegate> monthlyViewDelegate;

-(id)initWithFrame:(CGRect)frame dayHeaderHeight:(CGFloat )dayHeaderHeight dayCellHeight:(CGFloat )dayCellHeight;

-(void) scrollToMonth:(NSDate *)month;
-(void) scrollToPreviousMonth;
-(void) scrollToNextMonth;

@end
