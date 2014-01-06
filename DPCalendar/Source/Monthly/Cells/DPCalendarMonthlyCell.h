//
//  DPCalendarMonthlyCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 23/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPBaseCell.h"
CG_EXTERN void DPContextDrawLine(CGContextRef c, CGPoint start, CGPoint end, CGColorRef color, CGFloat lineWidth);
@interface DPCalendarMonthlyCell : DPBaseCell

@property(nonatomic,strong) UIColor *separatorColor;

@end

