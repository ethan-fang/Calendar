//
//  DPBaseCell.h
//  DPCalendar
//
//  Created by Ethan Fang on 6/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPBaseCellView : UIView

@end

@interface DPBaseSelectedCellView : UIView

@end

@interface DPBaseCell : UICollectionViewCell

@property (nonatomic, strong) DPBaseCellView *dpContentView;
@property (nonatomic, strong) DPBaseSelectedCellView *dpSelectedContentView;

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted;
- (void) drawCellWithColor:(UIColor *)color InRect: (CGRect)rect context: (CGContextRef)context;

#pragma mark - Need children to implement
- (DPBaseCellView *) generateContentView;
- (DPBaseSelectedCellView *) generateSelectedContentView;

@end
