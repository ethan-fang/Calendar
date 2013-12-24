//
//  DPCalendarHorizontalScrollCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPCalendarMonthlyHorizontalScrollCell : UICollectionViewCell
- (void) setDate:(NSDate *)date;

@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellSelectedBackgroundColor;

@end
