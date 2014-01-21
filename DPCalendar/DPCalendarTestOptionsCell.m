//
//  DPCalendarTestOptionsCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 21/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestOptionsCell.h"

@interface DPCalendarTestOptionsCell()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *valueTextField;

@property (nonatomic, strong) UISwitch *valueSwitch;

@property (nonatomic, strong) UISlider *valueSlider;

@end

@implementation DPCalendarTestOptionsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
