//
//  DPCalendarMonthlyView.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyView.h"
#import "DPCalendarMonthlySingleMonthViewLayout.h"
#import "DPCalendarMonthlyWeekdayCell.h"
#import "DPCalendarMonthlyHorizontalScrollCell.h"
#import "NSDate+DP.h"
#import "DPCalendarMonthlyHorizontalScrollView.h"
#import "DPCalendarEvent.h"

NSString *const DPCalendarMonthlyViewAttributeCellHeight = @"DPCalendarMonthlyViewCellHeight";
NSString *const DPCalendarMonthlyViewAttributeWeekdayHeight = @"DPCalendarMonthlyViewHeaderHeight";
NSString *const DPCalendarMonthlyViewAttributeWeekdayFont = @"DPCalendarMonthlyViewAttributeWeekdayFont";
NSString *const DPCalendarMonthlyViewAttributeSeparatorColor = @"DPCalendarMonthlyViewAttributeSeperatorColor";
NSString *const DPCalendarMonthlyViewAttributeStartDayOfWeek = @"DPCalendarMonthlyViewAttributeStartDayOfWeek";
NSString *const DPCalendarMonthlyViewAttributeMonthRows = @"DPCalendarMonthlyViewAttributeMonthRows";
NSString *const DPCalendarMonthlyViewAttributeEventColors = @"DPCalendarMonthlyViewAttributeEventColors";

#define DPCalendarMonthlyViewAttributeCellHeightDefault 70
#define DPCalendarMonthlyViewAttributeWeekdayHeightDefault 30
//Sunday
#define DPCalendarMonthlyViewAttributeStartDayOfWeekDefault 0

@interface DPCalendarMonthlyView()<UIScrollViewDelegate, UICollectionViewDelegate, DPCalendarMonthlyHorizontalScrollViewDelegate>

//Customize properties
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat weekdayHeight;
@property (nonatomic) int startDayOfWeek;

//3 UICollectionViews
@property (nonatomic, strong) NSMutableArray *pagingMonths;
@property (nonatomic, strong) NSMutableArray *pagingViews;

@property(nonatomic,strong,readwrite) NSArray *weekdaySymbols;


@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSCalendar *calendar;

@property(nonatomic) NSUInteger daysInWeek;


@property (nonatomic) uint maxEventsPerDay;
@property (nonatomic, strong) NSOperationQueue *processQueue;
@property (nonatomic, strong) NSDictionary *eventsForEachDay;
@property (nonatomic, strong) NSArray *eventColors;

@end

NSString *const DPCalendarViewWeekDayCellIdentifier = @"DPCalendarViewWeekDayCellIdentifier";
NSString *const DPCalendarViewDayCellIdentifier = @"DPCalendarViewDayCellIdentifier";


@implementation DPCalendarMonthlyView

-(id)initWithFrame:(CGRect)frame delegate:(id<DPCalendarMonthlyViewDelegate>)monthViewDelegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.monthlyViewDelegate = monthViewDelegate;
        [self commonInit];
    }
    return self;
}

- (void) commonInit{
    self.processQueue = [[NSOperationQueue alloc] init];
    self.processQueue.maxConcurrentOperationCount = 4;
    self.maxEventsPerDay = 4;
    
    self.calendar   = NSCalendar.currentCalendar;
    self.daysInWeek = 7;
    self.pagingMonths = @[].mutableCopy;
    self.pagingViews = @[].mutableCopy;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    self.weekdaySymbols = formatter.shortWeekdaySymbols;
    
    if ([self.monthlyViewDelegate respondsToSelector:@selector(monthlyViewAttributes)]) {
        NSDictionary *attributes = [self.monthlyViewDelegate monthlyViewAttributes];
        
        self.weekdayHeight = [attributes objectForKey:DPCalendarMonthlyViewAttributeWeekdayHeight] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeWeekdayHeight] floatValue] : DPCalendarMonthlyViewAttributeWeekdayHeightDefault;
        if ([attributes objectForKey:DPCalendarMonthlyViewAttributeMonthRows]) {
            int rows = [[attributes objectForKey:DPCalendarMonthlyViewAttributeMonthRows] intValue];
            self.cellHeight = (self.bounds.size.height - self.weekdayHeight) / rows;
        } else {
            self.cellHeight = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellHeight] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeCellHeight] floatValue] : DPCalendarMonthlyViewAttributeCellHeightDefault;
        }
        
        
        self.separatorColor = [attributes objectForKey:DPCalendarMonthlyViewAttributeSeparatorColor] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeSeparatorColor] : [UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
        self.startDayOfWeek = [attributes objectForKey:DPCalendarMonthlyViewAttributeStartDayOfWeek] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeStartDayOfWeek] intValue] : DPCalendarMonthlyViewAttributeStartDayOfWeekDefault;
        
        self.eventColors = [attributes objectForKey:DPCalendarMonthlyViewAttributeEventColors] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeEventColors] :
        [self defaultEventColors];
    }
    
    self.backgroundColor = [UIColor clearColor];

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

- (NSArray *)defaultEventColors {
    return @[[UIColor colorWithRed:1 green:168/255.0f blue:0 alpha:0.5], [UIColor colorWithRed:52/255.0f green:161/255.0f blue:1 alpha:0.5], [UIColor colorWithRed:1 green:48/255.0f blue:47/255.0f alpha:0.5]];
}

-(void)setMonthlyViewBackgroundColor:(UIColor *)monthlyViewBackgroundColor {
    _monthlyViewBackgroundColor = monthlyViewBackgroundColor;
    self.backgroundColor = _monthlyViewBackgroundColor;
}


-(UICollectionView *)singleMonthViewInFrame:(CGRect )frame {
    DPCalendarMonthlySingleMonthViewLayout *layout = [[DPCalendarMonthlySingleMonthViewLayout alloc] init];
    UICollectionView *singleMonthView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    singleMonthView.allowsSelection = YES;
    singleMonthView.translatesAutoresizingMaskIntoConstraints = NO;
    singleMonthView.showsHorizontalScrollIndicator = NO;
    singleMonthView.showsVerticalScrollIndicator = NO;
    singleMonthView.dataSource = self;
    singleMonthView.delegate = self;
    singleMonthView.allowsMultipleSelection = NO;
    singleMonthView.backgroundColor = [UIColor clearColor];
    
    if ([self.monthlyViewDelegate respondsToSelector:@selector(monthlyCellClass)]) {
        [singleMonthView registerClass:[self.monthlyViewDelegate monthlyCellClass]
            forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    } else {
        [singleMonthView registerClass:DPCalendarMonthlySingleMonthCell.class
            forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    }
    
    if ([self.monthlyViewDelegate respondsToSelector:@selector(monthlyWeekdayClassClass)]) {
        [singleMonthView registerClass:[self.monthlyViewDelegate monthlyWeekdayClassClass]
            forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    } else {
        [singleMonthView registerClass:DPCalendarMonthlyWeekdayCell.class
            forCellWithReuseIdentifier:DPCalendarViewWeekDayCellIdentifier];
    }
    
    return singleMonthView;
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
    CGFloat itemHeight = indexPath.item < self.daysInWeek ? self.weekdayHeight : self.cellHeight;
    
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
    
    return [[date dp_dateWithDay:-((components.weekday - self.startDayOfWeek - 1) % self.daysInWeek) calendar:self.calendar] dateByAddingTimeInterval:DP_DAY];
}

- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date {
    date = [date dp_lastDateOfMonth:self.calendar];
    
    NSDateComponents *components =
    [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:date];
    
    return
    [date dp_dateWithDay:components.day + (self.daysInWeek - self.startDayOfWeek - 1) - ((components.weekday - 1) % self.daysInWeek)
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

-(void)setEvents:(NSArray *)events {
    __weak __typeof(&*self)weakSelf = self;
    [self.processQueue addOperationWithBlock:^{
        NSMutableDictionary *eventsByDay = [NSMutableDictionary new];
        NSDate *firstDay = [weakSelf firstVisibleDateOfMonth:[weakSelf.pagingMonths objectAtIndex:1]];
        NSDate *lastDay = [weakSelf lastVisibleDateOfMonth:[weakSelf.pagingMonths objectAtIndex:1]];
        while ([firstDay compare:lastDay] != NSOrderedSame) {
            [eventsByDay setObject:[NSMutableArray new] forKey:firstDay];
            firstDay = [firstDay dateByAddingYears:0 months:0 days:1];
        }
        
        NSMutableArray *rowIndexs = nil;
        
        for (DPCalendarEvent *event in events) {
            NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
            NSDate *startDate = [weakSelf.calendar dateFromComponents:[weakSelf.calendar components:preservedComponents fromDate:event.startTime]];
            
            NSDate *endDate = [weakSelf.calendar dateFromComponents:[weakSelf.calendar components:preservedComponents fromDate:[event.endTime dateByAddingYears:0 months:0 days:1]]];
            
            NSDate *date = [startDate copy];
            while ([date compare:endDate] != NSOrderedSame) {
                if ([eventsByDay objectForKey:date]) {
                    [((NSMutableArray *)[eventsByDay objectForKey:date]) addObject:event];
                }
                date = [date dateByAddingYears:0 months:0 days:1];
            }
            NSMutableArray *otherEventsInTheSameDay = [eventsByDay objectForKey:startDate];
            
            //Get smallest availability index
            rowIndexs = @[].mutableCopy;
            for (int i = 0; i < self.maxEventsPerDay; i++) {
                [rowIndexs addObject:[NSNumber numberWithInt:0]];
            }
            for (DPCalendarEvent *event in otherEventsInTheSameDay) {
                if (event.rowIndex && event.rowIndex < (rowIndexs.count + 1)) {
                    [rowIndexs setObject:[NSNumber numberWithInt:1] atIndexedSubscript:(event.rowIndex - 1)];
                }
            }
            int i = 1;
            while (i < rowIndexs.count && [[rowIndexs objectAtIndex:i - 1] intValue] == 1) {
                i++;
            }
            if (i < self.maxEventsPerDay + 1) {
                event.rowIndex = i;
            }
        }
        
        weakSelf.eventsForEachDay = eventsByDay;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [((UICollectionView *)[weakSelf.pagingViews objectAtIndex:1]) reloadData];
        }];
    }];
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
    } else if(self.contentOffset.x < self.frame.size.width)
    {
        NSDate *currentMonth = [self.pagingMonths objectAtIndex:0];
        [self.pagingMonths setObject:currentMonth atIndexedSubscript:1];
        [self adjustPreviousAndNextMonthPage];
    } else {
        return;
    }
    [self reloadPagingViews];
    [self.monthlyViewDelegate didScrollToMonth:[self.pagingMonths objectAtIndex:1]];
    
    [self scrollRectToVisible:((UICollectionView *)[self.pagingViews objectAtIndex:1]).frame animated:NO];
}

-(NSDate *) dateForCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    NSDate *monthDate = [self dateOfCollectionView:collectionView];
    NSDate *firstDateInMonth = [self firstVisibleDateOfMonth:monthDate];
    
    NSUInteger day = indexPath.item - self.daysInWeek;
    
    NSDateComponents *components =
    [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                     fromDate:firstDateInMonth];
    components.day += day;
    
    NSDate *date = [self.calendar dateFromComponents:components];
    return date;
}

#pragma mark UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.daysInWeek) {
        DPCalendarMonthlyWeekdayCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewWeekDayCellIdentifier
                                                  forIndexPath:indexPath];
        cell.separatorColor = self.separatorColor;
        
        
        cell.weekday = self.weekdaySymbols[(indexPath.item + self.startDayOfWeek) % self.daysInWeek];
        
        return cell;
    }
    
    DPCalendarMonthlySingleMonthCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier
                                              forIndexPath:indexPath];
    cell.eventColors = self.eventColors;
    cell.firstVisiableDateOfMonth = [self dateForCollectionView:collectionView IndexPath:[NSIndexPath indexPathForItem:self.daysInWeek inSection:0]];
    
    NSDate *date = [self dateForCollectionView:collectionView IndexPath:indexPath];
    [cell setDate:date calendar:self.calendar events:[self.eventsForEachDay objectForKey:date]];
    
    cell.separatorColor = self.separatorColor;
    return cell;
    
}

#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.daysInWeek) {
        return NO;
    }
    if ([self.monthlyViewDelegate respondsToSelector:@selector(shouldHighlightItemWithDate:)]) {
        return [self.monthlyViewDelegate shouldHighlightItemWithDate:[self dateForCollectionView:collectionView IndexPath:indexPath]];
    }
    return NO;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.daysInWeek) {
        return NO;
    }
    if ([self.monthlyViewDelegate respondsToSelector:@selector(shouldSelectItemWithDate:)]) {
        return [self.monthlyViewDelegate shouldSelectItemWithDate:[self dateForCollectionView:collectionView IndexPath:indexPath]];
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.monthlyViewDelegate respondsToSelector:@selector(didSelectItemWithDate:)]) {
        return [self.monthlyViewDelegate didSelectItemWithDate:[self dateForCollectionView:collectionView IndexPath:indexPath]];
    }
}

@end
