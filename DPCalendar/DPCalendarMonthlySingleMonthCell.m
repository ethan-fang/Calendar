//
//  DPCalendarMonthlyCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlySingleMonthCell.h"

@interface DPCalendarMonthlySingleMonthCell()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSDate *date;
@end

@implementation DPCalendarMonthlySingleMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:self.textLabel];
    }
    return self;
}

-(void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar {
    self.date = date;
    
    NSDateComponents *components =
    [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:date];
    self.textLabel.text = [NSString stringWithFormat:@"%d", components.day];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.selectedBackgroundView.frame = self.bounds;
}

-(void)setText:(NSString *)text {
    self.textLabel.text = text;
}

- (void)drawRect:(CGRect)rect {
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
}

@end
