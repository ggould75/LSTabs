//
//  UIView+Addictions.h
//  LSTabs
//
//  Created by Marco Mussini on 1/4/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//



#import <UIKit/UIKit.h>


@interface UIView (Addictions)


/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic, assign) CGFloat viewLeft;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = viewTop
 */
@property (nonatomic, assign) CGFloat viewTop;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = viewRight - frame.size.width
 */
@property (nonatomic, assign) CGFloat viewRight;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = viewBottom - frame.size.height
 */
@property (nonatomic, assign) CGFloat viewBottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = viewWidth
 */
@property (nonatomic, assign) CGFloat viewWidth;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = viewHeight
 */
@property (nonatomic, assign) CGFloat viewHeight;

/**
 * Shortcut for center.x
 *
 * Sets center.x = viewCenterX
 */
@property (nonatomic, assign) CGFloat viewCenterX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = viewCenterY
 */
@property (nonatomic, assign) CGFloat viewCenterY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic, assign) CGPoint viewOrigin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic, assign) CGSize viewSize;


@end
