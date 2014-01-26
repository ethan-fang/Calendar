//
//  DPCalendarTestCreateEventViewController.m
//  DPCalendar
//
//  Created by Ethan Fang on 21/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestCreateEventViewController.h"
#import "DPCalendarTestOptionsCell.h"
#import "NSDate+DP.h"

@interface DPCalendarTestCreateEventViewController ()<UITableViewDelegate, UITableViewDataSource, DPCalendarTestOptionsCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DPCalendarTestCreateEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.event = [[DPCalendarEvent alloc] initWithTitle:@"Holiday" startTime:[[NSDate date] dateByAddingYears:0 months:0 days:-1] endTime:[[NSDate date] dateByAddingYears:0 months:0 days:1] colorIndex:0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonSelected)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonSelected)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.allowsSelection = NO;
    
    [self.view addSubview:self.tableView];
}

- (void) doneButtonSelected{
    NSLog(@"Event %@", self.event);
    [self.delegate eventCreated:self.event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancelButtonSelected{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define CELL_TITLE @"CELL_TITLE"
#define CELL_START_TIME @"CELL_START_TIME"
#define CELL_END_TIME @"CELL_END_TIME"

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

#define NEW_EVENT_CELL_IDENTIFIER @"NEW_EVENT_CELL_IDENTIFIER"
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPCalendarTestOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NEW_EVENT_CELL_IDENTIFIER];
    if (!cell) {
        cell = [[DPCalendarTestOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NEW_EVENT_CELL_IDENTIFIER];
        
    }
    cell.delegate = self;
    switch (indexPath.row) {
        case 0:
            cell.identifier = CELL_TITLE;
            [cell setTitle:@"Event Name"];
            [cell setTextValue:self.event.title];
            break;
        case 1:
            cell.identifier = CELL_START_TIME;
            [cell setTitle:@"Start Time"];
            [cell setDate:self.event.startTime];
            break;
        case 2:
            cell.identifier = CELL_END_TIME;
            [cell setTitle:@"End Time"];
            [cell setDate:self.event.endTime];
            break;
        default:
            break;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
#pragma mark -DPCalendarTestOptionsCellDelegate
-(void)cell:(DPCalendarTestOptionsCell *)cell valueChanged:(id)value {
    NSString *identifier = cell.identifier;
    if ([identifier isEqualToString:CELL_TITLE]) {
        self.event.title = value;
    } else if ([identifier isEqualToString:CELL_START_TIME]) {
        self.event.startTime = value;
    } else {
        self.event.endTime = value;
    }
}
@end
