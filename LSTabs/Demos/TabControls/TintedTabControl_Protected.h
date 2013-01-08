//
//  TintedTabControl_Protected.h
//  LSTabs
//
//  Created by Marco Mussini on 21/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "TintedTabControl.h"


/**
 * TintedTabControl Protected methods.
 *
 * This header file should only be imported in your implementation files, NEVER import in a subclass's interface file.
 * NEVER calls these methods as if they would be public!
 *
 * Because Objective-C does not support protected methods this is one way to simulate such methods.
 * Include this header file in your .m implementation if you need to call the superclass implementation
 * and avoid warning messages.
 */
@interface TintedTabControl()

- (void)configureButton;

@end
