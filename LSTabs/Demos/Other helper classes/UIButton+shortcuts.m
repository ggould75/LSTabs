//
//  UIButton+shortcuts.m
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "UIButton+shortcuts.h"
#import "UIImage+shortcuts.h"


@implementation UIButton (shortcuts)


+ (UIButton *)buttonWithNormalStateImage:(UIImage *)normalImage 
                          highlightImage:(UIImage *)highlightImage 
                           selectedImage:(UIImage *)selectedImage
                               capInsets:(UIEdgeInsets)insets
{
    if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero) == NO) {
        normalImage = [normalImage createImageWithCapInsets:insets];
        highlightImage = [highlightImage createImageWithCapInsets:insets];
        selectedImage = [selectedImage createImageWithCapInsets:insets];
    }
    
    // Create a custom button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    if (highlightImage)
        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    if (selectedImage)
        [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    
    return button;
}


@end
