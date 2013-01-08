//
//  TintedTabControl.h
//  LSTabs
//
//  Created by Marco Mussini on 1/4/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabControl.h"


@class LSTintedButton;


/**
 * An example of LSTabControl subclass. 
 * It adds the ability to apply a tint color to the encapsulated button
 */
@interface TintedTabControl : LSTabControl {
  @protected
    UIColor *tintColor;    
}

/**
 * Tint color applied to the button
 */
@property (nonatomic, readonly, retain) UIColor *tintColor;


/**
 * Designated initializer
 */
- (id)initWithItem:(LSTabItem *)item
         tintColor:(UIColor *)color;


@end
