//
//  DPCalendarMonthlyCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlySingleMonthCell.h"
#import "DPCalendarEvent.h"
#import "NSDate+DP.h"

@interface DPCalendarMonthlySingleMonthCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *events;
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

-(void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar events:(NSArray *)events{
    self.date = [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date]];
    self.events = events;
    
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
    
    int i = 1;
    for (DPCalendarEvent *event in self.events) {
        NSDate *day = self.date;
        
        UIColor *color = [UIColor colorWithRed:event.type / 4.0f green:event.type / 4.0f blue:event.type / 4.0f alpha:0.5];
        if ([event.startTime compare:day] == NSOrderedAscending) {
            [self drawCellWithColor:color InRect:CGRectMake(0, event.rowIndex * 20, rect.size.width, 20) context:context];
        } else {
            [self drawCellWithColor:color InRect:CGRectMake(0, event.rowIndex * 20, rect.size.width, 20) context:context];
            
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            textStyle.lineBreakMode = NSLineBreakByWordWrapping;
            textStyle.alignment = NSTextAlignmentLeft;
            [[UIColor blackColor] set];
            [event.title drawInRect:CGRectMake(0, event.rowIndex * 20, rect.size.width, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:textStyle}];
            
        }
        i++;
    }
    
    
    
}

@end
