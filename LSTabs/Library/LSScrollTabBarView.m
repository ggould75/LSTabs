//
//  LSScrollableTabView.m
//  LSTabs
//
//  Created by Marco Mussini on 1/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSScrollTabBarView.h"
#import "LSTabBarView_Protected.h"
#import "LSScrollTabBarView_Protected.h"

#import "LSTabControl.h"

// View shortcuts
#import "UIView+Addictions.h"



@interface LSScrollTabBarView ()

- (void)_updateOverflow;

@end



@implementation LSScrollTabBarView


- (id)initWithItems:(NSArray *)items delegate:(id <LSTabBarViewDelegate>)aDelegate {
    // The scrollView must be istantiated before calling super!
    // See addTab.
    scrollView = [[UIScrollView alloc] init];
    
    self = [super initWithItems:items delegate:aDelegate];
    if (self) {
        scrollView.scrollEnabled = YES;
        scrollView.scrollsToTop = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = YES;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.alwaysBounceVertical = NO;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scrollView.delegate = self;
        [self addSubview:scrollView];
    }
    
    return self;
}


- (void)dealloc {
    scrollView.delegate = nil;  // Important! Avoid that a scrollview delegate method would be called if when the delegate is already released
                                // if you see something like: *** -[AMTScrollTabBarView scrollViewDidScroll:]: message sent to deallocated instance 0x7c07000
                                // that is a sign that the problem is not yet completely solved!...
    [overflowLeft release]; overflowLeft = nil;
    [overflowRight release]; overflowRight = nil;
    [scrollView release]; scrollView = nil;
    
    [super dealloc];
}


#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _updateOverflow];
}


- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    // This check ensure that the frames of each tabs are defined even if the view is not yet rendered
    if (frames.count == 0)
        [self layoutIfNeeded];
    
    [scrollView scrollRectToVisible:((UIView *)[tabViews objectAtIndex:index]).frame animated:animated];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self _updateOverflow];
} 


#pragma mark -
#pragma mark Protected methods

- (void)addTab:(LSTabControl *)tab {
    [scrollView addSubview:tab];
    [self setNeedsLayout];
}

- (void)removeTab:(LSTabControl *)tab {
    [super removeTab:tab];
    [self setNeedsLayout];
}


- (CGSize)layoutTabsIfNeeded {
    CGSize size = [super layoutTabsIfNeeded];
    [self adjustScrollViewWithSize:size];
    
    return size;
}


- (void)adjustScrollViewWithSize:(CGSize)size {
    CGPoint contentOffset = scrollView.contentOffset;
    scrollView.frame = self.bounds;
    scrollView.contentSize = CGSizeMake(size.width + self.margin, self.viewHeight);
    scrollView.contentOffset = contentOffset;
}


#pragma mark -
#pragma mark Private

// @TODO: not completed and tested!
- (void)_updateOverflow {
    if (scrollView.contentOffset.x < (scrollView.contentSize.width-self.viewWidth)) {
        if (!overflowRight) {
            overflowRight = [[UIView alloc] initWithFrame:CGRectZero];
            overflowRight.userInteractionEnabled = NO;
            overflowRight.backgroundColor = [UIColor clearColor];
            [overflowRight sizeToFit];
            [self addSubview:overflowRight];
        }
        
        overflowRight.viewLeft = self.viewWidth - overflowRight.viewWidth;
        overflowRight.hidden = NO;
        
    } else {
        overflowRight.hidden = YES;
    }
    if (scrollView.contentOffset.x > 0) {
        if (!overflowLeft) {
            overflowLeft = [[UIView alloc] initWithFrame:CGRectZero];
            overflowLeft.userInteractionEnabled = NO;
            overflowLeft.backgroundColor = [UIColor clearColor];
            [overflowLeft sizeToFit];
            [self addSubview:overflowLeft];
        }
        
        overflowLeft.hidden = NO;
        
    } else {
        overflowLeft.hidden = YES;
    }
}


@end
