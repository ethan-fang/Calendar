//
//  DPCalendarMonthlyCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlySingleMonthCell.h"

@interface DPCalendarMonthlySingleMonthCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDate *date;
@end

@implementation DPCalendarMonthlySingleMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 24, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:15.f];
        self.titleLabel.textColor = [UIColor colorWithRed:82/255.0f green:82/255.0f blue:82/255.0f alpha:1];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.userInteractionEnabled = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar {
    self.date = date;
    
    NSDateComponents *components =
    [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:date];
    self.titleLabel.text = [NSString stringWithFormat:@"%d", components.day];
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef separatorColor = self.separatorColor.CGColor;
    
    CGFloat pixel = 1.f / [UIScreen mainScreen].scale;
    
    CGSize size = self.bounds.size;
    DPContextDrawLine(context,
                      CGPointMake(size.width - pixel, pixel),
                      CGPointMake(size.width - pixel, size.height),
                      separatorColor,
                      pixel);
    
    
    if (self.isSelected) {
        [self drawCellWithColor:[UIColor colorWithRed:255/255.0f green:222/255.0f blue:0 alpha:0.5] InRect:rect context:context];
    } else {
        [self drawCellWithColor:[UIColor clearColor] InRect:rect context:context];
    }
    
    [self drawCellWithColor:[UIColor colorWithRed:242/255.0f green:222/255.0f blue:1 alpha:0.5] InRect:CGRectMake(0, 0, rect.size.width, 20) context:context];
    
}

@end
