//
//  DPCalendarMonthlyCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlySingleMonthCell.h"
#import "DPCalendarEvent.h"
#import "DPCalendarIconEvent.h"
#import "NSDate+DP.h"

@interface DPCalendarMonthlySingleMonthCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *iconEvents;
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

-(void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar events:(NSArray *)events iconEvents:(NSArray *)iconEvents {
    self.date = [calendar dateFromComponents:[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date]];
    self.events = events;
    self.iconEvents = iconEvents;
    self.calendar = calendar;
    
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

#define ROW_HEIGHT 20
#define ICON_SIZE_MAX 18

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
    
    int eventsNotShowingCount = 0;
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    
    float iconX = CGRectGetMaxX(self.titleLabel.frame) + 4.0f;
    for (int i = 0; i < self.iconEvents.count; i++) {
        DPCalendarIconEvent *event = [self.iconEvents objectAtIndex:i];
        BOOL isWidthLonger = event.icon.size.width > event.icon.size.height;
        float scale = ICON_SIZE_MAX / (isWidthLonger ? event.icon.size.width : event.icon.size.height);
        float width = isWidthLonger ? ICON_SIZE_MAX : event.icon.size.width * scale;
        float height = isWidthLonger ? event.icon.size.height * scale : ICON_SIZE_MAX;
        if (iconX + width > rect.size.width) {
            
        } else {
            [event.icon drawInRect:CGRectMake(iconX, (ICON_SIZE_MAX - height) / 2, width, height)];
            iconX += width + 4.0f;
        }
    }
    
    for (DPCalendarEvent *event in self.events) {
        
        NSDate *day = self.date;
        
        UIColor *color = [self.eventColors objectAtIndex:event.type % self.eventColors.count];
        
        if (event.rowIndex == 0 || ((event.rowIndex + 1) * ROW_HEIGHT > rect.size.height)) {
            eventsNotShowingCount++;
            continue;
        }
        
        //Draw Underline
        [self drawCellWithColor:color InRect:CGRectMake(0, (event.rowIndex + 1) * ROW_HEIGHT, rect.size.width, 1) context:context];
        
        if (!([event.startTime compare:day] == NSOrderedAscending) || ([event.startTime compare:day] == NSOrderedAscending && [self.date isEqualToDate:self.firstVisiableDateOfMonth])) {
            //Draw Left line
            [self drawCellWithColor:color InRect:CGRectMake(0, event.rowIndex * ROW_HEIGHT + 3, 2, ROW_HEIGHT - 3) context:context];
            
            
            [[UIColor blackColor] set];
            [event.title drawInRect:CGRectMake(5, event.rowIndex * ROW_HEIGHT + 2, rect.size.width - 5, ROW_HEIGHT - 2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:textStyle}];
        }
        
        
    }
    if (eventsNotShowingCount > 0) {
        //show more
        [[NSString stringWithFormat:@"%d more...", eventsNotShowingCount] drawInRect:CGRectMake(5, (self.events.count - eventsNotShowingCount + 1) * ROW_HEIGHT + 2, rect.size.width - 5, ROW_HEIGHT - 2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:textStyle}];
    }
    
    
    
}

@end
