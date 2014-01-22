//
//  DPCalendarTestOptionsCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 21/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DPCalendarEvent.h"


@interface DPCalendarTestOptionsCell : UITableViewCell

- (void) setTitle:(NSString *)title;
- (void) setTextValue:(NSString *)textValue;
- (void) setDate:(NSDate *)date;

@end
