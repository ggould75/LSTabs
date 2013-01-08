//
//  InnerTabControl.m
//  LSTab
//
//  Created by Marco Mussini on 26/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "InnerTabControl.h"
#import "LSTabControl_Protected.h"

#import "LSTintedButton.h"


@implementation InnerTabControl


#pragma mark -
#pragma mark Protected methods

// Even if it is pretty similar I do not call the parent's method to avoid an additional function call
- (UIButton *)buttonWithTitle:(NSString *)title {
    LSTintedButton *newButton = [LSTintedButton buttonWithTintColor:nil];
    newButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [newButton setTitle:title 
               forState:UIControlStateNormal];
    
    newButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:13.0f];
    newButton.titleLabel.numberOfLines = 3;
    newButton.titleLabel.textAlignment = UITextAlignmentCenter;
    newButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);

    [newButton setTitleColor:[UIColor colorWithRed:29.0f/255.0f green:27.0f/255.0f blue:22.0f/255.0f alpha:1.0f] 
                    forState:UIControlStateNormal];
    [newButton setTitleShadowColor:[UIColor colorWithRed:251.0f/255.0f green:242.0f/255.0f blue:149.0f/255.0f alpha:0.5f]  
                          forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:45.0f/255.0f blue:36.0f/255.0f alpha:1.0f] 
                    forState:UIControlStateSelected];
    [newButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.7f]
                          forState:UIControlStateSelected];
    
    newButton.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 8.0f, 0.0f, 6.0f);
    
    return newButton;
}


- (void)configureButtons {
    // I do not want the selected image to be tinted, this is why I put it before backgroundTintColor = ...
    // It is important to always use this image for the selected state because it is the only image
    // that blend correctly to the background (lo sfondo color cartone!)
    [button setBackgroundImage:[UIImage imageNamed:MultiTabControlSelectedImageName] 
                      forState:UIControlStateSelected];
    
    // Configure the button. 
    // Note that each background image needs to be set after this property so that the tint is applied
    ((LSTintedButton *)button).backgroundTintColor = tintColor;
    
    // Here the tint needs to be applied on the colored image instead of to the black&white image
    [button setBackgroundImage:[UIImage imageNamed:MultiTabControlNormalImageName] 
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:MultiTabControlHighlightedImageName] 
                      forState:UIControlStateHighlighted];
}


@end
