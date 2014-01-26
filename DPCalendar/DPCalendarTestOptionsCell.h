//
//  DPCalendarTestOptionsCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 21/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DPCalendarEvent.h"

@class DPCalendarTestOptionsCell;

@protocol DPCalendarTestOptionsCellDelegate <NSObject>

@optional
- (void) cell:(DPCalendarTestOptionsCell *)cell valueChanged:(id)value;

@end

@interface DPCalendarTestOptionsCell : UITableViewCell

- (void) setTitle:(NSString *)title;

@property (nonatomic, strong) NSString *textValue;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, weak) id<DPCalendarTestOptionsCellDelegate> delegate;

@end
