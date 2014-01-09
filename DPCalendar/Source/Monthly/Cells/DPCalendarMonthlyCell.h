//
//  DPCalendarMonthlyCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 23/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
CG_EXTERN void DPContextDrawLine(CGContextRef c, CGPoint start, CGPoint end, CGColorRef color, CGFloat lineWidth);
@interface DPCalendarMonthlyCell : UICollectionViewCell

@property(nonatomic,strong) UIColor *separatorColor;

- (void) drawCellWithColor:(UIColor *)color InRect: (CGRect)rect context: (CGContextRef)context;
- (void) drawRoundedRect:(CGRect)rect radius:(float)radius withColor:(UIColor *)color;
@end

