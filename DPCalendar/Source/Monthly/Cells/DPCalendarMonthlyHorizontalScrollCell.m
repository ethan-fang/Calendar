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
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 20)];
    [self addSubview:self.yearLabel];
    [self addSubview:self.monthLabel];
    
    self.cellBackgroundColor = [UIColor blackColor];
    self.cellSelectedBackgroundColor = [UIColor redColor];
}

-(void)setDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    self.year = [components year];
    self.month = [components month];
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.selected) {
        [self setBackgroundColor:self.cellBackgroundColor];
    } else {
        [self setBackgroundColor:self.cellSelectedBackgroundColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self.yearLabel setText:[NSString stringWithFormat:@"%d", self.year]];
    [self.monthLabel setText:[NSString stringWithFormat:@"%d", self.month]];
    
}


@end
