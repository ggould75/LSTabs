//
//  DrawingUtilities.m
//  LSTabs
//
//  Created by Marco Mussini on 22/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "DrawingUtilities.h"


void DrawRoundedRect(CGContextRef context, CGRect rect, CGFloat radius) {
	CGPoint min = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGPoint max = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
	
	CGContextMoveToPoint(context, min.x, mid.y);
	CGContextAddArcToPoint(context, min.x, min.y, mid.x, min.y, radius);
	CGContextAddArcToPoint(context, max.x, min.y, max.x, mid.y, radius);
	CGContextAddArcToPoint(context, max.x, max.y, mid.x, max.y, radius);
	CGContextAddArcToPoint(context, min.x, max.y, min.x, mid.y, radius);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
}
