//
//  UIImage+shortcuts.m
//  LSTabs
//
//  Created by Marco Mussini on 6/19/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "UIImage+shortcuts.h"


@implementation UIImage (shortcuts)


- (UIImage *)createImageWithCapInsets:(UIEdgeInsets)capInsets {
    UIImage *newImage;
    
    // iOS >= 5
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)])
        newImage = [self resizableImageWithCapInsets:capInsets];
    else {
        // Try to reproduce the resizableImageWithCapInsets behavior.
        // Wait! This method will work only if the edges of the image are symmetric!
        newImage = [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    
    return newImage;
}


@end
