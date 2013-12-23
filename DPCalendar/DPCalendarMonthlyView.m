//
//  DPCalendarMonthlyView.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyView.h"
#import "DPCalendarSingleMonthCell.h"
#import "DPCalendarSingleMonthViewLayout.h"
#import "DPCalendarMonthlyHorizontalScrollCell.h"
#import "NSDate+DP.h"

@interface DPCalendarMonthlyView()

@property (nonatomic, strong) UICollectionView *singleMonthView;
@property (nonatomic, strong) UICollectionView *monthsView;

@property(nonatomic,strong) Class headerViewClass;
@property(nonatomic,strong) Class weekdayCellClass;
@property(nonatomic,strong) Class dayCellClass;

@property (nonatomic, strong) Class horizontalCellClass;
@property (nonatomic) float monthlyViewHeightRatio;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedMonth;

@end

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
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.dayCellClass = DPCalendarSingleMonthCell.class;
    self.horizontalCellClass = DPCalendarMonthlyHorizontalScrollCell.class;
    
    [self registerUICollectionViewClasses];
    
    [self scrollToCurrentMonth];
}

-(UICollectionView *)singleMonthView {
    if (!_singleMonthView) {
        DPCalendarSingleMonthViewLayout *layout = [[DPCalendarSingleMonthViewLayout alloc] init];
        _singleMonthView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * self.monthlyViewHeightRatio)
                                               collectionViewLayout:layout];
        
        _singleMonthView.showsHorizontalScrollIndicator = NO;
        _singleMonthView.showsVerticalScrollIndicator = NO;
        _singleMonthView.dataSource = self;
        _singleMonthView.delegate = self;
        _singleMonthView.allowsMultipleSelection = NO;
        [self addSubview:_singleMonthView];
    }
    return _singleMonthView;
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
        _monthsView.showsHorizontalScrollIndicator = NO;
        _monthsView.showsVerticalScrollIndicator = NO;
        _monthsView.dataSource = self;
        _monthsView.delegate = self;
        _monthsView.allowsMultipleSelection = NO;
        [self addSubview:_monthsView];
    }
    return _monthsView;
}

- (void)registerUICollectionViewClasses {
    [self.singleMonthView registerClass:self.dayCellClass
        forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    [self.monthsView registerClass:self.horizontalCellClass forCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier];
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
    } else if (collectionView == self.singleMonthView) {
        DPCalendarSingleMonthCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier
                                                  forIndexPath:indexPath];
        cell.text = [NSString stringWithFormat:@"%d", indexPath.row];
        return cell;
    }
    return nil;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.monthsView) {
        return [NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:self.endDate];
    } else if (collectionView == self.singleMonthView) {
        return 42;
    } else {
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsView) {
        return CGSizeMake(self.bounds.size.width / 4, self.bounds.size.height * (1 - self.monthlyViewHeightRatio));
    } else if (collectionView == self.singleMonthView) {
        return CGSizeMake(45, 70);
    } else {
        return CGSizeZero;
    }
}

- (void) scrollToCurrentMonth {
    NSDate *today = [NSDate new];
    self.selectedMonth = today;
    self.selectedDate = today;
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

@end
