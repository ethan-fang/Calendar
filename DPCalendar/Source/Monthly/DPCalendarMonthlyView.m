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
#import "NSDate+DP.h"
#import "DPCalendarEvent.h"
#import "DPCalendarIconEvent.h"

NSString *const DPCalendarMonthlyViewAttributeWeekdayHeight = @"DPCalendarMonthlyViewAttributeWeekdayHeight";
NSString *const DPCalendarMonthlyViewAttributeWeekdayFont = @"DPCalendarMonthlyViewAttributeWeekdayFont";

NSString *const DPCalendarMonthlyViewAttributeCellTodayBannerBkgColor = @"DPCalendarMonthlyViewAttributeCellTodayBannerBkgColor";

NSString *const DPCalendarMonthlyViewAttributeCellHeight = @"DPCalendarMonthlyViewAttributeCellHeight";
NSString *const DPCalendarMonthlyViewAttributeDayFont = @"DPCalendarMonthlyViewAttributeDayFont";
NSString *const DPCalendarMonthlyViewAttributeDayTextColor = @"DPCalendarMonthlyViewAttributeDayTextColor";
NSString *const DPCalendarMonthlyViewAttributeEventFont = @"DPCalendarMonthlyViewAttributeEventFont";
NSString *const DPCalendarMonthlyViewAttributeCellRowHeight = @"DPCalendarMonthlyViewAttributeCellRowHeight";
NSString *const DPCalendarMonthlyViewAttributeEventColors = @"DPCalendarMonthlyViewAttributeEventColors";
NSString *const DPCalendarMonthlyViewAttributeIconEventFont = @"DPCalendarMonthlyViewAttributeIconEventFont";
NSString *const DPCalendarMonthlyViewAttributeIconEventBkgColors = @"DPCalendarMonthlyViewAttributeIconEventBkgColors";
NSString *const DPCalendarMonthlyViewAttributeCellNotInSameMonthColor = @"DPCalendarMonthlyViewAttributeCellNotInSameMonthColor";
NSString *const DPCalendarMonthlyViewAttributeCellHighlightedColor = @"DPCalendarMonthlyViewAttributeCellHighlightedColor";
NSString *const DPCalendarMonthlyViewAttributeCellSelectedColor = @"DPCalendarMonthlyViewAttributeCellSelectedColor";
NSString *const DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable = @"DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable";
NSString *const DPCalendarMonthlyViewAttributeEventDrawingStyle = @"DPCalendarMonthlyViewAttributeEventDrawingStyle";

NSString *const DPCalendarMonthlyViewAttributeSeparatorColor = @"DPCalendarMonthlyViewAttributeSeparatorColor";

NSString *const DPCalendarMonthlyViewAttributeStartDayOfWeek = @"DPCalendarMonthlyViewAttributeStartDayOfWeek";
NSString *const DPCalendarMonthlyViewAttributeMonthRows = @"DPCalendarMonthlyViewAttributeMonthRows";

#define DPCalendarMonthlyViewAttributeCellHeightDefault 70
#define DPCalendarMonthlyViewAttributeWeekdayHeightDefault 20
//Sunday
#define DPCalendarMonthlyViewAttributeStartDayOfWeekDefault 0

@interface DPCalendarMonthlyView()<UIScrollViewDelegate, UICollectionViewDelegate>

//Customize properties
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat weekdayHeight;
@property (nonatomic, strong) UIFont *weekdayFont;
@property (nonatomic) int startDayOfWeek;

@property (nonatomic, strong) UIFont *dayFont;
@property (nonatomic, strong) UIColor *dayTextColor;
@property (nonatomic, strong) UIFont *eventFont;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, strong) NSArray *eventColors;
@property (nonatomic, strong) UIFont *iconEventFont;
@property (nonatomic, strong) NSArray *iconEventBkgColors;
@property (nonatomic) DPCalendarMonthlyViewEventDrawingStyle eventDrawingStyle;

@property (nonatomic, strong) UIColor *todayBannerBkgColor;
@property (nonatomic, strong) UIColor *notInSameMonthColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic) BOOL isNoInSameMonthCellSeletable;

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
@property (nonatomic, strong) NSDictionary *iconEventsForEachDay;

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
    self.maxEventsPerDay = 10;
    
    self.calendar   = NSCalendar.currentCalendar;
    self.daysInWeek = 7;
    self.pagingMonths = @[].mutableCopy;
    self.pagingViews = @[].mutableCopy;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    self.weekdaySymbols = formatter.shortWeekdaySymbols;
    
    if ([self.monthlyViewDelegate respondsToSelector:@selector(monthlyViewAttributes)]) {
        NSDictionary *attributes = [self.monthlyViewDelegate monthlyViewAttributes];
        
        self.weekdayHeight = [attributes objectForKey:DPCalendarMonthlyViewAttributeWeekdayHeight] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeWeekdayHeight] floatValue] : 20;
        self.weekdayFont = [attributes objectForKey:DPCalendarMonthlyViewAttributeWeekdayFont] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeWeekdayFont] : [UIFont systemFontOfSize:12];
        
        if ([attributes objectForKey:DPCalendarMonthlyViewAttributeMonthRows]) {
            int rows = [[attributes objectForKey:DPCalendarMonthlyViewAttributeMonthRows] intValue];
            self.cellHeight = (self.bounds.size.height - self.weekdayHeight) / rows;
        } else {
            self.cellHeight = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellHeight] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeCellHeight] floatValue] : DPCalendarMonthlyViewAttributeCellHeightDefault;
        }
        
        self.separatorColor = [attributes objectForKey:DPCalendarMonthlyViewAttributeSeparatorColor] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeSeparatorColor] : [UIColor colorWithRed:194/255.0f green:194/255.0f blue:202/255.0f alpha:1];
        self.startDayOfWeek = [attributes objectForKey:DPCalendarMonthlyViewAttributeStartDayOfWeek] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeStartDayOfWeek] intValue] : DPCalendarMonthlyViewAttributeStartDayOfWeekDefault;
        
        self.eventColors = [attributes objectForKey:DPCalendarMonthlyViewAttributeEventColors] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeEventColors] :
        [self defaultEventColors];
        
        self.todayBannerBkgColor = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellTodayBannerBkgColor] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeCellTodayBannerBkgColor] : [UIColor colorWithRed:3/255.f green:138/255.f blue:1 alpha:1];
        
        
        self.dayFont = [attributes objectForKey:DPCalendarMonthlyViewAttributeDayFont] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeDayFont] : [UIFont systemFontOfSize:12];
        self.dayTextColor = [attributes objectForKey:DPCalendarMonthlyViewAttributeDayTextColor] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeDayTextColor] : [UIColor colorWithRed:156/255.0f green:156/255.0f blue:156/255.0f alpha:1];
        self.eventFont = [attributes objectForKey:DPCalendarMonthlyViewAttributeEventFont] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeEventFont] : [UIFont systemFontOfSize:12];
        self.rowHeight = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellRowHeight] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeCellRowHeight] floatValue] : 18.0f;
        self.iconEventFont = [attributes objectForKey:DPCalendarMonthlyViewAttributeIconEventFont] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeIconEventFont] : [UIFont systemFontOfSize:12];
        self.iconEventBkgColors = [attributes objectForKey:DPCalendarMonthlyViewAttributeIconEventBkgColors] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeIconEventBkgColors] :
        [self defaultIconEventColors];
        self.notInSameMonthColor = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellNotInSameMonthColor] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeCellNotInSameMonthColor] :
        [UIColor colorWithRed:239/255.f green:239/255.f blue:244/255.f alpha:1];
        self.selectedColor = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellSelectedColor] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeCellSelectedColor] :
        [UIColor colorWithRed:231/255.f green:241/255.f blue:248/255.f alpha:1];
        self.highlightedColor = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellHighlightedColor] ? [attributes objectForKey:DPCalendarMonthlyViewAttributeCellHighlightedColor] :
        self.selectedColor;
        self.eventDrawingStyle = [attributes objectForKey:DPCalendarMonthlyViewAttributeEventDrawingStyle] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeEventDrawingStyle] intValue] :
        DPCalendarMonthlyViewEventDrawingStyleBar;
        
        self.isNoInSameMonthCellSeletable = [attributes objectForKey:DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable] ? [[attributes objectForKey:DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable] boolValue] : NO;
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
    [self scrollRectToVisible:((UIView *)[self.pagingViews objectAtIndex:1]).frame animated:NO];
}

- (NSArray *)defaultEventColors {
    return @[[UIColor colorWithRed:254/255.f green:161/255.0f blue:0/255.0f alpha:1], [UIColor colorWithRed:2/255.0f green:63/255.0f blue:155/255.0f alpha:1], [UIColor colorWithRed:255/255.f green:36/255.0f blue:36/255.0f alpha:1]];
}

- (NSArray *)defaultIconEventColors {
    return @[[UIColor clearColor], [UIColor colorWithRed:255/255.0f green:168/255.0f blue:0 alpha:1]];
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
    
    [self.monthlyViewDelegate didScrollToMonth:today firstDate:[self firstVisibleDateOfMonth:today] lastDate:[self lastVisibleDateOfMonth:today]];
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
    [date dp_dateWithDay:components.day + (self.daysInWeek + self.startDayOfWeek - 1) - ((components.weekday - 1) % self.daysInWeek)
                calendar:self.calendar];
}

- (void) reloadPagingViews {
    for (UICollectionView *collectionView in self.pagingViews) {
        [collectionView reloadData];
        
        NSDate *thisMonth = [self.pagingMonths objectAtIndex:1];
        if ((collectionView == [self.pagingViews objectAtIndex:1]) && self.selectedDate && ([[self firstVisibleDateOfMonth:thisMonth] compare:self.selectedDate] == NSOrderedAscending) && ([[self lastVisibleDateOfMonth:thisMonth] compare:self.selectedDate] == NSOrderedDescending)) {
            
            NSIndexPath *indexPath = [self indexPathForCurrentMonthWithDate:self.selectedDate];
            if ([self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath]) {
                [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
                [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
            }
        }
    }
}

- (void) adjustPreviousAndNextMonthPage {
    NSDate *currentMonth = [self.pagingMonths objectAtIndex:1];
    [self.pagingMonths setObject:[currentMonth dateByAddingYears:0 months:1 days:0] atIndexedSubscript:2];
    [self.pagingMonths setObject:[currentMonth dateByAddingYears:0 months:-1 days:0] atIndexedSubscript:0];
}

-(void)scrollToMonth:(NSDate *)month complete:(void (^)(void))complete{
    NSDate *firstDayOfDestinationMonth = [month dp_firstDateOfMonth:self.calendar];
    NSDate *firstDayOfOriginalMonth = [self.seletedMonth dp_firstDateOfMonth:self.calendar];
    
    int scrollToPosition = 1;
    if ([firstDayOfDestinationMonth compare:firstDayOfOriginalMonth] == NSOrderedDescending) {
        scrollToPosition = 2;
    } else if ([firstDayOfDestinationMonth compare:firstDayOfOriginalMonth] == NSOrderedAscending) {
        scrollToPosition = 0;
    }
    if (scrollToPosition == 1) {
        [self.monthlyViewDelegate didScrollToMonth:[self.pagingMonths objectAtIndex:1] firstDate:[self firstVisibleDateOfMonth:month] lastDate:[self lastVisibleDateOfMonth:month]];
        if (complete) {
            complete();
        }
        return;
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
        [self.monthlyViewDelegate didScrollToMonth:[self.pagingMonths objectAtIndex:1] firstDate:[self firstVisibleDateOfMonth:month] lastDate:[self lastVisibleDateOfMonth:month]];
        if (complete) {
            complete();
        }
    }];
}

-(void)scrollToPreviousMonthWithComplete:(void (^)(void))complete {
    NSDate *previousMonth = [self.seletedMonth dateByAddingYears:0 months:-1 days:0];
    [self scrollToMonth:previousMonth complete:complete];
}

-(void)scrollToNextMonthWithComplete:(void (^)(void))complete {
    NSDate *previousMonth = [self.seletedMonth dateByAddingYears:0 months:1 days:0];
    [self scrollToMonth:previousMonth complete:complete];
}

-(NSDate *)seletedMonth {
    return [self.pagingMonths objectAtIndex:1];
}

-(void)setEvents:(NSArray *)passedEvents complete:(void (^)(void))complete{
    __weak __typeof(&*self)weakSelf = self;
    
    [self.processQueue addOperationWithBlock:^{
        NSMutableDictionary *eventsByDay = [NSMutableDictionary new];
        NSArray *events = [passedEvents sortedArrayUsingComparator:^NSComparisonResult(DPCalendarEvent *obj1, DPCalendarEvent *obj2) {
            return [obj1.startTime compare: obj2.startTime];
        }];
        if (events.count) {
            
            /*****************************************************************
             *
             * Step2:
             *      Iterate all events and add event to the dictionary, also
             * calculate the position that we want to show the event (rowIndex).
             * If the rowIndex value is 0, we don't show that event.
             *
             *****************************************************************/
            for (DPCalendarEvent *event in events) {
                event.rowIndex = 0;
                NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
                NSDate *startDate = [weakSelf.calendar dateFromComponents:[weakSelf.calendar components:preservedComponents fromDate:event.startTime]];
                
                NSDate *endDate = [weakSelf.calendar dateFromComponents:[weakSelf.calendar components:preservedComponents fromDate:[event.endTime dateByAddingYears:0 months:0 days:1]]];
                
                NSDate *date = [startDate copy];
                
                /*****************************************************************
                 *
                 * Add that event to the corresponding date
                 *
                 *****************************************************************/
                while ([date compare:endDate] != NSOrderedSame) {
                    if ([eventsByDay objectForKey:date]) {
                        [((NSMutableArray *)[eventsByDay objectForKey:date]) addObject:event];
                    } else {
                        [eventsByDay setObject:@[event].mutableCopy forKey:date];
                    }
                    date = [date dateByAddingYears:0 months:0 days:1];
                }
                
                NSMutableArray *otherEventsInTheSameDay = [eventsByDay objectForKey:startDate];
                
                /*****************************************************************
                 *
                 * We check the available max rowIndex and set it to the event.
                 * If that is no available position, we keep it as 0.
                 *
                 *****************************************************************/
                NSMutableArray *rowIndexs = @[].mutableCopy;
                for (int i = 0; i < otherEventsInTheSameDay.count; i++) {
                    [rowIndexs addObject:[NSNumber numberWithInt:0]];
                }
                for (DPCalendarEvent *event in otherEventsInTheSameDay) {
                    if (event.rowIndex && event.rowIndex < (rowIndexs.count + 1)) {
                        [rowIndexs setObject:[NSNumber numberWithInt:1] atIndexedSubscript:(event.rowIndex - 1)];
                    }
                }
                int i = 1;
                while ((i < rowIndexs.count + 1) && ([[rowIndexs objectAtIndex:i - 1] intValue] == 1)) {
                    i++;
                }
                if (i < weakSelf.maxEventsPerDay + 1) {
                    event.rowIndex = i;
                }
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakSelf.eventsForEachDay = eventsByDay;
            [weakSelf reloadPagingViews];
            if (complete) complete();
        }];
    }];
}

-(void)setIconEvents:(NSArray *)passedIconEvents complete:(void (^)(void))complete{
    __weak __typeof(&*self)weakSelf = self;
    [self.processQueue addOperationWithBlock:^{
        NSArray *iconEvents = [passedIconEvents sortedArrayUsingComparator:^NSComparisonResult(DPCalendarIconEvent *obj1, DPCalendarIconEvent *obj2) {
            return [obj1.startTime compare: obj2.startTime];
        }];
        NSMutableDictionary *eventsByDay = [NSMutableDictionary new];
        if (iconEvents.count) {
            /*****************************************************************
             *
             * Step1:
             *      we need to create a dictionary of @{date, array}
             * to store the events.
             *      ie. have a map with keys from
             * 29/12/2013 - 1/02/2014
             *
             *****************************************************************/
            NSDate *firstDay = [((DPCalendarIconEvent *)[iconEvents objectAtIndex:0]).startTime dp_dateWithoutTimeWithCalendar:self.calendar];
            NSDate *lastDay = [((DPCalendarIconEvent *)[iconEvents objectAtIndex:iconEvents.count - 1]).endTime dp_dateWithoutTimeWithCalendar:self.calendar];
            for (DPCalendarIconEvent *event in iconEvents) {
                if ([lastDay compare:event.endTime] == NSOrderedAscending) {
                    lastDay = event.endTime;
                }
            }
            NSDate *iterateDay = firstDay.copy;
            while ([iterateDay compare:lastDay] != NSOrderedDescending) {
                [eventsByDay setObject:[NSMutableArray new] forKey:iterateDay];
                iterateDay = [iterateDay dateByAddingYears:0 months:0 days:1];
            }
            
            /*****************************************************************
             *
             * Step2:
             *      Iterate all events and add event to the dictionary
             *
             *****************************************************************/
            for (DPCalendarIconEvent *event in iconEvents) {
                
                NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
                NSDate *startDate = [weakSelf.calendar dateFromComponents:[weakSelf.calendar components:preservedComponents fromDate:event.startTime]];
                NSDate *endDate = [weakSelf.calendar dateFromComponents:[weakSelf.calendar components:preservedComponents fromDate:[event.endTime dateByAddingYears:0 months:0 days:1]]];
                
                NSDate *date = [startDate copy];
                
                /*****************************************************************
                 *
                 * Add that event to the corresponding date
                 *
                 *****************************************************************/
                while ([date compare:endDate] != NSOrderedSame) {
                    if ([eventsByDay objectForKey:date]) {
                        [((NSMutableArray *)[eventsByDay objectForKey:date]) addObject:event];
                    }
                    date = [date dateByAddingYears:0 months:0 days:1];
                }
                
            }
        }
        
        weakSelf.iconEventsForEachDay = eventsByDay;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf reloadPagingViews];
            if (complete) complete();
        }];
    }];
}

-(NSArray *)eventsForDay:(NSDate *)date {
    return [self.eventsForEachDay objectForKey:date];
}

-(NSArray *)iconEventsForDay:(NSDate *)date {
    return [self.iconEventsForEachDay objectForKey:date];
}

- (NSIndexPath *) indexPathForCurrentMonthWithDate:(NSDate *)date {
    NSDateComponents *components =
    [self.calendar components:NSDayCalendarUnit
                     fromDate:[self firstVisibleDateOfMonth:date]
                       toDate:date
                      options:0];
    
    return [NSIndexPath indexPathForItem:self.daysInWeek + components.day inSection:0];
    
}

- (void) clickDate:(NSDate *)date {
    [self scrollToMonth:date complete:^{
        NSIndexPath *indexPath = [self indexPathForCurrentMonthWithDate:date];
        UICollectionView *collectionView = (UICollectionView *)[self.pagingViews objectAtIndex:1];
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        if ([self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath]) {
            [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }
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
    NSDate *month = [self.pagingMonths objectAtIndex:1];
    [self.monthlyViewDelegate didScrollToMonth:[self.pagingMonths objectAtIndex:1] firstDate:[self firstVisibleDateOfMonth:month] lastDate:[self lastVisibleDateOfMonth:month]];
    
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldEnableItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self dateForCollectionView:collectionView IndexPath:indexPath];
    NSDate *firstDate = [[self.pagingMonths objectAtIndex:[self.pagingViews indexOfObject:collectionView]] dp_firstDateOfMonth:self.calendar];
    NSDate *lastDate = [[self.pagingMonths objectAtIndex:[self.pagingViews indexOfObject:collectionView]] dp_lastDateOfMonth:self.calendar];
    if (([date compare:firstDate] == NSOrderedAscending) || ([date compare:lastDate] == NSOrderedDescending)) {
        return NO;
    }
    return YES;
}

#pragma mark UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.daysInWeek) {
        DPCalendarMonthlyWeekdayCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewWeekDayCellIdentifier
                                                  forIndexPath:indexPath];
        cell.separatorColor = self.separatorColor;
        cell.font = self.weekdayFont;
        
        cell.weekday = self.weekdaySymbols[(indexPath.item + self.startDayOfWeek) % self.daysInWeek];
        
        return cell;
    }
    
    DPCalendarMonthlySingleMonthCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier
                                              forIndexPath:indexPath];
    
    cell.eventColors = self.eventColors;
    cell.todayBannerBkgColor = self.todayBannerBkgColor;
    
    cell.dayFont = self.dayFont;
    cell.dayTextColor = self.dayTextColor;
    cell.eventFont= self.eventFont;
    cell.rowHeight = self.rowHeight;
    cell.eventColors = self.eventColors;
    cell.iconEventFont = self.iconEventFont;
    cell.iconEventBkgColors = self.iconEventBkgColors;
    cell.eventDrawingStyle = self.eventDrawingStyle;
    
    cell.noInSameMonthColor = self.notInSameMonthColor;
    cell.selectedColor = self.selectedColor;
    cell.highlightedColor = self.highlightedColor;
    
    cell.firstVisiableDateOfMonth = [self dateForCollectionView:collectionView IndexPath:[NSIndexPath indexPathForItem:self.daysInWeek inSection:0]];
    
    cell.isInSameMonth = [self collectionView:collectionView shouldEnableItemAtIndexPath:indexPath];
    NSDate *date = [self dateForCollectionView:collectionView IndexPath:indexPath];
    [cell setDate:date calendar:self.calendar events:[self.eventsForEachDay objectForKey:date] iconEvents:[self.iconEventsForEachDay objectForKey:date]];
    
    cell.separatorColor = self.separatorColor;
    return cell;
    
}

#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.daysInWeek) {
        return NO;
    }
    NSDate *date = [self dateForCollectionView:collectionView IndexPath:indexPath];
    BOOL isCellEnabled = [self collectionView:collectionView shouldEnableItemAtIndexPath:indexPath];
    if (!self.isNoInSameMonthCellSeletable && !isCellEnabled) {
        return isCellEnabled;
    }
    if ([self.monthlyViewDelegate respondsToSelector:@selector(shouldHighlightItemWithDate:)]) {
        return [self.monthlyViewDelegate shouldHighlightItemWithDate:date];
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
    self.selectedDate = [self dateForCollectionView:collectionView IndexPath:indexPath];
    if ([self.monthlyViewDelegate respondsToSelector:@selector(didSelectItemWithDate:)]) {
        return [self.monthlyViewDelegate didSelectItemWithDate:self.selectedDate];
    }
}

@end
