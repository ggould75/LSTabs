//
//  LSTabBarView.m
//  LSTabs
//
//  Created by ludwig on 1/5/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabBarView.h"
#import "LSTabControl.h"
#import "LSTabBarView_Protected.h"

#import <malloc/malloc.h>

// View shortcuts
#import "UIView+Addictions.h"




@interface LSTabBarView ()

- (LSTabControl *)_createTabControlForItem:(LSTabItem *)item 
                                   atIndex:(NSUInteger)index;

- (void)_insertItems:(NSArray *)items startingFromIndex:(NSUInteger)startIndex animated:(BOOL)animated;

- (void)_removeItemsInRange:(NSRange)range animated:(BOOL)animated;

@end



@implementation LSTabBarView


@synthesize selectedTabIndex;
@synthesize delegate = _delegate;
@synthesize margin;
@synthesize itemPadding;


- (id)initWithFrame:(CGRect)frame {
    return [self initWithItems:nil];
}


- (id)initWithItems:(NSArray *)items {
    return [self initWithItems:items delegate:nil];
}


- (id)initWithItems:(NSArray *)items delegate:(id <LSTabBarViewDelegate>)aDelegate {
    self = [super initWithFrame:CGRectZero];
	if (self) {
        self.contentMode = UIViewContentModeLeft;
        
        _delegate = aDelegate;
        
        // Default margin and padding. 
        // Override these values subclassing or using the accessors methos
        margin = 0.0f;
        itemPadding = 5.0f;
        
        contentSizeCached = NO;
        frames = nil;
        
		selectedTabIndex = LSTabBarViewNoItem;
		tabViews = [[NSMutableArray alloc] init];
        tabItems = [items mutableCopy];
        
        for (int i = 0; i < tabItems.count; ++i) {
            LSTabItem *tabItem = [tabItems objectAtIndex:i];
            LSTabControl *tabControl = [self _createTabControlForItem:tabItem atIndex:i];
            [self addTab:tabControl];
            [tabViews addObject:tabControl];
        }
	}
	
	return self;
}


- (void)dealloc {
    [tabItems release]; tabItems = nil;
    [tabViews release]; tabViews = nil;
    [frames release]; frames = nil;
	delegate = nil;
    
	[super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (LSTabItem *)selectedTabItem {
    LSTabItem *selected = nil;
	if (selectedTabIndex != LSTabBarViewNoItem) {
		selected = [tabItems objectAtIndex:selectedTabIndex];
	}
    
	return selected;
}


- (void)setSelectedTabItem:(LSTabItem *)tabItem {
    NSUInteger index = [tabItems indexOfObject:tabItem];
    if (index != NSNotFound)
        self.selectedTabIndex = index;
}


- (LSTabControl *)selectedTabView {
    LSTabControl *selected = nil;
	if (selectedTabIndex != LSTabBarViewNoItem && selectedTabIndex < tabViews.count) {
		selected = [tabViews objectAtIndex:selectedTabIndex];
	}
    
	return selected;
}


- (void)setSelectedTabView:(LSTabControl *)tab {
    NSUInteger index = [tabViews indexOfObject:tab];
    if (index != NSNotFound)
        self.selectedTabIndex = index;
}


- (void)setSelectedTabIndex:(NSInteger)newSelectedTabIndex {
	if (newSelectedTabIndex != selectedTabIndex) {
        self.selectedTabView.selected = NO;
		
		selectedTabIndex = newSelectedTabIndex;
		
		if (selectedTabIndex != LSTabBarViewNoItem) {
            self.selectedTabView.selected = YES;
		}
		
        // Note that setting this property to -1 (LSTabBarViewNoItem) does not notify 
        // the delegate about the change
		if ([self.delegate respondsToSelector:@selector(tabBar:tabSelected:atIndex:)] && 
            selectedTabIndex != LSTabBarViewNoItem) 
        {
			[self.delegate tabBar:self 
                      tabSelected:self.selectedTabItem 
                          atIndex:selectedTabIndex];
		}
	}
}


- (NSUInteger)numberOfItems {
    return tabItems.count;
}


- (void)setMargin:(CGFloat)newMargin {
    if (newMargin != margin) {
        margin = newMargin;
        [self invalidateLayout];
        [self setNeedsLayout];
    }
}


- (void)setItemPadding:(CGFloat)newItemPadding {
    if (newItemPadding != itemPadding) {
        itemPadding = newItemPadding;
        [self invalidateLayout];
        [self setNeedsLayout];
    }
}


#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
	[super layoutSubviews];
    [self layoutTabsIfNeeded];
}


#pragma mark -
#pragma mark Public

- (void)showTabAtIndex:(NSInteger)tabIndex {
	LSTabControl *tab = [tabViews objectAtIndex:tabIndex];
	tab.hidden = NO;
}


- (void)hideTabAtIndex:(NSInteger)tabIndex {
	LSTabControl *tab = [tabViews objectAtIndex:tabIndex];
	tab.hidden = YES;
}


- (void)insertItem:(LSTabItem *)item 
           atIndex:(NSUInteger)index 
          animated:(BOOL)animated 
{
    [self _insertItems:[NSArray arrayWithObject:item] startingFromIndex:index animated:animated];
}


- (void)insertItems:(NSArray *)items startingFromIndex:(NSUInteger)index 
           animated:(BOOL)animated 
{
    if (items.count > 0)
        [self _insertItems:items startingFromIndex:index animated:animated];
}


- (void)removeItemAtIndex:(NSUInteger)index 
                 animated:(BOOL)animated 
{
    [self _removeItemsInRange:NSMakeRange(index, 1) animated:animated];
}


- (void)removeItemsInRange:(NSRange)range 
                  animated:(BOOL)animated 
{
    [self _removeItemsInRange:range animated:animated];
}


#pragma mark -
#pragma mark Protected methods

- (void)addTab:(LSTabControl *)tab {
	[self addSubview:tab];
}


- (void)removeTab:(LSTabControl *)tab {
    [tab removeFromSuperview];
}


- (LSTabControl *)tabViewForItem:(LSTabItem *)item atIndex:(NSInteger)index {
    // Default tab control used if the delegate does not implement tabBar:tabViewForItem:atIndex:
    LSTabControl *tabView = [[[LSTabControl alloc] initWithItem:item] autorelease];
    
    return tabView;
}


- (CGFloat)paddingForItem:(LSTabItem *)item atIndex:(NSInteger)index {
    CGFloat padding = self.itemPadding;
    if ([self.delegate respondsToSelector:@selector(tabBar:paddingForItem:atIndex:)])
        padding = [self.delegate tabBar:self 
                         paddingForItem:item 
                                atIndex:index];
    
    return padding;
}


- (CGSize)layoutTabsIfNeeded {
    CGSize size = contentSize;
    
    if ([self layoutIsValid] == NO) {        
        [self layout];
        size = contentSize;
        [tabViews enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            NSValue *val = (NSValue *)[frames objectAtIndex:index];
            ((UIView *)obj).frame = [val CGRectValue];
            [((UIView *)obj) setNeedsLayout];
        }];
    }
    
    return size;
}


// @TODO: reimplement contentMode UIViewContentModeScaleToFill. It does not work!
- (CGSize)layout {
    CGFloat x = self.margin;
    
    if (frames == nil)
        frames = [[NSMutableArray alloc] initWithCapacity:tabViews.count]; 
    
    if (self.contentMode == UIViewContentModeScaleToFill) {
		CGFloat maxTextWidth = self.viewWidth - (self.margin*2 + self.itemPadding*2*tabViews.count);
		CGFloat totalTextWidth = 0;
		CGFloat totalTabWidth = self.margin*2;
		CGFloat maxTabWidth = 0;
		for (int i = 0; i < tabViews.count; ++i) {
			LSTabControl *tab = [tabViews objectAtIndex:i];
			[tab sizeToFit];
			totalTextWidth += tab.viewWidth - self.itemPadding*2;
			totalTabWidth += tab.viewWidth;
			if (tab.viewWidth > maxTabWidth) {
				maxTabWidth = tab.viewWidth;
			}
		}
		
		if (totalTextWidth > maxTextWidth) {
			CGFloat shrinkFactor = maxTextWidth/totalTextWidth;
			for (int i = 0; i < tabViews.count; ++i) {
				LSTabControl *tab = [tabViews objectAtIndex:i];
				CGFloat textWidth = tab.viewWidth - self.itemPadding*2;
				tab.frame = CGRectMake(x, 0, ceil(textWidth * shrinkFactor) + self.itemPadding*2, self.viewHeight);
                [frames addObject:[NSValue valueWithCGRect:tab.frame]];
				x += tab.viewWidth;
			}
		} else {
			CGFloat averageTabWidth = ceil((self.viewWidth - self.margin*2)/tabViews.count);
			if (maxTabWidth > averageTabWidth && self.viewWidth - totalTabWidth < self.margin) {
				for (int i = 0; i < tabViews.count; ++i) {
					LSTabControl *tab = [tabViews objectAtIndex:i];
					tab.frame = CGRectMake(x, 0, tab.viewWidth, self.viewHeight);
                    [frames addObject:[NSValue valueWithCGRect:tab.frame]];
					x += tab.viewWidth;
				}
			} else {
				for (int i = 0; i < tabViews.count; ++i) {
					LSTabControl *tab = [tabViews objectAtIndex:i];
					tab.frame = CGRectMake(x, 0, averageTabWidth, self.viewHeight);
                    [frames addObject:[NSValue valueWithCGRect:tab.frame]];
					x += tab.viewWidth;
				}
			}
		}
	} else {   
        for (int i = 0; i < tabViews.count; ++i) {
            LSTabControl *tab = [tabViews objectAtIndex:i];
            CGSize tabSize = [tab sizeThatFits:CGSizeZero];
            [frames addObject:[NSValue valueWithCGRect:CGRectMake(x, 0, tabSize.width, self.viewHeight)]];
            CGFloat padding = [self paddingForItem:[tabItems objectAtIndex:i] 
                                           atIndex:i];
            x += padding + tabSize.width;
        }
    }	
    
    contentSize = CGSizeMake(x, self.viewHeight);
    contentSizeCached = YES;
    
    return contentSize;
}


- (void)invalidateLayout {
    contentSizeCached = NO;
    if (frames != nil)
        [frames removeAllObjects];
}


- (BOOL)layoutIsValid {
    return contentSizeCached;
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
			 // so that the will appear from top to bottom
			 [tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
				 LSTabControl *tab = (LSTabControl *)obj;
				 index += startIndex;
				 
				 tab.alpha = 0.0f;
				 
				 NSValue *val = (NSValue *)[frames objectAtIndex:index];
				 CGRect tabFinalFrame = [val CGRectValue];
				 CGRect tabInitialFrame = tabFinalFrame;
				 tabInitialFrame.origin.y = -tabFinalFrame.size.height - 5.0f;
				 tab.frame = tabInitialFrame;
				 
				 [self addTab:tab];   // Will call layoutSubviews but it won't do nothing 
									  // because the layout is already done
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
                 tabFinalFrame.origin.y = -tabInitialFrame.size.height - 5.0f;
                 tab.frame = tabFinalFrame;
             }];
         }

         completion:^(BOOL finished) {
             // Makes all the tabs transparent and change their initial frames
             // so that the will appear from bottom to top
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


- (void)updateTabsInRange:(NSRange)range {
    for (NSUInteger index=range.location;  index<range.location + range.length;  index++) {
        NSValue *val = (NSValue *)[frames objectAtIndex:index];
        LSTabControl *tab = [tabViews objectAtIndex:index];
        tab.frame = [val CGRectValue];
    }
}


#pragma mark -
#pragma mark Private methods

- (void)_tabTouchedUpInside:(LSTabControl *)tab {
	self.selectedTabView = tab;
}


- (void)_tabTouchedDown:(LSTabControl *)tab {
	if ([self.delegate respondsToSelector:@selector(tabBar:tabHighlighted:atIndex:)]) {
        NSUInteger index = [tabViews indexOfObject:tab];
        LSTabItem *tabItem = [tabItems objectAtIndex:index];
        [self.delegate tabBar:self 
               tabHighlighted:tabItem 
                      atIndex:index];
    }
}


- (LSTabControl *)_createTabControlForItem:(LSTabItem *)item 
                                   atIndex:(NSUInteger)index 
{
    LSTabControl *tabControl = nil;
    
    // Check if the view is provided by the delegate.
    // Note that this will work only if the delegate is assigned with the initializer initWithItems:delegate:
    if ([self.delegate respondsToSelector:@selector(tabBar:tabViewForItem:atIndex:)])
        tabControl = [self.delegate tabBar:self tabViewForItem:item atIndex:index];
    else
    // The view is provided by the subclass itself
        tabControl = [self tabViewForItem:item atIndex:index];
    
    [tabControl addTarget:self action:@selector(_tabTouchedUpInside:)
         forControlEvents:UIControlEventTouchUpInside];
    [tabControl addTarget:self action:@selector(_tabTouchedDown:) 
         forControlEvents:UIControlEventTouchDown];
    
    return tabControl;
}


- (void)_insertItems:(NSArray *)items startingFromIndex:(NSUInteger)startIndex 
            animated:(BOOL)animated 
{
    // Pin the index value to the maximum
    if (startIndex > self.numberOfItems) {
        startIndex = self.numberOfItems;
        NSLog(@"Warning: LSTabBarView::insertItem index exceed max value! It is pinned to the max.");
    }
    
    // This is both a performance improvement (since the animation is not required if the view is not
    // yet attached to a superview) and solve a problem if animated is YES when there's not superview
    // (the problem is that the new tabs are added as expected but all the tabs above the startIndex 
    // are not visible)
    if (self.superview == nil)
        animated = NO;
    
    // If the new item has the same index or lower index than the currently selected item,
    // increase the selectedTabIndex.
    // Note that this change does not notify the delegate because the actual selected tab does not change
    if ((NSInteger)startIndex <= self.selectedTabIndex)
        selectedTabIndex += items.count;
        
    [self invalidateLayout];     // Force the layout to be recalculated when required
    
    // Creates the new tab objects from the items
    __block NSMutableArray *newTabs = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        index += startIndex;
        LSTabControl *tabControl = [self _createTabControlForItem:(LSTabItem *)obj atIndex:index];
        [tabItems insertObject:(LSTabItem *)obj atIndex:index];
        [tabViews insertObject:tabControl atIndex:index];
        [newTabs addObject:tabControl];
    }];
    
    if (animated == NO) {
        [newTabs enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            [self addTab:obj];   // Will call layoutSubviews
        }];
    }
    else {
        [self layout];
        [self animateNewTabs:newTabs atIndex:startIndex];
    }
}


- (void)_removeItemsInRange:(NSRange)range 
                   animated:(BOOL)animated 
{
    NSUInteger startIndex = range.location;
	
    // Pin the index value to the maximum
    if (startIndex > self.numberOfItems - 1) {
        startIndex = self.numberOfItems - 1;
        NSLog(@"Warning: LSTabBarView::_removeItemsInRange index exceed max value! It is pinned to the max.");
    }
    
    // See comment on _insertItems...
    if (self.superview == nil)
        animated = NO;
    
    // Check if the specified range exceed the last index available, if yes shrink the range
    NSInteger gap = self.numberOfItems - NSMaxRange(range);
    if (gap < 0)
        range = NSMakeRange(startIndex, range.length + gap);
    
    if (NSEqualRanges(range, NSMakeRange(0, 0)) == YES)
        return;
    
    // If the item to be removed is currently selected, deselect it
    if (NSLocationInRange(self.selectedTabIndex, range) == YES)
        self.selectedTabIndex = LSTabBarViewNoItem;
    // The item to be removed has index lower than the currently selected tab.
    // Note that this change does not notify the delegate because the actual selected tab does not change
    else if (self.selectedTabIndex != LSTabBarViewNoItem && startIndex < self.selectedTabIndex)
        selectedTabIndex -= range.length;
    
    [self invalidateLayout];     // Force the layout to be recalculated when required
    
    // Get the tabs objects to remove
    NSMutableArray *tabsToRemove = [NSMutableArray arrayWithCapacity:range.length];
    for (NSUInteger index=range.location, x=0; index<NSMaxRange(range); index++, x++) {
        NSUInteger actualIndex = index-x;
        LSTabControl *tab = [tabViews objectAtIndex:actualIndex];
		[tabsToRemove addObject:tab];
		[tabViews removeObjectAtIndex:actualIndex];
		[tabItems removeObjectAtIndex:actualIndex];
    }
    
    if (animated == NO) {
        [tabsToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            [self removeTab:obj];         // Will call layoutSubviews
        }];
        [tabsToRemove removeAllObjects];  // Will release all tabs
    }
    else {
        [self layout];
        [self animateRemoveTabs:tabsToRemove atIndex:startIndex];
    }
}


@end
