//
//  DPCalendarTestStoryboardViewController.m
//  DPCalendar
//
//  Created by Shan Wang on 15/03/2014.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestStoryboardViewController.h"
#import "DPCalendarMonthlyView.h"

@interface DPCalendarTestStoryboardViewController ()<DPCalendarMonthlyViewDelegate>
@property (weak, nonatomic) IBOutlet DPCalendarMonthlyView *calendarMonthlyView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DPCalendarTestStoryboardViewController

-(void)setCalendarMonthlyView:(DPCalendarMonthlyView *)calendarMonthlyView {
    _calendarMonthlyView = calendarMonthlyView;
    _calendarMonthlyView.monthlyViewDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateLabelWithMonth:self.calendarMonthlyView.seletedMonth];
}

- (void) updateLabelWithMonth:(NSDate *)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:month];
    [self.titleLabel setText:stringFromDate];
}

#pragma DPCalendarMonthlyViewDelegate
-(void)didScrollToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate{
    [self updateLabelWithMonth:month];
}

-(void)didSkipToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    [self updateLabelWithMonth:month];
}

-(void)didTapEvent:(DPCalendarEvent *)event onDate:(NSDate *)date {
    NSLog(@"Touched event %@, date %@", event.title, date);
}

-(BOOL)shouldHighlightItemWithDate:(NSDate *)date {
    return YES;
}

-(BOOL)shouldSelectItemWithDate:(NSDate *)date {
    return YES;
}

-(void)didSelectItemWithDate:(NSDate *)date {
    NSLog(@"Select date %@ with \n events %@ \n and icon events %@", date, [self.calendarMonthlyView eventsForDay:date], [self.calendarMonthlyView iconEventsForDay:date]);
}

-(NSDictionary *) ipadMonthlyViewAttributes {
    return @{
             DPCalendarMonthlyViewAttributeCellRowHeight: @23,
             //             DPCalendarMonthlyViewAttributeEventDrawingStyle: [NSNumber numberWithInt:DPCalendarMonthlyViewEventDrawingStyleUnderline],
             DPCalendarMonthlyViewAttributeStartDayOfWeek: @0,
             DPCalendarMonthlyViewAttributeWeekdayFont: [UIFont systemFontOfSize:18],
             DPCalendarMonthlyViewAttributeDayFont: [UIFont systemFontOfSize:14],
             DPCalendarMonthlyViewAttributeEventFont: [UIFont systemFontOfSize:14],
             DPCalendarMonthlyViewAttributeMonthRows:@5,
             DPCalendarMonthlyViewAttributeIconEventBkgColors: @[[UIColor clearColor], [UIColor colorWithRed:239/255.f green:239/255.f blue:244/255.f alpha:1]]
             };
}

@end
