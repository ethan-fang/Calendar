//
//  DPCalendarTestViewMonthlyCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 6/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestViewMonthlyCell.h"

@implementation DPCalendarTestViewMonthlyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.unavailabilities.count) {
        UILabel *unavailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 20)];
        [unavailLabel setText:[NSString stringWithFormat:@"%d unavailability", self.unavailabilities.count]];
        [self addSubview:unavailLabel];
    }
}

@end
