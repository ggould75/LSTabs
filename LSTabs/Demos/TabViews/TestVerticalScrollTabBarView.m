//
//  TestVerticalScrollTabBarView.m
//  LSTabs
//
//  Created by Marco Mussini on 1/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "TestVerticalScrollTabBarView.h"

#import "LSTabControl.h"
#import "LSTabBarView_Protected.h"
#import "SimpleTabControl.h"
#import "MultiTabControl.h"
#import "MultiTabItem.h"
#import "ObjectCollection.h"

// View shortcuts
#import "UIView+Addictions.h"


@interface TestVerticalScrollTabBarView()
- (NSArray *)_tabItemsFromLanguage:(NSDictionary *)language;
@end



@implementation TestVerticalScrollTabBarView


@synthesize lastSelectedTabIndex;


- (id)initWithItems:(NSArray *)items delegate:(id <LSTabBarViewDelegate>)aDelegate {
    self = [super initWithItems:items delegate:aDelegate];
    if (self) {
        scrollView.bounces = YES;
        scrollView.alwaysBounceHorizontal = NO;
        scrollView.alwaysBounceVertical = YES;
        
        itemPadding = -50.0f;
        
        lastSelectedTabIndex = LSTabBarViewNoItem;
    }
       
    return self;
}


#pragma mark -
#pragma mark Accessors

- (void)setSelectedTabIndex:(NSInteger)newSelectedTabIndex {
    void (^notifyDelegate)(SEL, LSTabItem *, NSInteger) = ^(SEL selector, LSTabItem *item, NSInteger index) {
        if ([self.delegate respondsToSelector:selector]) {
            [self.delegate tabBar:self 
                      tabSelected:item
                          atIndex:index];
        }
    };
    
    if (newSelectedTabIndex != LSTabBarViewNoItem) {
        LSTabItem *item = [tabItems objectAtIndex:newSelectedTabIndex];
        // Do not allow the following items to be selected
        if (item.idMask & MultiTabItemOptionsType || item.idMask & MultiTabItemBackType) {
            notifyDelegate(@selector(tabBar:tabSelected:atIndex:), 
                           [tabItems objectAtIndex:newSelectedTabIndex], 
                           newSelectedTabIndex);
            return;
        }
    }
    
    // I want to notify the delegate even if the same tab is selected multiple times
    if (newSelectedTabIndex != selectedTabIndex || newSelectedTabIndex == LSTabBarViewNoItem)
        [super setSelectedTabIndex:newSelectedTabIndex];
    else {
        notifyDelegate(@selector(tabBar:tabSelected:atIndex:), 
                       self.selectedTabItem, 
                       selectedTabIndex);
		return;
    }
    
    self.lastSelectedTabIndex = newSelectedTabIndex;
    
    if (newSelectedTabIndex != LSTabBarViewNoItem) {
        // Bring to foreground the selected tab view
        LSTabControl *previous = nil;
        LSTabControl *next = nil;
        if (newSelectedTabIndex-1 >= 0)
            previous = [tabViews objectAtIndex:newSelectedTabIndex-1];
        if (newSelectedTabIndex+1 < tabViews.count)
            next = [tabViews objectAtIndex:newSelectedTabIndex+1];
        
        if (previous)
            [scrollView insertSubview:previous belowSubview:self.selectedTabView];
        if (next)
            [scrollView insertSubview:next belowSubview:self.selectedTabView];
    }
}


- (id)selectedObject {
    id selected = nil;
	if (selectedTabIndex != LSTabBarViewNoItem)
		selected = ((LSTabItem *)[tabItems objectAtIndex:selectedTabIndex]).object;
    
	return selected;
}


- (void)setSelectedObject:(id)object {
    NSUInteger index = [MultiTabItem findIndexOfItemWithObject:object inArray:tabItems];
    if (index != NSNotFound)
        self.selectedTabIndex = index;
}


#pragma mark -

- (LSTabItem *)itemAtIndex:(NSInteger)index {
    return [tabItems objectAtIndex:index];
}


- (void)addItem:(LSTabItem *)item animated:(BOOL)animated {
    [self insertItem:item atIndex:self.numberOfItems animated:animated];
}


- (void)removeAllItemsAnimated:(BOOL)animated {
    [self removeItemsInRange:NSMakeRange(0, self.numberOfItems) animated:animated];
}


- (void)scrollToTopAnimated:(BOOL)animated {
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
}


- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    // This check ensure that the frames of each tabs are defined even if the view is not yet rendered
    if (frames.count == 0)
        [self layoutIfNeeded];
    
    [scrollView scrollRectToVisible:((UIView *)[tabViews objectAtIndex:index]).frame animated:animated];
}


- (void)expandItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    MultiTabItem *item = [tabItems objectAtIndex:index];
    [self insertItems:[self _tabItemsFromLanguage:item.object] startingFromIndex:index+1
             animated:animated];
    item.expanded = YES;
}


#pragma mark -
#pragma mark Protected methods

- (CGSize)layout {
    CGFloat padding = 0.0f;
    CGFloat y = self.margin;
    BOOL    layoutCentered = YES;
    
    if (frames == nil)
        frames = [[NSMutableArray alloc] initWithCapacity:tabViews.count]; 
    

    for (int i = 0; i < tabViews.count; ++i) {
        LSTabControl *tab = [tabViews objectAtIndex:i];
        CGSize tabSize = [tab sizeThatFits:CGSizeZero];

        NSUInteger itemTag = tab.tabItem.idMask;
        layoutCentered = (itemTag & MultiTabItemOptionsType || itemTag & MultiTabItemBackType);
        
        padding = [self paddingForItem:[tabItems objectAtIndex:i] 
                               atIndex:i];
        
        NSValue *value = nil;
        if (layoutCentered) {
            value = [NSValue valueWithCGRect:CGRectMake((self.viewWidth / 2) - (tabSize.width / 2) - 2.0f, y, 
                                                                  tabSize.width, tabSize.height)];
        }
        else {
            value = [NSValue valueWithCGRect:CGRectMake(1.0f, y, tabSize.width, tabSize.height)];
        }
        [frames addObject:value];
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


#pragma mark -
#pragma mark Private methods

/**
 * Returns an array of AMTTabItem as child of language
 */
- (NSArray *)_tabItemsFromLanguage:(NSDictionary *)language {
    NSMutableArray *items = nil;
    NSArray *sublanguages = [ObjectCollection sublanguagesForLanguage:language];
    
    if (sublanguages.count > 0) {
        items = [NSMutableArray arrayWithCapacity:sublanguages.count];
        
        __block MultiTabItem *newItem;
        [sublanguages enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            newItem = [MultiTabItem tabItemWithLanguage:obj];
            newItem.idMask = MultiTabItemInnerLevelType | MultiTabItemLanguageType;
            [items addObject:newItem];
        }];
    }
    
    return items;
}


@end
