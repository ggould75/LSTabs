//
//  LSTabBarView_Protected.h
//  AllMyThings
//
//  Created by Marco Mussini on 1/6/12.
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

#import <Foundation/Foundation.h>
#import "LSTabBarView.h"


/**
 * LSTabBarView Protected methods.
 *
 * This header file should only be imported in your implementation files, NEVER import in a subclass's interface file.
 * NEVER calls these methods as if they would be public!
 *
 * Because Objective-C does not support protected methods this is one way to simulate such methods.
 * Include this header file in your .m implementation if you need to call the superclass implementation
 * and avoid warning messages.
 *
 * @SEE: http://stackoverflow.com/questions/1582581/private-methods-using-categories-in-objective-c-calling-super-from-a-subclass
 * @SEE: http://useyourloaf.com/blog/2010/9/14/objective-c-anonymous-categories.html
 */
@interface LSTabBarView ()

- (void)addTab:(LSTabControl *)tab;

- (void)removeTab:(LSTabControl *)tab;

- (LSTabControl *)tabViewForItem:(LSTabItem *)item atIndex:(NSInteger)index;

- (CGFloat)paddingForItem:(LSTabItem *)item atIndex:(NSInteger)index;

- (CGSize)layoutTabsIfNeeded;

- (CGSize)layout;

- (void)invalidateLayout;

- (BOOL)layoutIsValid;

- (void)animateNewTabs:(NSArray *)tabs atIndex:(NSUInteger)startIndex;

- (void)animateRemoveTabs:(NSArray *)tabs atIndex:(NSUInteger)startIndex;

- (void)updateTabsInRange:(NSRange)range;

@end
