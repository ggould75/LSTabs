//
//  VerticalScrollTabBarView.m
//  LSTabs
//
//  Created by Marco Mussini on 1/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "VerticalScrollTabBarView.h"

#import "LSTabControl.h"
#import "LSTabBarView_Protected.h"

// View shortcuts
#import "UIView+Addictions.h"



@implementation VerticalScrollTabBarView


- (id)initWithItems:(NSArray *)items delegate:(id <LSTabBarViewDelegate>)aDelegate {
    self = [super initWithItems:items delegate:aDelegate];
    if (self) {
        scrollView.bounces = YES;
        scrollView.alwaysBounceHorizontal = NO;
        scrollView.alwaysBounceVertical = YES;
    }
       
    return self;
}


#pragma mark -

- (void)scrollToTopAnimated:(BOOL)animated {
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
}


#pragma mark -
#pragma mark Protected methods

- (CGSize)layout {
    CGFloat padding;
    CGFloat y = self.margin;
    
    if (frames == nil)
        frames = [[NSMutableArray alloc] initWithCapacity:tabViews.count]; 
    

    for (int i = 0; i < tabViews.count; ++i) {
        LSTabControl *tab = [tabViews objectAtIndex:i];
        CGSize tabSize = [tab sizeThatFits:CGSizeZero];
        
        padding = [self paddingForItem:[tabItems objectAtIndex:i] 
                               atIndex:i];
        
        [frames addObject:[NSValue valueWithCGRect:CGRectMake(1.0f, y, tabSize.width, tabSize.height)]];
        y += tabSize.height + padding;
    }
    
    contentSize = CGSizeMake(self.viewWidth, y - padding);
    contentSizeCached = YES;

    return contentSize;
}


- (void)adjustScrollViewWithSize:(CGSize)size {
    CGPoint contentOffset = scrollView.contentOffset;
    scrollView.frame = self.bounds;
    scrollView.contentSize = CGSizeMake(size.width, size.height + self.margin);
    scrollView.contentOffset = contentOffset;
}


- (void)animateNewTabs:(NSArray *)tabs atIndex:(NSUInteger)startIndex {
    [UIView animateWithDuration:0.2f
              delay:0.0f
            options:UIViewAnimationOptionCurveEaseIn

         animations:^{
             NSUInteger numberOfTabsToMove = self.numberOfItems - (startIndex + 1);
             [self updateTabsInRange:NSMakeRange(startIndex + 1, numberOfTabsToMove)];
         }

         completion:^(BOOL finished) {
             // Makes all the tabs transparent and change their initial frames
             // so that the will appear from right to left
             [tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
                 LSTabControl *tab = (LSTabControl *)obj;
                 index += startIndex;
                 
                 tab.alpha = 0.0f;
                 
                 NSValue *val = (NSValue *)[frames objectAtIndex:index];
                 CGRect tabFinalFrame = [val CGRectValue];
                 CGRect tabInitialFrame = tabFinalFrame;
                 tabInitialFrame.origin.x += tabFinalFrame.size.width + 5.0f;
                 tab.frame = tabInitialFrame;
                 
                 [self addTab:tab];   // Will call layoutSubviews but it won't do nothing 
                                      // because the layout is already done
                 
                 // Bring to front the parent tab
                 if (index == startIndex)
                     [scrollView bringSubviewToFront:self.selectedTabView];
             }];
             
             [UIView animateWithDuration:0.15f
                                   delay:0.0f
                                 options:UIViewAnimationOptionCurveEaseIn
              
                              animations:^{
                                  [self updateTabsInRange:NSMakeRange(startIndex, tabs.count)];
                                  [tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
                                      ((LSTabControl *)obj).alpha = 1.0f;
                                  }];
                              }
              
                              completion:^(BOOL finished) {
                                  
                              }];
         }];
}


- (void)animateRemoveTabs:(NSMutableArray *)tabs atIndex:(NSUInteger)startIndex {
    [UIView animateWithDuration:0.15f
              delay:0.0f
            options:UIViewAnimationOptionCurveEaseOut

         animations:^{
             [tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
                 LSTabControl *tab = (LSTabControl *)obj;
                 
                 tab.alpha = 0.0f;
                 
                 CGRect tabInitialFrame = tab.frame;
                 CGRect tabFinalFrame = tabInitialFrame;
                 tabFinalFrame.origin.x += tabInitialFrame.size.width + 5.0f;
                 tab.frame = tabFinalFrame;
             }];
         }

         completion:^(BOOL finished) {
             // Makes all the tabs transparent and change their initial frames
             // so that the will appear from left to right
             [tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
                 LSTabControl *tab = (LSTabControl *)obj;
                 [self removeTab:tab];
             }];
             
             [tabs removeAllObjects];  // Will release all tabs
             
             [UIView animateWithDuration:0.2f
                                   delay:0.0f
                                 options:UIViewAnimationOptionCurveEaseOut
              
                              animations:^{
                                  NSUInteger numberOfTabsToMove = self.numberOfItems - startIndex;
                                  [self updateTabsInRange:NSMakeRange(startIndex, numberOfTabsToMove)];
                              }
              
                              completion:^(BOOL finished) {
                                  
                              }];
         }];
}


@end
