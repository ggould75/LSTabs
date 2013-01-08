//
//  LSTabBarView.h
//  LSTabs
//
//  Created by ludwig on 1/5/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LSTabControl;
@class LSTabItem;
@class LSTabBarView;


@protocol LSTabBarViewDelegate <NSObject>

@optional
/**
 * Asks the delegate for a LSTabControl object to display at the specified index of the tab bar view.
 * If not implemented the view will be provided by the subclass itself 
 * (see the protected method tabViewForItem:atIndex:)
 */
- (LSTabControl *)tabBar:(LSTabBarView *)tabBar tabViewForItem:(LSTabItem *)item atIndex:(NSInteger)index;

/**
 * Asks the delegate for the padding to use for an item at the specified index.
 * If this method is implemented, the value it returns overrides the value specified for the itemPadding 
 * property of LSTabBarView for the given index
 */
- (CGFloat)tabBar:(LSTabBarView *)tabBar paddingForItem:(LSTabItem *)item atIndex:(NSInteger)index;

- (void)tabBar:(LSTabBarView *)tabBar tabHighlighted:(LSTabItem *)item atIndex:(NSInteger)highlightedIndex;
- (void)tabBar:(LSTabBarView *)tabBar tabSelected:(LSTabItem *)item atIndex:(NSInteger)selectedIndex;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 * An item index value indicating that there is no item segment. 
 * See selectedSegmentIndex for further information.
 */
enum {
    LSTabBarViewNoItem = -1
};



@interface LSTabBarView : UIView {
  @protected
	NSInteger        selectedTabIndex;
	NSMutableArray  *tabItems;
	NSMutableArray  *tabViews;
    NSMutableArray  *frames;
    
    CGFloat          margin;
    CGFloat          itemPadding;
    
    BOOL             contentSizeCached;
    CGSize           contentSize;
    
	id <LSTabBarViewDelegate> delegate;
}

@property (nonatomic, assign)   LSTabItem     *selectedTabItem;
@property (nonatomic, assign)   LSTabControl  *selectedTabView;

/**
 * The default value is LSTabBarViewNoItem (no item selected) until the user touches an item. 
 * Set this property to -1 to turn off the current selection
 */
@property (nonatomic, assign)   NSInteger      selectedTabIndex;

@property (nonatomic, readonly) NSUInteger     numberOfItems;

/**
 * This margin value is applied before the first item and after the last.
 * The default value of this property is 0.0
 */
@property (nonatomic, assign)   CGFloat        margin;

/**
 * Padding applied between items.
 * The default value of this property is 5.0
 */
@property (nonatomic, assign)   CGFloat        itemPadding;

@property (nonatomic, assign)   id <LSTabBarViewDelegate> delegate;


/**
 * Use this initializer if it is your subclass that provides the tab views
 */
- (id)initWithItems:(NSArray *)items;

/**
 * Designated initializer
 * Use this initializer if you want to provide the tab views from your delegate object
 */
- (id)initWithItems:(NSArray *)items delegate:(id <LSTabBarViewDelegate>)aDelegate;

- (void)showTabAtIndex:(NSInteger)tabIndex;
- (void)hideTabAtIndex:(NSInteger)tabIndex;

/**
 * Add a new tab.
 * Important: index must be a number between 0 and the number of items (numberOfItem); 
 *            values exceeding this upper range are pinned to it.
 * If index is already occupied, the objects at index and beyond are shifted
 */
- (void)insertItem:(LSTabItem *)item atIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 * Add more tabs starting from the specified index.
 * The animation will be done once for all the tabs.
 * Important: index must be a number between 0 and the number of items (numberOfItem); 
 *            values exceeding this upper range are pinned to it.
 * If index is already occupied, the objects at index and beyond are shifted
 */
- (void)insertItems:(NSArray *)items startingFromIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 * Remove a tab at a given index.
 * Important: index must be a number between 0 and the number of items (numberOfItem) less 1; 
 *            values exceeding this upper range are pinned to it
 */
- (void)removeItemAtIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 * Removes from the view each of the tabs within a given range.
 * The animation will be done once for all the tabs.
 * Important: index must be a number between 0 and the number of items (numberOfItem) less 1; 
 *            values exceeding this upper range are pinned to it
 */
- (void)removeItemsInRange:(NSRange)range animated:(BOOL)animated;


@end

