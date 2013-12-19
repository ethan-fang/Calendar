//
//  DPCalendarMonthlyView.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyView.h"
#import "DPCalendarMonthlyCell.h"

NSString *const DPCalendarViewDayCellIdentifier = @"DPCalendarViewDayCellIdentifier";

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

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.backgroundColor = [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.dataSource = self;
    self.delegate = self;
    
    self.dayCellClass     = DPCalendarMonthlyCell.class;
    
    [self registerUICollectionViewClasses];
}

- (void)registerUICollectionViewClasses {
    [self registerClass:self.dayCellClass
        forCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier];
    
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
    DPCalendarMonthlyCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarViewDayCellIdentifier
                                              forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(45, 50);
}

@end
