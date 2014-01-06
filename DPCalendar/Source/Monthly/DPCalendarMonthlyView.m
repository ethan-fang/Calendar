//
//  DPCalendarMonthlyView.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyView.h"
#import "DPCalendarMonthlySingleMonthCell.h"
#import "DPCalendarMonthlySingleMonthViewLayout.h"
#import "DPCalendarMonthlyWeekdayCell.h"
#import "DPCalendarMonthlyHorizontalScrollCell.h"
#import "NSDate+DP.h"
#import "DPCalendarMonthlyHorizontalScrollView.h"

@interface DPCalendarMonthlyView()<UIScrollViewDelegate, UICollectionViewDelegate, DPCalendarMonthlyHorizontalScrollViewDelegate>

//Circular and infinite uiscrollviews, currIndex is used for indicating the current page
@property (nonatomic) int currIndex;

@property (nonatomic, strong) NSMutableArray *pagingMonths;
@property (nonatomic, strong) NSMutableArray *pagingViews;

@property(nonatomic,strong) Class monthsHeaderViewClass;
@property(nonatomic,strong) Class monthsDayCellClass;

@property(nonatomic,strong,readwrite) NSArray *weekdaySymbols;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSCalendar *calendar;

@property(nonatomic) NSUInteger daysInWeek;

@property (nonatomic) BOOL manualScroll;

@end

NSString *const DPCalendarViewWeekDayCellIdentifier = @"DPCalendarViewWeekDayCellIdentifier";
NSString *const DPCalendarViewDayCellIdentifier = @"DPCalendarViewDayCellIdentifier";


@implementation DPCalendarMonthlyView

-(id)initWithFrame:(CGRect)frame dayHeaderHeight:(CGFloat )dayHeaderHeight dayCellHeight:(CGFloat )dayCellHeight {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithDayHeaderHeight:dayHeaderHeight dayCellHeight:dayCellHeight];
    }
    return self;
}

- (void) commonInitWithDayHeaderHeight:(CGFloat )dayHeaderHeight dayCellHeight:(CGFloat )dayCellHeight {
    
    self.calendar   = NSCalendar.currentCalendar;
    self.daysInWeek = 7;
    
    self.pagingMonths = @[].mutableCopy;
    self.pagingViews = @[].mutableCopy;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    self.weekdaySymbols = formatter.shortWeekdaySymbols;
    self.dayHeaderHeight = dayHeaderHeight;
    self.dayCellHeight = dayCellHeight;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.monthsDayCellClass = DPCalendarMonthlySingleMonthCell.class;
    self.monthsHeaderViewClass = DPCalendarMonthlyWeekdayCell.class;
    
    self.separatorColor = [UIColor redColor];
    self.monthlyViewBackgroundColor = [UIColor whiteColor];
    
    
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = YES;
    self.contentInset = UIEdgeInsetsZero;
    self.pagingEnabled = YES;
    self.delegate = self;
    
    NSDate *today = [NSDate date];
    [self.pagingMonths addObject:[today dateByAddingYears:0 months:-1 days:0]];
    [self.pagingMonths addObject:today];
    [self.pagingMonths addObject:[today dateByAddingYears:0 months:1 days:0]];
    
    [self.pagingViews addObject:[self singleMonthViewInFrame:self.bounds]];
    [self.pagingViews addObject:[self singleMonthViewInFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)]];
    [self.pagingViews addObject:[self singleMonthViewInFrame:CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height)]];
    
    [self addSubview:[self.pagingViews objectAtIndex:0]];
    [self addSubview:[self.pagingViews objectAtIndex:1]];
    [self addSubview:[self.pagingViews objectAtIndex:2]];
    
    
    [self setContentSize:CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height)];
    
}

-(void)setMonthlyViewBackgroundColor:(UIColor *)monthlyViewBackgroundColor {
    _monthlyViewBackgroundColor = monthlyViewBackgroundColor;
    self.backgroundColor = _monthlyViewBackgroundColor;
}


-(UICollectionView *)singleMonthViewInFrame:(CGRect )frame {
    DPCalendarMonthlySingleMonthViewLayout *layout = [[DPCalendarMonthlySingleMonthViewLayout alloc] init];
    UICollectionView *singleMonthView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    singleMonthView.translatesAutoresizingMaskIntoConstraints = NO;
    singleMonthView.showsHorizontalScrollIndicator = NO;
    singleMonthView.showsVerticalScrollIndicator = NO;
    singleMonthView.dataSource = self;
    singleMonthView.delegate = self;
    singleMonthView.allowsMultipleSelection = NO;
    singleMonthView.backgroundColor = [UIColor clearColor];
    [singleMonthView registerClass:self.monthsDayCellClass
         forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    [singleMonthView registerClass:self.monthsHeaderViewClass forCellWithReuseIdentifier:DPCalendarViewWeekDayCellIdentifier];
    
    return singleMonthView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.daysInWeek) {
        DPCalendarMonthlyWeekdayCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewWeekDayCellIdentifier
                                                  forIndexPath:indexPath];
        cell.separatorColor = self.separatorColor;
        cell.weekday = self.weekdaySymbols[indexPath.item];
        
        return cell;
    }
    
    DPCalendarMonthlySingleMonthCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier
                                              forIndexPath:indexPath];
    
    NSDate *monthDate = [self dateOfCollectionView:collectionView];
    NSDate *firstDateInMonth = [self firstVisibleDateOfMonth:monthDate];
    
    NSUInteger day = indexPath.item - self.daysInWeek;
    
    NSDateComponents *components =
    [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                     fromDate:firstDateInMonth];
    components.day += day;
    
    NSDate *date = [self.calendar dateFromComponents:components];
    [cell setDate:date calendar:self.calendar];
    
    cell.separatorColor = self.separatorColor;
    return cell;
    
}

-(NSDate *) dateOfCollectionView:(UICollectionView *)collectionView {
    return [self.pagingMonths objectAtIndex:[self.pagingViews indexOfObject:collectionView]];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *monthDate = [self dateOfCollectionView:collectionView];
    
    NSDateComponents *components =
    [self.calendar components:NSDayCalendarUnit
                     fromDate:[self firstVisibleDateOfMonth:monthDate]
                       toDate:[self lastVisibleDateOfMonth:monthDate]
                      options:0];
    
    return self.daysInWeek + components.day + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width      = self.bounds.size.width;
    CGFloat itemWidth  = roundf(width / self.daysInWeek);
    CGFloat itemHeight = indexPath.item < self.daysInWeek ? self.dayHeaderHeight : self.dayCellHeight;
    
    NSUInteger weekday = indexPath.item % self.daysInWeek;
    
    if (weekday == self.daysInWeek - 1) {
        itemWidth = width - (itemWidth * (self.daysInWeek - 1));
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (void) scrollToCurrentMonth {
    NSDate *today = [NSDate new];
    [self.pagingMonths setObject:today atIndexedSubscript:1];
    self.selectedDate = today;
    
    [self.monthlyViewDelegate didScrollToMonth:today];
}

- (NSDate *)firstVisibleDateOfMonth:(NSDate *)date {
    date = [date dp_firstDateOfMonth:self.calendar];
    
    NSDateComponents *components =
    [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:date];
    
    return [[date dp_dateWithDay:-((components.weekday - 1) % self.daysInWeek) calendar:self.calendar] dateByAddingTimeInterval:DP_DAY];
}

- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date {
    date = [date dp_lastDateOfMonth:self.calendar];
    
    NSDateComponents *components =
    [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:date];
    
    return
    [date dp_dateWithDay:components.day + (self.daysInWeek - 1) - ((components.weekday - 1) % self.daysInWeek)
                calendar:self.calendar];
}

- (void) reloadPagingViews {
    for (UICollectionView *collectionView in self.pagingViews) {
        [collectionView reloadData];
    }
}

- (void) adjustPreviousAndNextMonthPage {
    NSDate *currentMonth = [self.pagingMonths objectAtIndex:1];
    [self.pagingMonths setObject:[currentMonth dateByAddingYears:0 months:1 days:0] atIndexedSubscript:2];
    [self.pagingMonths setObject:[currentMonth dateByAddingYears:0 months:-1 days:0] atIndexedSubscript:0];
}

-(void)scrollToMonth:(NSDate *)month {
    int scrollToPosition = 1;
    if ([month compare:[self.pagingMonths objectAtIndex:1]] == NSOrderedDescending) {
        scrollToPosition = 2;
    } else if ([month compare:[self.pagingMonths objectAtIndex:1]] == NSOrderedAscending) {
        scrollToPosition = 0;
    }
    [self.pagingMonths setObject:month atIndexedSubscript:scrollToPosition];
    [self.pagingMonths setObject:month atIndexedSubscript:1];
    
    __weak typeof(DPCalendarMonthlyView) *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf setContentOffset:((UICollectionView *)[self.pagingViews objectAtIndex:scrollToPosition]).frame.origin];
    } completion:^(BOOL finished) {
        self.manualScroll = NO;
        [self adjustPreviousAndNextMonthPage];
        
        [self reloadPagingViews];
        [self scrollRectToVisible:((UICollectionView *)[self.pagingViews objectAtIndex:1]).frame animated:NO];
        [self.monthlyViewDelegate didScrollToMonth:[self.pagingMonths objectAtIndex:1]];
    }];
}

-(void)scrollToPreviousMonth {
    NSDate *previousMonth = [self.seletedMonth dateByAddingYears:0 months:-1 days:0];
    [self scrollToMonth:previousMonth];
}

-(void)scrollToNextMonth {
    NSDate *previousMonth = [self.seletedMonth dateByAddingYears:0 months:1 days:0];
    [self scrollToMonth:previousMonth];
}

-(NSDate *)seletedMonth {
    return [self.pagingMonths objectAtIndex:1];
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    // All data for the documents are stored in an array (documentTitles).
    // We keep track of the index that we are scrolling to so that we
    // know what data to load for each page.
    if(self.contentOffset.x > self.frame.size.width)
    {
        NSDate *currentMonth = [self.pagingMonths objectAtIndex:2];
        [self.pagingMonths setObject:currentMonth atIndexedSubscript:1];
        [self adjustPreviousAndNextMonthPage];
    }
    if(self.contentOffset.x < self.frame.size.width)
    {
        NSDate *currentMonth = [self.pagingMonths objectAtIndex:0];
        [self.pagingMonths setObject:currentMonth atIndexedSubscript:1];
        [self adjustPreviousAndNextMonthPage];
    }
    [self reloadPagingViews];
    [self.monthlyViewDelegate didScrollToMonth:[self.pagingMonths objectAtIndex:1]];
    
    [self scrollRectToVisible:((UICollectionView *)[self.pagingViews objectAtIndex:1]).frame animated:NO];
}

@end
