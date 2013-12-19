//
//  DPCalendarMonthlyCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlyCell.h"

@interface DPCalendarMonthlyCell()

@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation DPCalendarMonthlyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        [self.layer setBorderColor:[UIColor blueColor].CGColor];
        [self.layer setBorderWidth:2];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:self.textLabel];
    }
    return self;
}

-(void)setText:(NSString *)text {
    self.textLabel.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
