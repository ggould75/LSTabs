//
//  ColorPickerBackgroundView.m
//  LSTabs
//
//  Created by Marco Mussini on 18/06/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ColorPickerBackgroundView.h"


@interface ColorPickerBackgroundView () {
    CGGradientRef _gradient;
}

- (void)_initView;

@end



@implementation ColorPickerBackgroundView


#pragma mark -
#pragma mark Initialization

// If initialized from IB
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _initView];
    }
    
    return self;
}


// If initialized from code
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    
    return self;
}


- (void)dealloc {
	CGGradientRelease(_gradient);
	[super dealloc];
}


#pragma mark -

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create rounded corners.
    // Notice that that a much more efficient way to approach drawing images with rounded corners 
    // than it is to use layer's rounded corners (CALayer rounded corners)!!
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds 
                                               byRoundingCorners:UIRectCornerAllCorners 
                                                     cornerRadii:CGSizeMake(16.0f, 16.0f)];
    [path addClip];
    
	CGPoint start, end;
    start = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
    end = CGPointMake(CGRectGetMidX(self.bounds), 90.0f);
    
	// Clip to area to draw the gradient, and draw it. Since we are clipping, we save the graphics state
	// so that we can revert to the previous larger area.
	CGContextSaveGState(context);
	CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
    CGContextDrawLinearGradient(context, _gradient, start, end, options);
    CGContextRestoreGState(context);
}


#pragma mark -
#pragma mark Private

- (void)_initView {
    self.backgroundColor = [UIColor blackColor];
    self.opaque = YES;
    self.clearsContextBeforeDrawing = YES;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();    
    CGFloat colors[] =
    {
        72.0 / 255.0, 1.00,
        24.0 / 255.0, 1.00,
        24.0 / 255.0, 1.00
    };
    CGFloat locations[3] = {0.05f, 0.45f, 0.95f};
    
    _gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 3);
    CGColorSpaceRelease(colorSpace);
}


@end
