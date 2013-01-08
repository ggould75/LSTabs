//
//  BadgeView.h
//  LSTabs
//
//  Created by Marco Mussini on 21/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//


/**
 * Provides a simple Badge view to use along with the class LSTabControl.
 * The badge background is rendered with Core Graphics.
 */
@interface BadgeView : UIView

/**
 * The badge text label.
 */
@property (nonatomic, retain, readonly) UILabel *textLabel;

/**
 * The badge's background color.
 * The default value of this property is grayish blue
 * 
 * @see defaultBadgeColor
 */
@property (nonatomic, retain) UIColor *badgeColor;

/**
 * The corner radius used when rendering the rounded rect outline.
 * The default value of this property is 12
 */
@property (nonatomic, assign) CGFloat cornerRadius;


/**
 * The default badge color.
 */
+ (UIColor *)defaultBadgeColor;


@end
