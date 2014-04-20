//
//  NSString+DP.m
//  DPCalendar
//
//  Created by Shan Wang on 20/04/2014.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "NSString+DP.h"
#import "DPConstants.h"

@implementation NSString (DP)

-(CGRect)dp_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context {
    if (IS_OS_7_OR_LATER) {
        return [self boundingRectWithSize:size
                                           options:options
                                        attributes:attributes context:context];
    } else {
        UIFont *font = attributes[NSFontAttributeName];
        CGSize stringSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        return CGRectMake(0, 0, stringSize.width, stringSize.height);
    }
}

- (void)dp_drawAtPoint:(CGPoint)point withAttributes:(NSDictionary *)attrs {
    if (IS_OS_7_OR_LATER) {
        [self drawAtPoint:point withAttributes:attrs];
    } else {
        [(UIColor *)attrs[NSForegroundColorAttributeName] set];
        NSMutableParagraphStyle *textStyle = attrs[NSParagraphStyleAttributeName];
        [self drawAtPoint:point forWidth:CGFLOAT_MAX withFont:attrs[NSFontAttributeName] lineBreakMode:textStyle.lineBreakMode];
        
    }
}

- (void)dp_drawInRect:(CGRect)rect withAttributes:(NSDictionary *)attrs {
    if (IS_OS_7_OR_LATER) {
        [self drawInRect:rect withAttributes:attrs];
    } else {
        NSMutableParagraphStyle *textStyle = attrs[NSParagraphStyleAttributeName];
        [(UIColor *)attrs[NSForegroundColorAttributeName] set];
        [self drawInRect:rect withFont:attrs[NSFontAttributeName] lineBreakMode:textStyle.lineBreakMode alignment:textStyle.alignment];
    }
}

@end
