//
//  DPCalendarTestOptionsCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 21/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestOptionsCell.h"


enum CellType{
    CellTypeTextField,
    CellTypeSwitch,
    CellTypeSlider,
    CellTypeDate
};

@interface DPCalendarTestOptionsCell()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *valueTextField;
@property (nonatomic, strong) UISwitch *valueSwitch;
@property (nonatomic, strong) UISlider *valueSlider;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic) enum CellType cellType;
@property (nonatomic, strong) UIPopoverController *datePopover;

@end

@implementation DPCalendarTestOptionsCell

#define MARGIN_X 10

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [UILabel new];
        self.valueTextField = [UITextField new];
        self.valueTextField.delegate = self;
        self.dateLabel = [UILabel new];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTapped:)];
        [tap setNumberOfTapsRequired:1];
        self.dateLabel.userInteractionEnabled = YES;
        [self.dateLabel addGestureRecognizer:tap];
        
        [self.valueTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.valueTextField];
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (void) hideViews {
    self.valueTextField.hidden = YES;
    self.dateLabel.hidden = YES;
}

- (void) dateLabelTapped: (UITapGestureRecognizer *)tapGesture {
    [self.datePopover presentPopoverFromRect:self.dateLabel.frame inView:self
                    permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];//tempButton.frame where you need you can put that frame
}

-(UIPopoverController *)datePopover
{
    if(!_datePopover){
        UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
        
        UIView *popoverView = [[UIView alloc] init];   //view
        
        UIDatePicker *datePicker=[[UIDatePicker alloc]init];//Date picker
        datePicker.frame=CGRectMake(0,44,320, 216);
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker setMinuteInterval:5];
        [datePicker setTag:10];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [popoverView addSubview:datePicker];
        
        popoverContent.view = popoverView;
        
        
        _datePopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        _datePopover.popoverContentSize = CGSizeMake(320.f, 250.f);
    }
    
    return _datePopover;
}

- (void) dateChanged:(UIDatePicker *)picker{
    self.date = picker.date;
    [self.delegate cell:self valueChanged:self.date];
}

-(void) textFieldDidChange:(UITextField *)textField {
    [self.delegate cell:self valueChanged:textField.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSString *) strFromDate:(NSDate *)date {
    if (!date) {
        return nil;
    }
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
	return [dateFormatter stringFromDate:date];
}

- (void) setTitle:(NSString *)title {
    self.nameLabel.text = title;
}

- (void) setTextValue:(NSString *)text {
    [self hideViews];
    self.valueTextField.hidden = NO;
    self.valueTextField.text = text;
    self.cellType = CellTypeTextField;
}

- (void) setDate:(NSDate *)date {
    [self hideViews];
    self.dateLabel.hidden = NO;
    _date = date;
    self.dateLabel.text = [self strFromDate:date];
    self.cellType = CellTypeDate;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat width = (rect.size.width - 3 * MARGIN_X) / 2;
    CGFloat height = rect.size.height;
    
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.nameLabel.frame = CGRectMake(MARGIN_X, 0, width, height);
    CGRect valueFrame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + MARGIN_X, 0, width, height);
    
    self.valueTextField.frame = valueFrame;
    
    self.dateLabel.frame = valueFrame;
}



@end
