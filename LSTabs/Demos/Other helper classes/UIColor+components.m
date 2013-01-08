//
//  UIColor+components.m
//  LSTabs
//
//  Created by Marco Mussini on 5/24/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "UIColor+components.h"


@implementation UIColor (components)


- (const CGFloat *)getRGBAColorComponents {
    CGColorRef colorRef = [self CGColor];
    const CGFloat *components = NULL;
    
    int numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents == 4)
        components = CGColorGetComponents(colorRef);
    
    return components;
}


@end
