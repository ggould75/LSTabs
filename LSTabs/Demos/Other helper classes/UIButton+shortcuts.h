//
//  UIButton+shortcuts.h
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (shortcuts)

+ (UIButton *)buttonWithNormalStateImage:(UIImage *)normalImage 
                          highlightImage:(UIImage *)highlightImage
                           selectedImage:(UIImage *)selectedImage
                               capInsets:(UIEdgeInsets)insets;

@end
