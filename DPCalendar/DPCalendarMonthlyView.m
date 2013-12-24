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

@interface DPCalendarMonthlyView()<UIScrollViewDelegate, UICollectionViewDelegate>

//Circular and infinite uiscrollviews, currIndex is used for indicating the current page
@property (nonatomic) int currIndex;

@property (nonatomic, strong) NSMutableArray *pagingMonths;
@property (nonatomic, strong) NSMutableArray *pagingViews;
@property (nonatomic, strong) UIScrollView *monthsScrollView;

@property (nonatomic, strong) UICollectionView *monthsBottomView;


@property(nonatomic,strong) Class monthsHeaderViewClass;
@property(nonatomic,strong) Class monthsDayCellClass;
@property (nonatomic, strong) Class monthsBottomCellClass;

@property(nonatomic,strong,readwrite) NSArray *weekdaySymbols;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSCalendar *calendar;

@property(nonatomic) NSUInteger daysInWeek;

@end

NSString *const DPCalendarViewWeekDayCellIdentifier = @"DPCalendarViewWeekDayCellIdentifier";
NSString *const DPCalendarViewDayCellIdentifier = @"DPCalendarViewDayCellIdentifier";
NSString *const DPCalendarHorizontalCellIdentifier = @"DPCalendarHorizontalCellIdentifier";

@implementation DPCalendarMonthlyView

- (id)initWithFrame:(CGRect)frame
{
    NSDate *today = [NSDate date];
    return [self initWithFrame:frame startDate:[today dateByAddingYears:-50 months:0 days:0] endDate:[today dateByAddingYears:50 months:0 days:0]];
}

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithStartDate:startDate endDate:endDate];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDate *today = [NSDate date];
        [self commonInitWithStartDate:[today dateByAddingYears:-50 months:0 days:0] endDate:[today dateByAddingYears:50 months:0 days:0]];
    }
    return self;
}

- (void) commonInitWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    self.calendar   = NSCalendar.currentCalendar;
    self.daysInWeek = 7;
    
    self.dayHeaderHeight = 30.0f;
    self.dayCellHeight = 70.0f;
    self.bottomCellHeight = 44.0f;
    
    self.pagingMonths = @[].mutableCopy;
    self.pagingViews = @[].mutableCopy;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    self.weekdaySymbols = formatter.shortWeekdaySymbols;
    self.startDate = startDate;
    self.endDate = endDate;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.monthsDayCellClass = DPCalendarMonthlySingleMonthCell.class;
    self.monthsHeaderViewClass = DPCalendarMonthlyWeekdayCell.class;
    self.monthsBottomCellClass = DPCalendarMonthlyHorizontalScrollCell.class;
    
    [self monthsScrollView];
    
    [self scrollToCurrentMonth];
    
    self.separatorColor = [UIColor redColor];
    self.monthlyViewBackgroundColor = [UIColor whiteColor];
}

-(void)setMonthlyViewBackgroundColor:(UIColor *)monthlyViewBackgroundColor {
    _monthlyViewBackgroundColor = monthlyViewBackgroundColor;
    _monthsScrollView.backgroundColor = _monthlyViewBackgroundColor;
}

-(UIScrollView *) monthsScrollView {
    if (!_monthsScrollView) {
        float monthsScrollViewHeight = self.dayHeaderHeight + self.dayCellHeight * 6;
        float y = ((self.bounds.size.height - self.bottomCellHeight) < monthsScrollViewHeight) ? 0 : (self.bounds.size.height - self.bottomCellHeight - monthsScrollViewHeight);
        
        _monthsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, self.dayHeaderHeight + self.dayCellHeight * 6)];
        _monthsScrollView.showsHorizontalScrollIndicator = NO;
        _monthsScrollView.clipsToBounds = YES;
        _monthsScrollView.contentInset = UIEdgeInsetsZero;
        _monthsScrollView.pagingEnabled = YES;
        _monthsScrollView.delegate = self;
        
        NSDate *today = [NSDate date];
        [self.pagingMonths addObject:[today dateByAddingYears:0 months:-1 days:0]];
        [self.pagingMonths addObject:today];
        [self.pagingMonths addObject:[today dateByAddingYears:0 months:1 days:0]];
        
        [self.pagingViews addObject:[self singleMonthViewInFrame:_monthsScrollView.bounds]];
        [self.pagingViews addObject:[self singleMonthViewInFrame:CGRectMake(_monthsScrollView.bounds.size.width, 0, _monthsScrollView.bounds.size.width, _monthsScrollView.bounds.size.height)]];
        [self.pagingViews addObject:[self singleMonthViewInFrame:CGRectMake(_monthsScrollView.bounds.size.width * 2, 0, _monthsScrollView.bounds.size.width, _monthsScrollView.bounds.size.height)]];
        
        [_monthsScrollView addSubview:[self.pagingViews objectAtIndex:0]];
        [_monthsScrollView addSubview:[self.pagingViews objectAtIndex:1]];
        [_monthsScrollView addSubview:[self.pagingViews objectAtIndex:2]];
        
        
        [_monthsScrollView setContentSize:CGSizeMake(self.bounds.size.width * 3, _monthsScrollView.bounds.size.height)];
        [self addSubview:_monthsScrollView];
        
    }
    return _monthsScrollView;
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


-(UICollectionView *)monthsBottomView {
    if (!_monthsBottomView) {
        UICollectionViewFlowLayout *horizontalLayout = [[UICollectionViewFlowLayout alloc] init];
        horizontalLayout.sectionInset = UIEdgeInsetsZero;
        horizontalLayout.minimumInteritemSpacing = 0.f;
        horizontalLayout.minimumLineSpacing = 0.f;
        horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        horizontalLayout.footerReferenceSize = CGSizeZero;
        _monthsBottomView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - self.bottomCellHeight, self.bounds.size.width, self.bottomCellHeight)
                                              collectionViewLayout:horizontalLayout];
        _monthsBottomView.showsHorizontalScrollIndicator = NO;
        _monthsBottomView.showsVerticalScrollIndicator = NO;
        _monthsBottomView.dataSource = self;
        _monthsBottomView.delegate = self;
        _monthsBottomView.allowsMultipleSelection = NO;
        [_monthsBottomView registerClass:self.monthsBottomCellClass forCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier];
        [self addSubview:_monthsBottomView];
    }
    return _monthsBottomView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsBottomView) {
        
        DPCalendarMonthlyHorizontalScrollCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier
                                                  forIndexPath:indexPath];
        NSDate *cellMonth = [self monthForIndexPath:indexPath];
        [cell setDate:cellMonth];
        BOOL isSelected = [NSDate monthsDifferenceBetweenStartDate:cellMonth endDate:[self.pagingMonths objectAtIndex:1]] == 0;
        [cell setSelected:isSelected];
        
        return cell;
    } else {
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
    
}

-(NSDate *) dateOfCollectionView:(UICollectionView *)collectionView {
    return [self.pagingMonths objectAtIndex:[self.pagingViews indexOfObject:collectionView]];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.monthsBottomView) {
        return [NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:self.endDate];
    } else {
        NSDate *monthDate = [self dateOfCollectionView:collectionView];
        
        NSDateComponents *components =
        [self.calendar components:NSDayCalendarUnit
                         fromDate:[self firstVisibleDateOfMonth:monthDate]
                           toDate:[self lastVisibleDateOfMonth:monthDate]
                          options:0];
        
        return self.daysInWeek + components.day + 1;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsBottomView) {
        return CGSizeMake(self.bounds.size.width / 4.0, self.bottomCellHeight);
    } else {
        CGFloat width      = self.bounds.size.width;
        CGFloat itemWidth  = roundf(width / self.daysInWeek);
        CGFloat itemHeight = indexPath.item < self.daysInWeek ? self.dayHeaderHeight : self.dayCellHeight;
        
        NSUInteger weekday = indexPath.item % self.daysInWeek;
        
        if (weekday == self.daysInWeek - 1) {
            itemWidth = width - (itemWidth * (self.daysInWeek - 1));
        }
        
        return CGSizeMake(itemWidth, itemHeight);
    }
}

- (void) scrollToCurrentMonth {
    NSDate *today = [NSDate new];
    [self.pagingMonths setObject:today atIndexedSubscript:1];
    self.selectedDate = today;
    
    [self.monthsBottomView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:today] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (NSDate *) monthForIndexPath:(NSIndexPath *)indexPath {
    long monthsAfterStartDate = indexPath.row;
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = monthsAfterStartDate;
    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate:self.startDate
                                                                  options:0];
    return newDate;
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

- (void) scrollHorizontalMonthsViewToMonth:(NSDate *)month {
    int months = [NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:month];
    [self.monthsBottomView selectItemAtIndexPath:[NSIndexPath indexPathForItem:months inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void) adjustPreviousAndNextMonthPage {
    NSDate *currentMonth = [self.pagingMonths objectAtIndex:1];
    [self.pagingMonths setObject:[currentMonth dateByAddingYears:0 months:1 days:0] atIndexedSubscript:2];
    [self.pagingMonths setObject:[currentMonth dateByAddingYears:0 months:-1 days:0] atIndexedSubscript:0];
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    if (sender == self.monthsBottomView) {
        
    } else {
        // All data for the documents are stored in an array (documentTitles).
        // We keep track of the index that we are scrolling to so that we
        // know what data to load for each page.
        if(self.monthsScrollView.contentOffset.x > self.monthsScrollView.frame.size.width)
        {
            NSDate *currentMonth = [self.pagingMonths objectAtIndex:2];
            [self.pagingMonths setObject:currentMonth atIndexedSubscript:1];
            [self adjustPreviousAndNextMonthPage];
        }
        if(self.monthsScrollView.contentOffset.x < self.monthsScrollView.frame.size.width)
        {
            NSDate *currentMonth = [self.pagingMonths objectAtIndex:0];
            [self.pagingMonths setObject:currentMonth atIndexedSubscript:1];
            [self adjustPreviousAndNextMonthPage];
        }
        [self reloadPagingViews];
        [self scrollHorizontalMonthsViewToMonth:[self.pagingMonths objectAtIndex:1]];
        [self.monthsScrollView scrollRectToVisible:((UICollectionView *)[self.pagingViews objectAtIndex:1]).frame animated:NO];
    }
}


#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsBottomView) {
        /*
         * monthsScrollView should now scroll to the current month
         */
        NSDate *cellMonth = [self monthForIndexPath:indexPath];
        [self.pagingMonths setObject:cellMonth atIndexedSubscript:1];
        [self adjustPreviousAndNextMonthPage];
        [self reloadPagingViews];
    } else {
        
    }
}

@end
