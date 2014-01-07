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
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    if (self.unavailabilities.count) {
        [[NSString stringWithFormat:@"%d unavailability", self.unavailabilities.count] drawInRect:CGRectMake(0, 20, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:textStyle}];
    }
}

@end
