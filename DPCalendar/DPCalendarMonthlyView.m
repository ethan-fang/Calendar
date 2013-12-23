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

@interface DPCalendarMonthlyView()<UIScrollViewDelegate>

//Circular and infinite uiscrollviews, currIndex is used for indicating the current page
@property (nonatomic) int currIndex;
@property (nonatomic, strong) UICollectionView *pageOneView;
@property (nonatomic, strong) UICollectionView *pageTwoView;
@property (nonatomic, strong) UICollectionView *pageThreeView;

@property (nonatomic, strong) NSDate *pageOneMonth;
@property (nonatomic, strong) NSDate *pageTwoMonth;
@property (nonatomic, strong) NSDate *pageThreeMonth;

@property (nonatomic, strong) NSDate *selectedMonth;

@property (nonatomic, strong) UIScrollView *monthsScrollView;


//@property (nonatomic, strong) UICollectionView *singleMonthView;
@property (nonatomic, strong) UICollectionView *monthsView;


@property(nonatomic,strong) Class headerViewClass;
@property(nonatomic,strong) Class dayCellClass;
@property (nonatomic, strong) Class horizontalCellClass;

@property (nonatomic) float monthlyViewHeightRatio;

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
    return [self initWithFrame:frame startDate:nil endDate:nil];
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
        [self commonInitWithStartDate:nil endDate:nil];
    }
    return self;
}

- (void) commonInitWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self.calendar   = NSCalendar.currentCalendar;
    self.daysInWeek = 7;
    self.dayHeaderHeight = 30.0f;
    self.dayCellHeight = 70.0f;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    self.weekdaySymbols = formatter.shortWeekdaySymbols;
    
    if (!startDate && !endDate) {
        NSDate *today = [NSDate date];
        self.startDate = [today dateByAddingYears:-50 months:0 days:0];
        self.endDate = [today dateByAddingYears:50 months:0 days:0];
    } else {
        self.startDate = startDate;
        self.endDate = endDate;
    }
    
    self.backgroundColor = [UIColor yellowColor];
    self.monthlyViewHeightRatio = 0.9;
    self.backgroundColor = [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
    
    self.dayCellClass = DPCalendarMonthlySingleMonthCell.class;
    self.headerViewClass = DPCalendarMonthlyWeekdayCell.class;
    self.horizontalCellClass = DPCalendarMonthlyHorizontalScrollCell.class;
    
    [self monthsScrollView];
    
    [self scrollToCurrentMonth];
    
    self.separatorColor = [UIColor redColor];
}



-(UIScrollView *) monthsScrollView {
    if (!_monthsScrollView) {
        _monthsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * self.monthlyViewHeightRatio)];
        _monthsScrollView.showsHorizontalScrollIndicator = NO;
        _monthsScrollView.backgroundColor = [UIColor yellowColor];
        _monthsScrollView.clipsToBounds = YES;
        _monthsScrollView.contentInset = UIEdgeInsetsZero;
        _monthsScrollView.pagingEnabled = YES;
        _monthsScrollView.delegate = self;
        
        self.pageOneView = [self singleMonthViewInFrame:_monthsScrollView.bounds];
        self.pageTwoView = [self singleMonthViewInFrame:CGRectMake(_monthsScrollView.bounds.size.width, 0, _monthsScrollView.bounds.size.width, _monthsScrollView.bounds.size.height)];
        self.pageThreeView = [self singleMonthViewInFrame:CGRectMake(_monthsScrollView.bounds.size.width * 2, 0, _monthsScrollView.bounds.size.width, _monthsScrollView.bounds.size.height)];
        
        [_monthsScrollView addSubview:self.pageOneView];
        [_monthsScrollView addSubview:self.pageTwoView];
        [_monthsScrollView addSubview:self.pageThreeView];
        
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
    
    [singleMonthView registerClass:self.dayCellClass
         forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    [singleMonthView registerClass:self.headerViewClass forCellWithReuseIdentifier:DPCalendarViewWeekDayCellIdentifier];
    
    return singleMonthView;
}


-(UICollectionView *)monthsView {
    if (!_monthsView) {
        UICollectionViewFlowLayout *horizontalLayout = [[UICollectionViewFlowLayout alloc] init];
        horizontalLayout.sectionInset = UIEdgeInsetsZero;
        horizontalLayout.minimumInteritemSpacing = 0.f;
        horizontalLayout.minimumLineSpacing = 0.f;
        horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        horizontalLayout.footerReferenceSize = CGSizeZero;
        _monthsView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * self.monthlyViewHeightRatio, self.bounds.size.width, self.bounds.size.height * (1 -self.monthlyViewHeightRatio))
                                              collectionViewLayout:horizontalLayout];
        _monthsView.backgroundColor = [UIColor lightGrayColor];
        _monthsView.showsHorizontalScrollIndicator = NO;
        _monthsView.showsVerticalScrollIndicator = NO;
        _monthsView.dataSource = self;
        _monthsView.delegate = self;
        _monthsView.allowsMultipleSelection = NO;
        [_monthsView registerClass:self.horizontalCellClass forCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier];
        [self addSubview:_monthsView];
    }
    return _monthsView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsView) {
        
        DPCalendarMonthlyHorizontalScrollCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier
                                                  forIndexPath:indexPath];
        NSDate *cellMonth = [self monthForIndexPath:indexPath];
        [cell setDate:cellMonth];
        BOOL isSelected = [NSDate monthsDifferenceBetweenStartDate:cellMonth endDate:self.selectedMonth] == 0;
        [cell setSelected:isSelected];
        
        return cell;
    } else {
        if (indexPath.item < self.daysInWeek) {
            DPCalendarMonthlyWeekdayCell *cell =
            [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewWeekDayCellIdentifier
                                                      forIndexPath:indexPath];
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.separatorColor = self.separatorColor;
            cell.weekday = self.weekdaySymbols[indexPath.item];
            
            return cell;
        }
        
        DPCalendarMonthlySingleMonthCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier
                                                  forIndexPath:indexPath];
        
        NSDate *monthDate = self.pageTwoMonth;
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.monthsView) {
        return [NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:self.endDate];
    } else {
        if (collectionView == self.pageTwoView) {
            NSDate *monthDate = self.pageTwoMonth;
            
            NSDateComponents *components =
            [self.calendar components:NSDayCalendarUnit
                             fromDate:[self firstVisibleDateOfMonth:monthDate]
                               toDate:[self lastVisibleDateOfMonth:monthDate]
                              options:0];
            
            return self.daysInWeek + components.day + 1;
        }
        
        return 42;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsView) {
        return CGSizeMake(self.bounds.size.width / 4.0, self.bounds.size.height * (1 - self.monthlyViewHeightRatio));
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
    self.selectedMonth = today;
    self.selectedDate = today;
    
    self.pageTwoMonth = self.selectedMonth;
    
    [self.monthsView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:today] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (NSDate *) monthForIndexPath:(NSIndexPath *)indexPath {
    int monthsAfterStartDate = indexPath.row;
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
    
    return
    [[date dp_dateWithDay:-((components.weekday - 1) % self.daysInWeek) calendar:self.calendar] dateByAddingTimeInterval:DP_DAY];
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

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    [self.monthsScrollView scrollRectToVisible:self.pageTwoView.frame animated:NO];
}

@end
