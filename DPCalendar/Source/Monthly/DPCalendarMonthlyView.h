//
//  DPCalendarMonthlyView.h
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPCalendarMonthlySingleMonthCell.h"

extern NSString *const DPCalendarMonthlyViewAttributeWeekdayHeight;
extern NSString *const DPCalendarMonthlyViewAttributeWeekdayFont;

extern NSString *const DPCalendarMonthlyViewAttributeCellHeight;
extern NSString *const DPCalendarMonthlyViewAttributeDayFont;
extern NSString *const DPCalendarMonthlyViewAttributeEventFont;
extern NSString *const DPCalendarMonthlyViewAttributeCellRowHeight;
extern NSString *const DPCalendarMonthlyViewAttributeEventColors;
extern NSString *const DPCalendarMonthlyViewAttributeIconEventFont;
extern NSString *const DPCalendarMonthlyViewAttributeIconEventBkgColors;
extern NSString *const DPCalendarMonthlyViewAttributeCellNotInSameMonthColor;
extern NSString *const DPCalendarMonthlyViewAttributeCellHighlightedColor;
extern NSString *const DPCalendarMonthlyViewAttributeCellSelectedColor;
extern NSString *const DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable;

extern NSString *const DPCalendarMonthlyViewAttributeSeparatorColor;

extern NSString *const DPCalendarMonthlyViewAttributeStartDayOfWeek;
extern NSString *const DPCalendarMonthlyViewAttributeMonthRows;


@protocol DPCalendarMonthlyViewDelegate <NSObject>

-(void) didScrollToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;

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
@property (nonatomic, assign) NSArray *iconEvents;

-(id)initWithFrame:(CGRect)frame delegate:(id<DPCalendarMonthlyViewDelegate>)monthViewDelegate;

-(void) scrollToMonth:(NSDate *)month;
-(void) scrollToPreviousMonth;
-(void) scrollToNextMonth;

- (NSDate *)firstVisibleDateOfMonth:(NSDate *)date;
- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date;

@end
