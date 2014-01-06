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
    
    self.monthlyView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.height, self.view.bounds.size.width - 30) dayHeaderHeight:40 dayCellHeight:80];
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
-(void)didScrollToMonth:(NSDate *)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:month];
    [self.monthLabel setText:stringFromDate];
}

@end
