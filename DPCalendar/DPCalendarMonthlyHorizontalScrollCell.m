//
//  DPCalendarHorizontalScrollCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyHorizontalScrollCell.h"

@interface DPCalendarMonthlyHorizontalScrollCell()

@property (nonatomic) int year;
@property (nonatomic) int month;

@property (nonatomic, strong) UILabel* yearLabel;
@property (nonatomic, strong) UILabel* monthLabel;

@end

@implementation DPCalendarMonthlyHorizontalScrollCell

-(id)initWithFrame:(CGRect)frame {
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
    [self setBackgroundColor:[UIColor redColor]];
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 20)];
    [self addSubview:self.yearLabel];
    [self addSubview:self.monthLabel];
}

- (void) setYear:(int)year setMonth:(int)month {
    self.year = year;
    self.month = month;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.yearLabel setText:[NSString stringWithFormat:@"%d", self.year]];
    [self.monthLabel setText:[NSString stringWithFormat:@"%d", self.month]];
}


@end
