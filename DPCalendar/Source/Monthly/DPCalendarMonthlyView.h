//
//  DPCalendarMonthlyView.h
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPCalendarMonthlySingleMonthCell.h"

extern NSString *const DPCalendarMonthlyViewAttributeCellHeight;
extern NSString *const DPCalendarMonthlyViewAttributeWeekdayHeight;
extern NSString *const DPCalendarMonthlyViewAttributeMonthRows;
extern NSString *const DPCalendarMonthlyViewAttributeEventColors;

@protocol DPCalendarMonthlyViewDelegate <NSObject>

-(void) didScrollToMonth:(NSDate *)month;

@optional
- (Class) monthlyCellClass;
- (Class) monthlyWeekdayClassClass;

- (BOOL) shouldHighlightItemWithDate:(NSDate *)date;
- (BOOL) shouldSelectItemWithDate:(NSDate *)date;
- (void) didSelectItemWithDate:(NSDate *)date;

- (NSDictionary *) monthlyViewAttributes;
@end

@interface DPCalendarMonthlyView : UIScrollView<UICollectionViewDataSource, UICollectionViewDelegate>

//Current selected date
@property (nonatomic, readonly) NSDate *selectedDate;

//Current selected month
@property (nonatomic, readonly) NSDate *seletedMonth;

@property(nonatomic,strong) UIColor *separatorColor;

//Background Color for monthly scroll view
@property(nonatomic, strong) UIColor *monthlyViewBackgroundColor;

@property (nonatomic, weak) id<DPCalendarMonthlyViewDelegate> monthlyViewDelegate;

@property (nonatomic, assign) NSArray *events;

-(id)initWithFrame:(CGRect)frame delegate:(id<DPCalendarMonthlyViewDelegate>)monthViewDelegate;

-(void) scrollToMonth:(NSDate *)month;
-(void) scrollToPreviousMonth;
-(void) scrollToNextMonth;

@end
