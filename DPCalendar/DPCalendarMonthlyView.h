//
//  DPCalendarMonthlyView.h
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPCalendarMonthlyView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong) Class headerViewClass;
@property(nonatomic,strong) Class weekdayCellClass;
@property(nonatomic,strong) Class dayCellClass;

@end
