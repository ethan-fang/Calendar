//
//  DPCalendarMonthlyView.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyView.h"
#import "DPCalendarMonthlyCell.h"
#import "DPCalendarMonthlyViewLayout.h"
#import "DPCalendarHorizontalScrollCell.h"
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
    self.monthlyViewHeightRatio = 0.9;
    self.backgroundColor = [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.dayCellClass = DPCalendarMonthlyCell.class;
    self.horizontalCellClass = DPCalendarHorizontalScrollCell.class;
    
    
    [self registerUICollectionViewClasses];
}

-(UICollectionView *)singleMonthView {
    if (!_singleMonthView) {
        DPCalendarMonthlyViewLayout *layout = [[DPCalendarMonthlyViewLayout alloc] init];
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
        horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        horizontalLayout.footerReferenceSize = CGSizeZero;
        horizontalLayout.footerReferenceSize = CGSizeZero;
        _monthsView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.bounds.size.height * self.monthlyViewHeightRatio, 0, self.bounds.size.width, self.bounds.size.height * (1 -self.monthlyViewHeightRatio))
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
    
//    [_collectionView registerClass:self.weekdayCellClass
//        forCellWithReuseIdentifier:MNCalendarViewWeekdayCellIdentifier];
//    
//    [_collectionView registerClass:self.headerViewClass
//        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//               withReuseIdentifier:MNCalendarHeaderViewIdentifier];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.monthsView) {
        DPCalendarHorizontalScrollCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier
                                                  forIndexPath:indexPath];
        return cell;
    } else if (collectionView == self.singleMonthView) {
        DPCalendarMonthlyCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier
                                                  forIndexPath:indexPath];
        cell.text = [NSString stringWithFormat:@"%d", indexPath.row];
        return cell;
    }
    return nil;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(45, 70);
}

@end
