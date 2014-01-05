//
//  DPCalendarWekklyHorizontalScrollCell.m
//  DPCalendar
//
//  Created by Shan Wang on 31/12/2013.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarWeeklyHorizontalScrollCell.h"

@interface DPCalendarWeeklyHorizontalScrollCell()

@property (nonatomic) int year;
@property (nonatomic) int month;
@property (nonatomic) int day;

@property (nonatomic, strong) UILabel* dayLabel;
@property (nonatomic, strong) UILabel* monthLabel;
@end

@implementation DPCalendarWeeklyHorizontalScrollCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) commonInit {
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 20)];
    [self addSubview:self.dayLabel];
    [self addSubview:self.monthLabel];
    
    self.cellBackgroundColor = [UIColor blackColor];
    self.cellSelectedBackgroundColor = [UIColor redColor];
}

-(void)setDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    self.year = [components year];
    self.month = [components month];
    self.day = [components day];
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
    [self.dayLabel setText:[NSString stringWithFormat:@"%d", self.day]];
    [self.monthLabel setText:[NSString stringWithFormat:@"%d", self.month]];
    
}

@end
