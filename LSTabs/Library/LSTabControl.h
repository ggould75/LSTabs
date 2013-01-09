//
//  LSTabControl.h
//  LSTabs
//
//  Created by Marco Mussini on 1/3/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2012 Marco Mussini - Lucky Software

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

#import "LSTabItem.h"



@interface LSTabControl : UIControl <LSTabItemDelegate> {
  @protected
    UIButton    *button;
    UIView      *badgeView;
    LSTabItem   *tabItem;
}

/**
 * Data model bound to this tab
 */
@property (nonatomic, retain) LSTabItem *tabItem;

/**
 * Returns the view used to display the badge number.
 * Extend LSTabControl if you want to use a different view class
 */
@property (nonatomic, retain, readonly) UIView *badgeView;

/**
 * Max allowed badge number. 
 * If the value to display is greater than the value returned by this accessor,
 * the text will be displayed as [maxBadgeNumber]+
 */
@property (nonatomic, assign) NSUInteger maxBadgeNumber;


/**
 * Designated initializer
 */
- (id)initWithItem:(LSTabItem *)item;


// Methods to change/query the appearance of the inner UIButton object.
// You can set the image, title color, title shadow color, and background image to use for each state. 
// You can specify data for a combined state by using the flags added together. 
// In general, you should specify a value for the normal state to be used
// by other states which don't have a custom value set.

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (NSString *)titleForState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;
- (UIColor *)titleShadowColorForState:(UIControlState)state;
- (UIImage *)imageForState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;


@end
