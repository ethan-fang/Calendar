//
//  DPCalendarTestViewController.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestViewController.h"
#import "DPCalendarMonthlySingleMonthViewLayout.h"

#import "DPCalendarMonthlyView.h"
#import "DPCalendarEvent.h"
#import "DPCalendarIconEvent.h"
#import "NSDate+DP.h"

@interface DPCalendarTestViewController ()<DPCalendarMonthlyViewDelegate>

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;


@property (nonatomic, strong) DPCalendarMonthlyView *monthlyView;

@end

@implementation DPCalendarTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

-(void) commonInit {
    [self generateMonthlyView];
    [self updateLabelWithMonth:self.monthlyView.seletedMonth];
    [self updateData];
}

- (void) generateMonthlyView {
    CGFloat width = self.view.bounds.size.height;
    CGFloat height = self.view.bounds.size.width;
    
    [self.previousButton removeFromSuperview];
    [self.nextButton removeFromSuperview];
    [self.monthLabel removeFromSuperview];
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.previousButton.frame = CGRectMake(0, 20, 100, 20);
    self.nextButton.frame = CGRectMake(width - 100, 20, 100, 20);
    [self.previousButton setTitle:@"Previous" forState:UIControlStateNormal];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - 200) / 2, 20, 200, 20)];
    [self.monthLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.previousButton addTarget:self action:@selector(previousButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(nextButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.previousButton];
    [self.view addSubview:self.nextButton];
    [self.monthlyView removeFromSuperview];
    self.monthlyView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, 50, width, height - 50) delegate:self];
    [self.view addSubview:self.monthlyView];
}

- (void) updateData {
    NSMutableArray *events = @[].mutableCopy;
    NSMutableArray *iconEvents = @[].mutableCopy;
    
    
    NSDate *date = [[NSDate date] dateByAddingYears:0 months:0 days:0];
    UIImage *icon = [UIImage imageNamed:@"IconCamera"];
    UIImage *greyIcon = [UIImage imageNamed:@"IconDateGrey"];
    
    for (int i = 0; i < 40; i++) {
        DPCalendarEvent *event = [[DPCalendarEvent alloc] init];
        event.startTime = date;
        event.endTime = [date dateByAddingYears:0 months:0 days:3];
        event.title = [NSString stringWithFormat:@"Event %d", i];
        event.colorIndex = i % 3;
        [events addObject:event];
        
        event = [[DPCalendarEvent alloc] init];
        event.startTime = date;
        event.endTime = [date dateByAddingYears:0 months:0 days:0];
        event.title = [NSString stringWithFormat:@"Event %d", i];
        event.colorIndex = i % 3;
        [events addObject:event];
        
        if (arc4random() % 2 > 0) {
            DPCalendarIconEvent *iconEvent = [DPCalendarIconEvent new];
            iconEvent.startTime = date;
            iconEvent.endTime = [date dateByAddingYears:0 months:0 days:0];
            iconEvent.icon = icon;
            [iconEvents addObject:iconEvent];
            
            
            iconEvent = [DPCalendarIconEvent new];
            iconEvent.startTime = date;
            iconEvent.endTime = [date dateByAddingYears:0 months:0 days:0];
            iconEvent.title = [NSString stringWithFormat:@"%d", i];
            iconEvent.icon = greyIcon;
            iconEvent.bkgColorIndex = 1;
            [iconEvents addObject:iconEvent];
        }
        
        date = [date dateByAddingYears:0 months:0 days:1];
    }
    
    self.monthlyView.events = events;
    self.monthlyView.iconEvents = iconEvents;
}

-(void) previousButtonSelected:(id)button {
    [self.monthlyView scrollToPreviousMonth];
}

-(void) nextButtonSelected:(id)button {
    [self.monthlyView scrollToNextMonth];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateLabelWithMonth:self.monthlyView.seletedMonth];
}

- (void) updateLabelWithMonth:(NSDate *)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:month];
    [self.monthLabel setText:stringFromDate];
}

#pragma DPCalendarMonthlyViewDelegate
-(void)didScrollToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate{
    [self updateLabelWithMonth:month];
    [self updateData];
}

-(BOOL)shouldHighlightItemWithDate:(NSDate *)date {
    return YES;
}

-(BOOL)shouldSelectItemWithDate:(NSDate *)date {
    return YES;
}

-(void)didSelectItemWithDate:(NSDate *)date {
    NSLog(@"Select date %@", date);
}



-(NSDictionary *) ipadMonthlyViewAttributes {
    return @{
             
             DPCalendarMonthlyViewAttributeIconEventBkgColors: @[[UIColor clearColor], [UIColor yellowColor]],
             DPCalendarMonthlyViewAttributeMonthRows:@5
             };
}

-(NSDictionary *) iphoneMonthlyViewAttributes {
    return @{
             DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable: @YES,
             DPCalendarMonthlyViewAttributeMonthRows:@3
             };

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self commonInit];
}

-(NSDictionary *)monthlyViewAttributes {
    if (IDIOM == IPAD) {
        return [self ipadMonthlyViewAttributes];
    } else {
        return [self iphoneMonthlyViewAttributes];
    }
}


@end
