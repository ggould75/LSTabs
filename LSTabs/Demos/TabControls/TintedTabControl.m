//
//  TintedTabControl.h
//  LSTabs
//
//  Created by Marco Mussini on 1/4/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "TintedTabControl.h"
#import "LSTabControl_Protected.h"
#import "LSTintedButton.h"
#import "UIImage+shortcuts.h"

// View shortcuts
#import "UIView+Addictions.h"



@implementation TintedTabControl


@synthesize tintColor;


#pragma mark -
#pragma mark Initialization

- (id)initWithItem:(LSTabItem *)item {
    return [self initWithItem:item 
                    tintColor:nil];
}


- (id)initWithItem:(LSTabItem *)item 
         tintColor:(UIColor *)color 
{
    self = [super initWithItem:item];
    if (self) {
        tintColor = [color retain];
		[self configureButton];
    }
    
    return self;
}


- (void)dealloc {
    [tintColor release]; tintColor = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Protected methods

- (UIButton *)buttonWithTitle:(NSString *)title {
    LSTintedButton *newButton = [LSTintedButton buttonWithTintColor:nil];
    newButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [newButton setTitle:title 
               forState:UIControlStateNormal];
    
    newButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    newButton.titleLabel.textAlignment = UITextAlignmentCenter;
    newButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [newButton setTitleColor:[UIColor whiteColor] 
                    forState:UIControlStateNormal];
    [newButton setTitleShadowColor:[UIColor clearColor]
                          forState:UIControlStateNormal];
    [newButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.7f]
                          forState:UIControlStateSelected];
    
    return newButton;
}


- (void)configureButton {
    // Depending on when I set the backgroundTintColor property, the images of the button will be tinted or not.
    // Here I'm assigning the same tint to all the background images
    ((LSTintedButton *)button).backgroundTintColor = tintColor;
    
    // The tint should be applied to a Black&White image
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0f, 6.0f, 22.0f, 6.0f);
    [button setBackgroundImage:[[UIImage imageNamed:@"button1-normal"] createImageWithCapInsets:capInsets]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[[UIImage imageNamed:@"button1-pressed"] createImageWithCapInsets:capInsets]
                      forState:UIControlStateHighlighted];
}


@end
