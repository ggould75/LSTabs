//
//  LSTabBarView_Protected.h
//  AllMyThings
//
//  Created by Marco Mussini on 1/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

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
