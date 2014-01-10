//
//  DPCalendarTestViewController.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestViewController.h"
#import "DPCalendarMonthlySingleMonthViewLayout.h"

#import "DPCalendarMonthlyMainView.h"
#import "DPCalendarMonthlyView.h"

#import "DPCalendarTestViewMonthlyCell.h"
#import "DPCalendarEvent.h"
#import "DPCalendarIconEvent.h"
#import "NSDate+DP.h"

@interface DPCalendarTestViewController ()<DPCalendarMonthlyViewDelegate>

@property (nonatomic, strong) DPCalendarMonthlyMainView *monthlyMainView;

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
    _monthlyMainView = [[DPCalendarMonthlyMainView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width) dayHeaderHeight:50 dayCellHeight:100 bottomCellHeight:40];
//    [self.view addSubview:_monthlyMainView];
    
    [self createStepView];
    [self updateData];

    
}

- (void) updateData {
    NSMutableArray *events = @[].mutableCopy;
    NSMutableArray *iconEvents = @[].mutableCopy;
    
    
    NSDate *date = [[NSDate date] dateByAddingYears:0 months:0 days:0];
    UIImage *icon = [UIImage imageNamed:@"IconCamera"];
    UIImage *greyIcon = [UIImage imageNamed:@"IconDateGrey"];
    
    for (int i = 0; i < 40; i++) {
        //        if ((arc4random() % 2) > 0) {
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
        //        }
        
        date = [date dateByAddingYears:0 months:0 days:1];
    }
    
    self.monthlyView.events = events;
    self.monthlyView.iconEvents = iconEvents;
}

-(void) createStepView {
    self.previousButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.previousButton.frame = CGRectMake(0, 20, 100, 20);
    self.nextButton.frame = CGRectMake(self.view.bounds.size.height - 100, 20, 100, 20);
    [self.previousButton setTitle:@"Previous" forState:UIControlStateNormal];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.height - 200) / 2, 20, 200, 20)];
    [self.monthLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.previousButton addTarget:self action:@selector(previousButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(nextButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.previousButton];
    [self.view addSubview:self.nextButton];
    
    self.monthlyView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, 50, 650, 609) delegate:self];
    self.monthlyView.monthlyViewDelegate = self;
    [self.view addSubview:self.monthlyView];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma DPCalendarMonthlyViewDelegate
-(void)didScrollToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:month];
    [self.monthLabel setText:stringFromDate];
    
    [self updateData];
    NSLog(@"%@ to %@", firstDate, lastDate);
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

-(NSDictionary *)monthlyViewAttributes {
    return @{
            
             DPCalendarMonthlyViewAttributeWeekdayHeight: @10, DPCalendarMonthlyViewAttributeWeekdayFont: @8,
             
             DPCalendarMonthlyViewAttributeCellTodayBannerBkgColor:[UIColor lightGrayColor],
             
             DPCalendarMonthlyViewAttributeCellHeight: @150,
             DPCalendarMonthlyViewAttributeCellSelectedColor: [UIColor colorWithRed:255/255.0f green:194/255.0f blue:3/255.0f alpha:0.5],
             DPCalendarMonthlyViewAttributeCellRowHeight: @10,
             DPCalendarMonthlyViewAttributeDayFont: [UIFont systemFontOfSize:8],
             DPCalendarMonthlyViewAttributeEventFont: [UIFont systemFontOfSize:8],
             DPCalendarMonthlyViewAttributeIconEventFont : [UIFont systemFontOfSize:8],
             DPCalendarMonthlyViewAttributeIconEventBkgColors: @[[UIColor clearColor], [UIColor yellowColor]],
             DPCalendarMonthlyViewAttributeEventColors : @[[UIColor clearColor], [UIColor yellowColor], [UIColor redColor], [UIColor blueColor], [UIColor blackColor]],
             DPCalendarMonthlyViewAttributeCellNotInSameMonthColor: [UIColor lightGrayColor],
             DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable: @YES,
             
             DPCalendarMonthlyViewAttributeSeparatorColor : [UIColor blackColor],
             
             DPCalendarMonthlyViewAttributeStartDayOfWeek: @2,
             DPCalendarMonthlyViewAttributeMonthRows:@5,
             };
}

-(Class)monthlyCellClass {
    return [DPCalendarTestViewMonthlyCell class];
}


@end
