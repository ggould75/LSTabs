//
//  TestVerticalScrollTabBarView.h
//  LSTabs
//
//  Created by Marco Mussini on 1/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSScrollTabBarView.h"


@class LSTabItem;
@class TestVerticalScrollTabBarView;


/**
 * Add the items in a vertical layout instead of horizontal and change some behaviors of the base class,
 * such as the possibility to receive delegate notification even when an item is already selected
 */
@interface TestVerticalScrollTabBarView : LSScrollTabBarView { 
  @protected
    NSInteger lastSelectedTabIndex;
}

/**
 * The default value is LSTabBarViewNoItem (no item selected) until the user touches an item. 
 * Set this property to LSTabBarViewNoItem to turn off the current selection
 */
@property (nonatomic, assign) NSInteger lastSelectedTabIndex;

/**
 * Set/get the selected item by its object 
 * (the item is retrieved searching for the item with item.object = selectedObject)
 */
@property (nonatomic, assign) id        selectedObject;

/**
 * Returns the item at a given index
 */
- (LSTabItem *)itemAtIndex:(NSInteger)index;

/**
 * A convenience method to add a new tab to the tail
 */
- (void)addItem:(LSTabItem *)item animated:(BOOL)animated;

/**
 * A convenience method to remove all tabs
 */
- (void)removeAllItemsAnimated:(BOOL)animated;


/**
 * Expand an item loading its sub-items.
 *
 * LIMITATIONS:
 * - This is not a generic implementation but a very specific implementation for testing purposes
 * - It looks for the LSTabItem at index and uses the .object property to get the selected language
 * - so do not use this method as is in your project!
 * 
 * @TODO: a better implementation should be that is the model (LSTabItem or its subclass)
 *  who notify its view of a change in the expanded property, but for now the model is just able to notify its
 *  main view (LSTabControl) and not its container view (LSScrollTabBarView)...
 */
- (void)expandItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)scrollToTopAnimated:(BOOL)animated;

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;


@end
