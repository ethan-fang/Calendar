![Calendar Ipad view](https://raw.github.com/ethan-fang/DPCalendar/master/github-assets/dpcalendar_ipad.gif)

# Features
* Dynamically populate events for each day of the month.
* Events can cross several days.
* Special icons can also be shown for days.
* Highly customisable: You can change the font/height/size etc. You can also limit how many events to show each day.

# Usage
## Example
```
DPCalendarMonthView *calendarView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, 0, 300, 200) delegate:self];
NSMutableArray *events = @[].mutableCopy;
NSMutableArray *iconEvents = @[].mutableCopy;
    
for (int i = 0; i < 40; i++) {
   int index = arc4random() % 3;
   DPCalendarEvent *event = [[DPCalendarEvent alloc] initWithTitle:[titles objectAtIndex:index] startTime:date endTime:[date dateByAddingYears:0 months:0 days:arc4random() % 3] colorIndex:index];
   [events addObject:event];
   
   DPCalendarIconEvent *iconEvent = [[DPCalendarIconEvent alloc] initWithStartTime:date endTime:[date dateByAddingYears:0 months:0 days:0] icon:icon];
            [iconEvents addObject:iconEvent];
   date = [date dateByAddingYears:0 months:0 days:1];
}

self.monthlyView.events = events;
self.monthlyView.iconEvents = iconEvents;
```
## Initiate Calendar
To achieve max flexible,```DPCalendarMonthView``` is only the calendar view without titles and Previous/Next Button. To add the calendar view, We can write
```
DPCalendarMonthView *calendarView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, 0, 300, 200) delegate:self];
```

## Provide events and icon events
### Events
```
NSDate *date = [NSDate date];
DPCalendarEvent *event = [[DPCalendarEvent alloc] initWithTitle:@"Test" startTime:date endTime:date colorIndex:1];
[events addObject:event];
```

### Icon Events
If you have only icon and no need to title and background
```
DPCalendarIconEvent *iconEvent = [[DPCalendarIconEvent alloc] initWithStartTime:date endTime:date icon:icon];
```
If you need icon and title and background color
```
DPCalendarIconEvent iconEvent = [[DPCalendarIconEvent alloc] initWithTitle:@"Test" startTime:date endTime:date icon:icon bkgColorIndex:1];
```

## Delegate
```
DPCalendarMonthlyViewDelegate
```
has the following functions:

* Delegate is called when calendar view scrolls and it also provides the first visible date of the month and last visible date of the month. For example, when the calendar view is scrolled to January 2014, 29/12/2013 and 01/02/2014 will be the first date and last date showing in the calendar.
```
-(void) didScrollToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;
```

* You can inherit ```DPCalendarMonthlySingleMonthCell``` and provides your own implementation
```
- (Class) monthlyCellClass;
```

* You can also inherit ```DPCalendarMonthlyWeekdayCell``` and provides your own implementation
```
- (Class) monthlyWeekdayClassClass;
```

* Returns YES/NO for allowing highlighting cell provided with date
```
- (BOOL) shouldHighlightItemWithDate:(NSDate *)date;
```
* Returns YES/NO for allowing selecting cell provided with date
```
- (BOOL) shouldSelectItemWithDate:(NSDate *)date;
```
* Callback when user select the date
```
- (void) didSelectItemWithDate:(NSDate *)date;
```
* Customise appearances of the calendar view
```
- (NSDictionary *) monthlyViewAttributes;
```

## Customise Appearance
* Just need to override the delegate function ```monthlyViewAttributes``` and returns a dictionary of attributes

```
-(NSDictionary *) ipadMonthlyViewAttributes {
    return @{
             DPCalendarMonthlyViewAttributeWeekdayFont: [UIFont systemFontOfSize:18],
             DPCalendarMonthlyViewAttributeDayFont: [UIFont systemFontOfSize:14],
             DPCalendarMonthlyViewAttributeMonthRows:@5
             };
}
```

* References

```
extern NSString *const DPCalendarMonthlyViewAttributeWeekdayHeight; //Height of weekday cell
extern NSString *const DPCalendarMonthlyViewAttributeWeekdayFont; //Font of weekday

extern NSString *const DPCalendarMonthlyViewAttributeCellTodayBannerBkgColor; //Today's color in cell
extern NSString *const DPCalendarMonthlyViewAttributeCellHeight; //Height of date cell
extern NSString *const DPCalendarMonthlyViewAttributeDayFont; //Font of day label
extern NSString *const DPCalendarMonthlyViewAttributeEventFont; //Font of event, which has underline
extern NSString *const DPCalendarMonthlyViewAttributeCellRowHeight; //Height of event
extern NSString *const DPCalendarMonthlyViewAttributeEventColors; //Underline color of the event
extern NSString *const DPCalendarMonthlyViewAttributeIconEventFont; //Font of icon event
extern NSString *const DPCalendarMonthlyViewAttributeIconEventBkgColors; //Background color of icon event
extern NSString *const DPCalendarMonthlyViewAttributeCellNotInSameMonthColor; //Background color of the cell that is not in current month
extern NSString *const DPCalendarMonthlyViewAttributeCellHighlightedColor; //Highlight color of the cell
extern NSString *const DPCalendarMonthlyViewAttributeCellSelectedColor; //Selected color of the cell
extern NSString *const DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable; //Whether the cell that is not in current month can be selected

extern NSString *const DPCalendarMonthlyViewAttributeSeparatorColor; //Border color of cell

extern NSString *const DPCalendarMonthlyViewAttributeStartDayOfWeek; //Start day of the week (0 means starting from Sunday)
extern NSString *const DPCalendarMonthlyViewAttributeMonthRows; //A convenient function to define the height of cell
```


More to come
