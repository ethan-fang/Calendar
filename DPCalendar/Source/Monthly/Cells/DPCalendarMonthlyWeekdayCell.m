//
//  DPCalendarMonthlyWeekdayCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 23/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyWeekdayCell.h"

@interface DPCalendarMonthlyWeekdayCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DPCalendarMonthlyWeekdayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.titleLabel.font = [UIFont systemFontOfSize:20.f];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.userInteractionEnabled = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setWeekday:(NSString *)weekday {
    _weekday = weekday;
    self.titleLabel.text = weekday;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}


@end
