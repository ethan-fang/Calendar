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
@interface DPCalendarMonthlyView()

@property (nonatomic, strong) UICollectionView *singleMonthView;
@property (nonatomic, strong) UICollectionView *monthsView;

@property(nonatomic,strong) Class headerViewClass;
@property(nonatomic,strong) Class weekdayCellClass;
@property(nonatomic,strong) Class dayCellClass;

@property (nonatomic, strong) Class horizontalCellClass;

@property (nonatomic) float monthlyViewHeightRatio;
@end

NSString *const DPCalendarViewDayCellIdentifier = @"DPCalendarViewDayCellIdentifier";
NSString *const DPCalendarHorizontalCellIdentifier = @"DPCalendarHorizontalCellIdentifier";

@implementation DPCalendarMonthlyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.backgroundColor = [UIColor yellowColor];
    self.monthlyViewHeightRatio = 0.9;
    self.backgroundColor = [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.dayCellClass = DPCalendarSingleMonthCell.class;
    self.horizontalCellClass = DPCalendarMonthlyHorizontalScrollCell.class;
    
    
    [self registerUICollectionViewClasses];
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
        [self addSubview:_monthsView];
    }
    return _monthsView;
}

- (void)registerUICollectionViewClasses {
    [self.singleMonthView registerClass:self.dayCellClass
        forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    [self.monthsView registerClass:self.horizontalCellClass forCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsView) {
        DPCalendarMonthlyHorizontalScrollCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier
                                                  forIndexPath:indexPath];
        [cell setYear:2000 setMonth:12];
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
        //200 years
        return 12 * 200;
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

@end
