//
//  CustomTabControl.m
//  LSTabs
//
//  Created by Marco Mussini on 6/26/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "MultiTabControl.h"
#import "LSTabControl_Protected.h"
#import "LSTintedButton.h"
#import "BadgeView.h"


NSString *MultiTabControlSelectedImageName      = @"tab-selected-2";
NSString *MultiTabControlNormalImageName        = @"tab-normal-colored";
NSString *MultiTabControlNormalImageBWName      = @"tab-normal";
NSString *MultiTabControlHighlightedImageName   = @"tab-highlighted-colored";
NSString *MultiTabControlHighlightedImageBWName = @"tab-highlighted";


@interface MultiTabControl ()

- (void)_updateButtonsImages;
- (void)_refreshTintColor:(UIColor *)newColor;

@end



@implementation MultiTabControl

- (void)flashMe {
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationRepeatCount:3.0f];
                         button.titleLabel.alpha = 0.0f;
                     } 
                     completion:^(BOOL completed) {
                         button.titleLabel.alpha = 1.0f;
                     }];
}


#pragma mark -
#pragma mark AMTTabItemDelegate

- (void)tabItem:(LSTabItem *)item tabColorChangedTo:(UIColor *)newColor {
    [self _refreshTintColor:newColor];
}


#pragma mark -
#pragma mark Protected methods

- (void)configureButton {
    button.titleLabel.numberOfLines = 3;
    [button setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:45.0f/255.0f blue:36.0f/255.0f alpha:1.0f] 
                    forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor]
                          forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.7f]
                          forState:UIControlStateSelected];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 8.0f, 0.0f, 6.0f);
    
    // I do not want the selected image to be tinted, this is why I put it before backgroundTintColor = ...
    // It is important to always use this image for the selected state because it is the only image
    // that blend correctly to the background (lo sfondo color cartone!)
    [button setBackgroundImage:[UIImage imageNamed:MultiTabControlSelectedImageName] 
                      forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:MultiTabControlSelectedImageName]
                      forState:UIControlStateSelected | UIControlStateHighlighted];
    
    // Configure the button. 
    // Note that each background image needs to be set after this property so that the tint is applied
    ((LSTintedButton *)button).backgroundTintColor = tintColor;
    
    [self _updateButtonsImages];
}


#pragma mark -
#pragma mark Private methods

- (void)_updateButtonsImages {
    // It needs to be applied on a black&white image
    // I cannot reuse the same image because the tint needs to be applied to a clear image!
    [button setBackgroundImage:[UIImage imageNamed:(tintColor == nil ? MultiTabControlNormalImageName : MultiTabControlNormalImageBWName)] 
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:(tintColor == nil ? MultiTabControlHighlightedImageName : MultiTabControlHighlightedImageBWName)] 
                      forState:UIControlStateHighlighted];
}

// Notice that this class is not able to managed different tint for different control state!
- (void)_refreshTintColor:(UIColor *)newColor {
    [tintColor release];
    tintColor = [newColor retain];
    ((LSTintedButton *)button).backgroundTintColor = newColor;
    
    [self _updateButtonsImages];
}


@end
