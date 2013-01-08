//
//  LSTintedButton.h
//  LSTabs
//
//  Created by Marco Mussini on 1/2/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LSTintedButton : UIButton

@property (nonatomic, retain) UIColor *backgroundTintColor;

/**
 * Designated initializer
 */
+ (id)buttonWithTintColor:(UIColor *)color;


@end
