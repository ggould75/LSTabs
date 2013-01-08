//
//  ColorButton.m
//  LSTabs
//
//  Created by Marco Mussini on 18/06/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIColor+components.h"
#import "ColorButton.h"


@implementation ColorButton


@synthesize colorIndex;
@synthesize color = _color;


#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        colorIndex = 9999;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)dealloc {
    self.color = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat radius = 10.0f;
    
    // calculates the number's position
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    
    CGRect rrect = CGRectMake(1.0f, 1.0f, self.bounds.size.width-2.0f, self.bounds.size.height-2.0f);
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect); 
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);  
}


@end
