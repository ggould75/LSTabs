//
//  TintedVerticalTabControl.m
//  LSTabs
//
//  Created by Marco Mussini on 21/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "TintedVerticalTabControl.h"
#import "TintedTabControl_Protected.h"
#import "BadgeView.h"
#import "LSTintedButton.h"

// View shortcuts
#import "UIView+Addictions.h"



@implementation TintedVerticalTabControl


- (id)initWithItem:(LSTabItem *)item 
         tintColor:(UIColor *)color 
{
    self = [super initWithItem:item tintColor:color];
    if (self) {
        // Change the default color of the badge
        ((BadgeView *)self.badgeView).badgeColor = [UIColor redColor];
    }
    
    return self;
}


#pragma mark -

- (CGSize)sizeThatFits:(CGSize)size {
    // Force to the image size
    return CGSizeMake(76.0f, 136.0f);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
	// Relocate the badge view to the upper-left corner
    badgeView.frame = CGRectMake(0.0f, 23.0f, badgeView.viewWidth, badgeView.viewHeight);
}


#pragma mark -
#pragma mark Protected methods

- (void)configureButton {
    button.titleLabel.numberOfLines = 3;
    button.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 8.0f, 0.0f, 10.0f);
    [button setTitleColor:[UIColor colorWithRed:29.0f/255.0f green:27.0f/255.0f blue:22.0f/255.0f alpha:1.0f]
                 forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:251.0f/255.0f green:242.0f/255.0f blue:149.0f/255.0f alpha:0.5f]
                       forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:45.0f/255.0f blue:36.0f/255.0f alpha:1.0f]
                 forState:UIControlStateSelected];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.4f]
                       forState:UIControlStateSelected];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.2f]
                       forState:UIControlStateSelected | UIControlStateHighlighted];
    
    // Depending on when I set the backgroundTintColor property the images of the button will be tinted or not.
    // Here I don't want the selected/selected-highlighted images to be colored because the image itself is already colored
    [button setBackgroundImage:[UIImage imageNamed:@"tab-selected"]
                      forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"tab-selected-highlighted"]
                      forState:UIControlStateSelected | UIControlStateHighlighted];
    
    // The normal/highlighted images will be instead tinted
    ((LSTintedButton *)button).backgroundTintColor = tintColor;
    
    [button setBackgroundImage:[UIImage imageNamed:@"tab-normal"]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"tab-highlighted"]
                      forState:UIControlStateHighlighted];
}


@end
