//
//  NSString+DP.h
//  DPCalendar
//
//  Created by Shan Wang on 20/04/2014.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DP)

- (CGRect)dp_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context;
- (void)dp_drawAtPoint:(CGPoint)point withAttributes:(NSDictionary *)attrs;
- (void)dp_drawInRect:(CGRect)rect withAttributes:(NSDictionary *)attrs;
@end
