//
//  DPCalendarTestViewMonthlyCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 6/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarMonthlySingleMonthCell.h"

@interface DPCalendarTestViewMonthlyCell : DPCalendarMonthlySingleMonthCell

@property (nonatomic, strong) NSArray *unavailabilities;
@property (nonatomic, strong) NSArray *leave;
@property (nonatomic, strong) NSArray *shifts;

@end
