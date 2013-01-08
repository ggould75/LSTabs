//
//  SimpleTabControl.m
//  LSTabs
//
//  Created by Marco Mussini on 26/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "SimpleTabControl.h"
#import "AppDelegate.h"


@implementation SimpleTabControl


- (CGSize)sizeThatFits:(CGSize)size {
    if ([AppDelegate isRetinaDisplay])
        return [super sizeThatFits:size];
    else
        return CGSizeMake(56.0f, 44.0f);
}


#pragma mark -
#pragma mark Protected methods

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *newbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    newbutton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [newbutton setTitle:title 
               forState:UIControlStateNormal];
    
    return newbutton;
}


@end
