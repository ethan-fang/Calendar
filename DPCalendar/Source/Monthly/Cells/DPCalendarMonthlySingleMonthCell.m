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

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *iconEvents;

@end

@implementation DPCalendarMonthlySingleMonthCell

-(void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar events:(NSArray *)events iconEvents:(NSArray *)iconEvents {
    self.date = [calendar dateFromComponents:[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date]];
    self.events = events;
    self.iconEvents = iconEvents;
    self.calendar = calendar;

    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

-(void)setIsInSameMonth:(BOOL)isInSameMonth {
    _isInSameMonth = isInSameMonth;
    [self setNeedsDisplay];
}

#define DAY_TEXT_RIGHT_MARGIN 6.0f
#define ICON_EVENT_VERTICAL_MARGIN 3.0f
#define ICON_EVENT_HORIZONTAL_MARGIN 4.0f

#define ROW_MARGIN 3.0f
#define EVENT_START_MARGIN 1.0f
#define EVENT_END_MARGIN 1.0f
#define EVENT_TITLE_MARGIN 2.0f

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Draw borders
    CGFloat pixel = 1.f / [UIScreen mainScreen].scale;
    CGSize size = self.bounds.size;
    CGRect internalRect = CGRectMake(0, pixel, size.width - pixel, size.height - pixel);
    
    //Draw background colors
    if (self.isSelected || self.isPreviousSelectedCell) {
        [self drawCellWithColor:self.selectedColor InRect:internalRect context:context];
    } else if (!self.isInSameMonth) {
        [self drawCellWithColor:self.noInSameMonthColor InRect:internalRect context:context];
    } else {
        [self drawCellWithColor:[UIColor clearColor] InRect:internalRect context:context];
    }
    
    [super drawRect:rect];
    
    
    DPContextDrawLine(context,
                      CGPointMake(size.width - pixel, pixel),
                      CGPointMake(size.width - pixel, size.height),
                      self.separatorColor.CGColor,
                      pixel);
    
    //Set text style
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    NSStringDrawingContext *stringContext = [[NSStringDrawingContext alloc] init];
    stringContext.minimumScaleFactor = 1;
    
    BOOL isDayToday = [self.date compare:[[NSDate date] dp_dateWithoutTimeWithCalendar:self.calendar]] == NSOrderedSame;
    if (isDayToday) {
        [self drawCellWithColor:self.todayBannerBkgColor InRect:CGRectMake(0, 0, rect.size.width, self.rowHeight) context:context];
    }
    
    //Draw Day
    NSDateComponents *components =
    [self.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                fromDate:self.date];
    NSString *dayString = [NSString stringWithFormat:@"%ld", (long)components.day];
    float dayWidth = [dayString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.dayFont.pointSize + 1)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{
                                                         NSFontAttributeName: [UIFont systemFontOfSize:self.dayFont.pointSize]
                                                         } context:stringContext].size.width;

    [dayString drawInRect:CGRectMake(size.width - dayWidth - DAY_TEXT_RIGHT_MARGIN, (self.rowHeight - self.dayFont.pointSize) / 2, dayWidth, self.dayFont.pointSize) withAttributes:@{NSFontAttributeName:self.dayFont, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:isDayToday ? [UIColor whiteColor] : self.dayTextColor}];
    
    
    int eventsNotShowingCount = 0;

    //Draw Icon events
    float iconX = ICON_EVENT_HORIZONTAL_MARGIN;
    for (int i = 0; i < self.iconEvents.count; i++) {
        DPCalendarIconEvent *event = [self.iconEvents objectAtIndex:i];
        CGFloat titleWidth = [event.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.iconEventFont.pointSize)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{
                                                           NSFontAttributeName: [UIFont systemFontOfSize:self.iconEventFont.pointSize]
                                                           } context:stringContext].size.width;
        
        BOOL isWidthLonger = event.icon.size.width > event.icon.size.height;
        float iconMaxHeight = self.rowHeight - ICON_EVENT_VERTICAL_MARGIN * 2;
        float scale = (iconMaxHeight) / (isWidthLonger ? event.icon.size.width : event.icon.size.height);
        float iconWidth = isWidthLonger ? (iconMaxHeight) : event.icon.size.width * scale;
        float iconHeight = isWidthLonger ? event.icon.size.height * scale : (iconMaxHeight);
        
        if (event.title.length) {
            if (iconX + titleWidth + iconWidth> rect.size.width - dayWidth - DAY_TEXT_RIGHT_MARGIN) {
                //Not enough space
            } else {
                [self drawRoundedRect:CGRectMake(iconX, 0, titleWidth + iconWidth + iconHeight, self.rowHeight) radius:self.rowHeight / 2 withColor:[self.iconEventBkgColors objectAtIndex:event.bkgColorIndex]];
                
                NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                textStyle.lineBreakMode = NSLineBreakByWordWrapping;
                textStyle.alignment = NSTextAlignmentLeft;
                
                [event.title drawInRect:CGRectMake(iconX + iconHeight / 2, (self.rowHeight - self.iconEventFont.pointSize) / 2, titleWidth, self.iconEventFont.pointSize) withAttributes:@{NSFontAttributeName:self.iconEventFont, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:[UIColor whiteColor]}];
                
                
                [event.icon drawInRect:CGRectMake(iconHeight / 2 + iconX + titleWidth, (self.rowHeight - iconHeight) / 2, iconWidth, iconHeight)];
                iconX += iconWidth + titleWidth + iconWidth + 2 * iconHeight + ICON_EVENT_HORIZONTAL_MARGIN;
            }
        } else {
            if (iconX + iconWidth > rect.size.width - dayWidth - DAY_TEXT_RIGHT_MARGIN) {
                //Not enough space
            } else {
                [event.icon drawInRect:CGRectMake(iconX, (self.rowHeight - iconHeight) / 2, iconWidth, iconHeight)];
                iconX += iconWidth + ICON_EVENT_HORIZONTAL_MARGIN;
            }
        }
    }
    
    //Draw Events
    for (DPCalendarEvent *event in self.events) {
        
        NSDate *day = self.date;
        
        UIColor *color = [self.eventColors objectAtIndex:event.colorIndex % self.eventColors.count];
        
        if (event.rowIndex == 0 || ((event.rowIndex + 2) * self.rowHeight  > rect.size.height)) {
            eventsNotShowingCount++;
            continue;
        }
        
        
        NSDate *tomorrow = [self.date dateByAddingYears:0 months:0 days:1];
        BOOL isEventEndedToday = [event.endTime compare:tomorrow] == NSOrderedAscending;
        BOOL isEventStartToday = !([event.startTime compare:day] == NSOrderedAscending) || ([event.startTime compare:day] == NSOrderedAscending && [self.date isEqualToDate:self.firstVisiableDateOfMonth]);
        
        float startPosition = isEventStartToday ? EVENT_START_MARGIN : 0;
        float width = isEventStartToday ? (isEventEndedToday ? (size.width - EVENT_START_MARGIN - EVENT_END_MARGIN):(size.width - EVENT_START_MARGIN - pixel) ) : (isEventEndedToday ? (size.width-EVENT_END_MARGIN-pixel) : (size.width-pixel));
        
        if (self.eventDrawingStyle == DPCalendarMonthlyViewEventDrawingStyleBar) {
            //Draw Bar
            [self drawCellWithColor:[color colorWithAlphaComponent:0.2] InRect:CGRectMake(startPosition, event.rowIndex * self.rowHeight + ROW_MARGIN, width, self.rowHeight - ROW_MARGIN) context:context];
        } else {
            //Draw Underline
            [self drawCellWithColor:color InRect:CGRectMake(startPosition, (event.rowIndex + 1) * self.rowHeight, width, 0.5f) context:context];
        }
        
        if (isEventStartToday) {
            //Draw Left line
            [self drawCellWithColor:color InRect:CGRectMake(EVENT_START_MARGIN, event.rowIndex * self.rowHeight + ROW_MARGIN, 2, self.rowHeight - ROW_MARGIN) context:context];
            
            
            [[UIColor blackColor] set];
            [event.title drawInRect:CGRectMake(startPosition + 2 +  EVENT_TITLE_MARGIN, event.rowIndex * self.rowHeight + ROW_MARGIN, rect.size.width - EVENT_END_MARGIN, self.rowHeight - ROW_MARGIN) withAttributes:@{NSFontAttributeName:self.eventFont, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:67/255.0f green:67/255.0f blue:67/255.0f alpha:1]}];
        }
        
        
        
    }
    if (eventsNotShowingCount > 0) {
        //show more
        [[NSString stringWithFormat:@"%d more...", eventsNotShowingCount] drawInRect:CGRectMake(5, rect.size.height - self.rowHeight, rect.size.width - 5, self.rowHeight - 2) withAttributes:@{NSFontAttributeName:self.eventFont, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:67/255.0f green:67/255.0f blue:67/255.0f alpha:1]}];
    }
    
    
}

-(void)setIsPreviousSelectedCell:(BOOL)isPreviousSelectedCell {
    _isPreviousSelectedCell = isPreviousSelectedCell;
}

@end
