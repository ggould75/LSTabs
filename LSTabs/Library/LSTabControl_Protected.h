//
//  LSTabControl_Protected.h
//  LSTabs
//
//  Created by Marco Mussini on 1/7/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabControl.h"


/**
 * LSTabView Protected methods.
 *
 * This header file should only be imported in your implementation files, NEVER import in a subclass's interface file.
 * NEVER calls these methods as if they would be public!
 *
 * Because Objective-C does not support protected methods this is one way to simulate such methods.
 * Include this header file in your .m implementation if you need to call the superclass implementation
 * and avoid warning messages.
 */
@interface LSTabControl()

/**
 * Create and returns a UIButton class to use as tab interactive background.
 * Subclass might override this method to apply further customizations
 */
- (UIButton *)buttonWithTitle:(NSString *)title;

/**
 * Update the badge view text. 
 * The badge view is created the first time this method is called. 
 * See the accessor self.badgeView in order to change the class instantiated for the badge
 */
- (void)updateBadgeNumber;

/**
 * Update the text inside of the badge view
 */
- (void)updateBadgeText:(NSString *)text;


@end
