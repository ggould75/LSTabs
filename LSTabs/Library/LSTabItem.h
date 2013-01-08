//
//  LSTabItem.h
//  LSTabs
//
//  Created by Marco Mussini on 1/3/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LSTabItem;


@protocol LSTabItemDelegate <NSObject>

- (void)tabItem:(LSTabItem *)item badgeNumberChangedTo:(int)value;
- (void)tabItem:(LSTabItem *)item titleChangedTo:(NSString *)title;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////


@class LSTabControl;


@interface LSTabItem : NSObject {
  @protected
    NSString     *title;
    id            object;
    NSInteger     badgeNumber;
    LSTabControl *parentTabControl;
}

@property (nonatomic, copy)	  NSString     *title;
@property (nonatomic, retain) id			object;
@property (nonatomic, assign) NSInteger	 badgeNumber;

/**
 * Integer identifier useful to identify the item when nor the title or the object properties
 * are valid to recognize the item's type
 */
@property (nonatomic, assign) NSUInteger	 idMask;

@property (nonatomic, assign) LSTabControl *parentTabControl;


/**
 * Identical to the designated initializer but force selectable to YES
 */
- (id)initWithTitle:(NSString *)aTitle;


@end
