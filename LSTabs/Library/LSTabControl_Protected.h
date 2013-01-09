//
//  LSTabControl_Protected.h
//  LSTabs
//
//  Created by Marco Mussini on 1/7/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2012 Marco Mussini - Lucky Software

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
