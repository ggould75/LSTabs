//
//  LSTintedButton.m
//  LSTabs
//
//  Created by Marco Mussini on 1/2/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LSTintedButton.h"
#import "UIImage+shortcuts.h"


@interface LSTintedButton()
    
CGContextRef _createBitmapContext(int pixelsWide, int pixelsHigh);
- (UIImage *)_tintedImageFromImage:(UIImage *)image;

@end
    

    
@implementation LSTintedButton


@synthesize backgroundTintColor = _backgroundTintColor;


#pragma mark -
#pragma mark Initialization

+ (id)buttonWithTintColor:(UIColor *)color {
    LSTintedButton *newButton = [LSTintedButton buttonWithType:UIButtonTypeCustom];
    newButton.backgroundTintColor = color;
    
    return newButton;
}


- (void)dealloc {
    [_backgroundTintColor release]; _backgroundTintColor = nil;
    [super dealloc];
}


#pragma mark -

/**
 * Apply a tint to each background image.
 * If no tint was specified, the source image is untouched.
 * Noticed that if the source image has a capInsets, this is also applied to the tinted image
 */
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    UIImage *targetImage = nil;
    
    if (self.backgroundTintColor != nil) {
		UIImage *tintedImage = [self _tintedImageFromImage:image];
		if (UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsZero))
			targetImage = tintedImage;
		else
			// Re-apply the capInsets to the tinted image if required
			targetImage = [tintedImage createImageWithCapInsets:image.capInsets]; 
	}
    else
        targetImage = image;
    
    [super setBackgroundImage:targetImage forState:state];
}


#pragma mark -
#pragma mark Private

CGContextRef _createBitmapContext(int pixelsWide, int pixelsHigh) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// Create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate(NULL, 
                                                       pixelsWide, pixelsHigh, 
                                                       8, 0, colorSpace,
                                                       // this will give us an optimal BGRA format for the device:
                                                       (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}


/**
 * Apply a tint to an image
 */
- (UIImage *)_tintedImageFromImage:(UIImage *)image {
    if (image.size.width == 0 || image.size.height == 0)
		return nil;
    
    // Nothing to change
    if (self.backgroundTintColor == nil)
        return image;
    
    CGFloat scale = 1.0f;
    if ([image respondsToSelector:@selector(scale)])
        scale = image.scale;
    
	// Create a bitmap graphics context the size of the image
	CGContextRef context = _createBitmapContext(image.size.width * scale, image.size.height * scale);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width * scale, image.size.height * scale);
    
    // Set the clipping area to the image
    CGContextClipToMask(context, imageRect, image.CGImage);
    
    // Set the fill color from the tint
    CGContextSetFillColorWithColor(context, self.backgroundTintColor.CGColor);
    CGContextFillRect(context, imageRect);    
    
    // Draw the image using Blend mode overlay
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextDrawImage(context, imageRect, image.CGImage);  
    
    CGImageRef tintedCGImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	// convert the finished reflection image to a UIImage 
	UIImage *tintedImage = [UIImage imageWithCGImage:tintedCGImage 
											   scale:scale 
										 orientation:UIImageOrientationUp];
    CFRelease(tintedCGImage);
    
    return tintedImage;
}


@end
