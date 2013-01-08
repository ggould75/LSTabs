//
//  ScrollTabBarController.h
//  LSTabs
//
//  Created by Marco Mussini on 26/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSTabBarView.h"
#import "MultiTabItem.h"


/**
 * Possible view states
 */
typedef enum {
    ScrollTabBarViewStateUndefined = 0,
    ScrollTabBarViewStateLanguages,
    ScrollTabBarViewStateCategories
} ScrollTabBarViewState;


@class ScrollTabBarController;


@protocol ScrollTabBarControllerDelegate <NSObject>

@optional
- (void)tabBarController:(ScrollTabBarController *)controller 
 accessoryButtonSelected:(MultiTabItemType)buttonType 
				 tabItem:(LSTabItem *)item 
				 atIndex:(NSInteger)selectedIndex;

- (void)tabBarController:(ScrollTabBarController *)controller 
			 tabSelected:(LSTabItem *)item 
				 atIndex:(NSInteger)selectedIndex;

- (void)tabBarController:(ScrollTabBarController *)controller mostNestedLevelReachedForTabItem:(LSTabItem *)item;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 * Manages two different  class controller.
 * @SEE: http://stackoverflow.com/questions/8924950/subclass-uiviewcontroller-or-create-a-custom-nsobject-when-the-view-is-not-fulls
 */
@interface ScrollTabBarController : NSObject <LSTabBarViewDelegate> { }


/**
 * The parent view of the two scrollview
 */
@property (nonatomic, readonly) UIView *view;

/**
 * The current typology of entity displayed.
 * The default value of this property is ScrollTabBarViewStateUndefined
 */
@property (nonatomic, assign) ScrollTabBarViewState viewState;

@property (nonatomic, assign) id <ScrollTabBarControllerDelegate> delegate;


/**
 * Change the current root language animating the transition if necessary
 */
- (void)setRootLanguage:(NSDictionary *)language animated:(BOOL)animated;

/**
 * Returns the current selected tabItem
 */
- (LSTabItem *)selectedTabItem;

/**
 * Change the current view state animating the transition if requested
 */
- (void)setViewState:(ScrollTabBarViewState)newViewState animated:(BOOL)animated;


@end
