//
//  DPCalendarTestCreateEventViewController.m
//  DPCalendar
//
//  Created by Ethan Fang on 21/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestCreateEventViewController.h"
#import "DPCalendarTestOptionsCell.h"

@interface DPCalendarTestCreateEventViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonSelected)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonSelected)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void) doneButtonSelected{
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

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

#define NEW_EVENT_CELL_IDENTIFIER @"NEW_EVENT_CELL_IDENTIFIER"
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPCalendarTestOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NEW_EVENT_CELL_IDENTIFIER];
    if (!cell) {
        cell = [[DPCalendarTestOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NEW_EVENT_CELL_IDENTIFIER];
    }
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end
