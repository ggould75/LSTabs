//
//  UIView+Addictions.m
//  LSTabs
//
//  Created by Marco Mussini on 1/4/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//


#import "UIView+Addictions.h"


@implementation UIView (Addictions)


- (CGFloat)viewLeft {
    return self.frame.origin.x;
}


- (void)setViewLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)viewTop {
    return self.frame.origin.y;
}


- (void)setViewTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)viewRight {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setViewRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)viewBottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setViewBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)viewCenterX {
    return self.center.x;
}


- (void)setViewCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)viewCenterY {
    return self.center.y;
}


- (void)setViewCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)viewWidth {
    return self.frame.size.width;
}


- (void)setViewWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)viewHeight {
    return self.frame.size.height;
}


- (void)setViewHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGPoint)viewOrigin {
    return self.frame.origin;
}


- (void)setViewOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)viewSize {
    return self.frame.size;
}


- (void)setViewSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end
