//
//  DPBaseCell.m
//  DPCalendar
//
//  Created by Ethan Fang on 6/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPBaseCell.h"



@implementation DPBaseCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dpContentView = [self generateContentView];
		self.dpContentView.opaque = YES;
		self.backgroundView = self.dpContentView;
        
		self.dpSelectedContentView = [self generateSelectedContentView];
		self.dpSelectedContentView.opaque = YES;
		self.selectedBackgroundView = self.dpSelectedContentView;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)setSelected:(BOOL)selected {
	[self.dpSelectedContentView setNeedsDisplay];
    
	if(!selected && self.selected) {
		[self.dpContentView setNeedsDisplay];
	}
    
	[super setSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted {
	[self.dpSelectedContentView setNeedsDisplay];
    
	if(!highlighted && self.highlighted) {
		[self.dpContentView setNeedsDisplay];
	}
    
	[super setHighlighted:highlighted];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[self.dpContentView setNeedsDisplay];
    
	if([self isHighlighted] || [self isSelected]) {
		[self.dpSelectedContentView setNeedsDisplay];
	}
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
	[super setNeedsDisplayInRect:rect];
	[self.dpContentView setNeedsDisplayInRect:rect];
    
	if([self isHighlighted] || [self isSelected]) {
		[self.dpSelectedContentView setNeedsDisplayInRect:rect];
	}
}

-(void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
    //Implement this function
}

- (void) drawCellWithColor:(UIColor *)color InRect: (CGRect)rect context: (CGContextRef)context{
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    [color setFill];
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

#pragma mark - child implement functions
-(DPBaseCellView *)generateContentView {
    DPBaseCellView *view = [[DPBaseCellView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(DPBaseSelectedCellView *)generateSelectedContentView {
    DPBaseSelectedCellView *view = [[DPBaseSelectedCellView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end

@implementation DPBaseCellView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
	}
    
	return self;
}

- (void)drawRect:(CGRect)rect {
    //http://www.blogosfera.co.uk/2013/06/abtableviewcell-issue-in-ios-7-with-drawcontentview-closed/
    UIView *v = self;
    while (v && ![v isKindOfClass:[DPBaseCell class]]) v = v.superview;
    
    [(DPBaseCell *)v drawContentView:rect highlighted:NO];
}

@end



@implementation DPBaseSelectedCellView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
	}
    
	return self;
}

- (void)drawRect:(CGRect)rect {
    //http://www.blogosfera.co.uk/2013/06/abtableviewcell-issue-in-ios-7-with-drawcontentview-closed/
    UIView *v = self;
    while (v && ![v isKindOfClass:[DPBaseCell class]]) v = v.superview;
    
    [(DPBaseCell *)v drawContentView:rect highlighted:YES];
}

@end

