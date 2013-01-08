//
//  MultiTabItem.h
//  LSTabs
//
//  Created by Marco Mussini on 6/26/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabItem.h"


/**
 * A way a MultiTabItem is identified
 */
typedef enum {
    MultiTabItemNoneType           = 0,
	MultiTabItemOptionsType        = 1 << 0,
	MultiTabItemBackType           = 1 << 1,
	MultiTabItemSeparatorType      = 1 << 2,
    MultiTabItemCurrentLevelType   = 1 << 3,
    MultiTabItemInnerLevelType     = 1 << 4,
    MultiTabItemCategoryType       = 1 << 5,
    MultiTabItemLanguageType       = 1 << 6
} MultiTabItemType;



@protocol MultiTabItemDelegate <LSTabItemDelegate>

- (void)tabItem:(LSTabItem *)item tabColorChangedTo:(UIColor *)newColor;

@end



@interface MultiTabItem : LSTabItem  { 
  @protected
    UIColor *color;
}

/**
 * Tab color. I consider this property as part of the model.
 * This is just a sample property used to notify a color change to the view
 * when the color in the model is changed
 */
@property (nonatomic, retain) UIColor *color;

/**
 * Change the internal expanded state of the item.
 * @TODO: the view is not notified of the change. See comment on TestVerticalScrollTabBarView::expandItemAtIndex
 */
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;


/**
 * Creates and returns an item with all the properties filled from a language dictionary
 */
+ (id)tabItemWithLanguage:(NSDictionary *)language;

/**
 * Search an item by object within a list of LSTabItem objects
 */
+ (NSInteger)findIndexOfItemWithObject:(NSObject *)anObject inArray:(NSArray *)items;


@end
