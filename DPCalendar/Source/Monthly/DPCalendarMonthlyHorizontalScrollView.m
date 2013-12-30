//
//  DPCalendarMonthlyHorizontalScrollView.m
//  DPCalendar
//
//  Created by Shan Wang on 31/12/2013.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyHorizontalScrollView.h"
#import "DPCalendarMonthlyHorizontalScrollCell.h"
#import "NSDate+DP.h"

NSString *const DPCalendarHorizontalCellIdentifier = @"DPCalendarHorizontalCellIdentifier";

@implementation DPCalendarMonthlyHorizontalScrollView

-(id)initWithFrame:(CGRect)frame currentMonth:(NSDate *)currentMonth startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    UICollectionViewFlowLayout *horizontalLayout = [[UICollectionViewFlowLayout alloc] init];
    horizontalLayout.sectionInset = UIEdgeInsetsZero;
    horizontalLayout.minimumInteritemSpacing = 0.f;
    horizontalLayout.minimumLineSpacing = 0.f;
    horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    horizontalLayout.footerReferenceSize = CGSizeZero;
    self = [super initWithFrame:frame collectionViewLayout:horizontalLayout];
    if (self) {
        self.startDate = startDate;
        self.endDate = endDate;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.allowsMultipleSelection = NO;
        [self registerClass:[DPCalendarMonthlyHorizontalScrollCell class] forCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier];
        
        self.bottomCellHeight = 44.0f;
    }
    self.currentMonth = currentMonth;
    return self;
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

- (void) scrollToCurrentMonth {
    NSDate *today = [NSDate new];
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:today] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void) scrollHorizontalMonthsViewToMonth:(NSDate *)month {
    int months = [NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:month];
    [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:months inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    self.currentMonth = month;
}

#pragma UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [NSDate monthsDifferenceBetweenStartDate:self.startDate endDate:self.endDate];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width / 4.0, self.bottomCellHeight);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPCalendarMonthlyHorizontalScrollCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:DPCalendarHorizontalCellIdentifier
                                              forIndexPath:indexPath];
    cell.cellBackgroundColor = [UIColor redColor];
    cell.cellSelectedBackgroundColor = [UIColor blueColor];
    NSDate *cellMonth = [self monthForIndexPath:indexPath];
    [cell setDate:cellMonth];
    BOOL isSelected = [NSDate monthsDifferenceBetweenStartDate:cellMonth endDate:self.currentMonth] == 0;
    [cell setSelected:isSelected];
    
    return cell;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
     * monthsScrollView should now scroll to the current month
     */
    NSDate *cellMonth = [self monthForIndexPath:indexPath];
    if ([self.scrollViewDelegate respondsToSelector:@selector(monthSelected:)]) {
        [self.scrollViewDelegate monthSelected:cellMonth];
    }
}
@end
