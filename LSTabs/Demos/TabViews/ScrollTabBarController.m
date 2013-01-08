//
//  ScrollTabBarController.m
//  LSTabs
//
//  Created by Marco Mussini on 26/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "ScrollTabBarController.h"

#import "TestVerticalScrollTabBarView.h"
#import "MultiTabControl.h"
#import "InnerTabControl.h"
#import "SimpleTabControl.h"
#import "LSMultiTabDemoViewController_Notifications.h"
#import "ObjectCollection.h"

// View shortcuts
#import "UIView+Addictions.h"



@interface ScrollTabBarController() {
	// Ensure that that proper *ScrollTabBarView is always displayed
	// whenever you access to the view property or change the viewState
    BOOL                   _subviewUpdateRequired;
    
    // Pointer to the current language from where construct the subhierarchy
    NSDictionary          *_rootLanguage;
	// Pointers to the parent languages to navigate back inside of the hierarchy
	NSMutableArray        *_languageNavigationStack;
    
    UIView                *_view;
    UIView                *_borderLineView;
    TestVerticalScrollTabBarView   *_languageScrollTabView;
    TestVerticalScrollTabBarView   *_categoryScrollTabView;
}

@property (nonatomic, retain) NSDictionary					 *rootLanguage;

@property (nonatomic, retain) TestVerticalScrollTabBarView *languageScrollTabView;
@property (nonatomic, retain) TestVerticalScrollTabBarView *categoryScrollTabView;

@property (nonatomic, retain) NSMutableArray				 *tabItemsForLanguages;
@property (nonatomic, retain) NSMutableArray				 *tabItemsForCategories;

- (void)_switchInnerViewAnimated:(BOOL)animated;
- (void)_reselectLastTabItemForTabView:(TestVerticalScrollTabBarView *)tabView;

@end



@implementation ScrollTabBarController


@synthesize view = _view;
@synthesize viewState = _viewState;
@synthesize rootLanguage = _rootLanguage;
@synthesize delegate = _delegate;
@synthesize languageScrollTabView = _languageScrollTabView;
@synthesize categoryScrollTabView = _categoryScrollTabView;
@synthesize tabItemsForLanguages = _tabItemsForLanguages;
@synthesize tabItemsForCategories = _tabItemsForCategories;


#pragma mark -
#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        _viewState = ScrollTabBarViewStateUndefined;
        _subviewUpdateRequired = YES;
    }
    
    return self;
}



- (void)dealloc {
    if (self.delegate != nil)
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:LSMultiTabViewDidUnloadNotification
                                                      object:self.delegate];
    
    [_rootLanguage release]; _rootLanguage = nil;
    [_languageNavigationStack release]; _languageNavigationStack = nil;
    [_tabItemsForLanguages release]; _tabItemsForLanguages = nil;
    [_tabItemsForCategories release]; _tabItemsForCategories = nil;
    
    [_view removeObserver:self forKeyPath:@"frame"];
    [_view removeObserver:self forKeyPath:@"hidden"];
    [_view release]; _view = nil;
    
    _languageScrollTabView = nil;  // These are just for safety but not really needed
    _categoryScrollTabView = nil;
    _borderLineView = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors (public)

- (void)setViewState:(ScrollTabBarViewState)newViewState { 
    if (newViewState != _viewState && newViewState != ScrollTabBarViewStateUndefined) {
        _viewState = newViewState;
        
        // If the view is not yet defined do nothing, otherwise add or bring to front its subview
        if (_view != nil)
            [self _switchInnerViewAnimated:NO];
    }
}


- (void)setRootLanguage:(NSDictionary *)newRootLanguage {
    _rootLanguage = [newRootLanguage retain];
    // This array is constructed starting from _rootLanguage, 
    // so it needs to be recreated as well for the new _rootLanguage
    self.tabItemsForLanguages = nil;
    
    // Usually setRootLanguage is called when the view is already defined,
    // but if it is not, then I do not need to remove and add the items since they would be the same;
    // This situation happen in [self setSelectedObject:] when the view is not yet defined
    if (_languageScrollTabView != nil) {
        TestVerticalScrollTabBarView *scrollTabBar = self.languageScrollTabView;
        // Recreate all tab items
        [scrollTabBar removeAllItemsAnimated:NO];
        [scrollTabBar insertItems:self.tabItemsForLanguages startingFromIndex:0 animated:NO];
    }
}


- (UIView *)view {
    if (_view == nil) {
        // Select the appropriate image for the current device
        NSString *viewImageName;
        NSString *borderImageName;
        if ([UIScreen mainScreen].scale == 2.0f && [UIScreen mainScreen].bounds.size.height == 568.0f) {
            viewImageName = @"scrolltabs_background-568h.png";
            borderImageName = @"scrolltabs_border-568h";
        }
        else {  // iPad/iPhone with or without Retina
            viewImageName = @"scrolltabs_background.png";
            borderImageName = @"scrolltabs_border";
        }
        
        // Container view
        _view = [[UIView alloc] initWithFrame:CGRectZero];
        _view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:viewImageName]];
        [_view addObserver:self 
                forKeyPath:@"frame" 
                   options:NSKeyValueObservingOptionNew 
                   context:nil];
        [_view addObserver:self 
                forKeyPath:@"hidden" 
                   options:NSKeyValueObservingOptionNew 
                   context:nil];

        _borderLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:borderImageName]];
        _borderLineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [_view addSubview:_borderLineView];
        [_borderLineView release];
    }
    
    // If the viewState is changed and the subview require an update add or bring to front its subview
	if (_subviewUpdateRequired && self.viewState != ScrollTabBarViewStateUndefined)
        [self _switchInnerViewAnimated:NO];
    
    return _view;
}


- (void)setDelegate:(id<ScrollTabBarControllerDelegate>)delegate {
    // This check ensure that the notification is not attached more than one time if the view is unloaded more than once
    // (see how PlaceBrowserViewController::viewDidLoad works...)
    if (delegate != _delegate) {
        // Attach a notification to know when my parent viewController receive a viewDidUnload
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(parentControllerViewDidUnload) 
                                                     name:LSMultiTabViewDidUnloadNotification
                                                   object:delegate];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(parentControllerViewWillAppear) 
                                                     name:LSMultiTabViewWillAppearNotification
                                                   object:delegate];
    }
    
    _delegate = delegate;
}


#pragma mark -
#pragma mark Accessors (private)

- (TestVerticalScrollTabBarView *)languageScrollTabView {
    if (_languageScrollTabView == nil) {        
        _languageScrollTabView = [[TestVerticalScrollTabBarView alloc] initWithItems:self.tabItemsForLanguages delegate:self];
        _languageScrollTabView.frame = CGRectMake(0.0f, 0.0f, _view.viewWidth, _view.viewHeight);
        _languageScrollTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
                                                  UIViewAutoresizingFlexibleHeight;
        _languageScrollTabView.margin = 15.0f;
        _languageScrollTabView.delegate = self;
        
        [_languageScrollTabView autorelease];
    }
    
    return _languageScrollTabView;
}


- (TestVerticalScrollTabBarView *)categoryScrollTabView {
    if (_categoryScrollTabView == nil) {
        _categoryScrollTabView = [[TestVerticalScrollTabBarView alloc] initWithItems:self.tabItemsForCategories delegate:self];
        _categoryScrollTabView.frame = CGRectMake(0.0f, 0.0f, _view.viewWidth, _view.viewHeight);
        _categoryScrollTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
                                                  UIViewAutoresizingFlexibleHeight;
        _categoryScrollTabView.margin = 15.0f;
        _categoryScrollTabView.delegate = self;

        [_categoryScrollTabView autorelease];
    }
    
    return _categoryScrollTabView;
}


- (NSMutableArray *)tabItemsForLanguages {
    if (_tabItemsForLanguages == nil) {
        BOOL isLevel0 = (self.rootLanguage == nil);
            
        if (_languageNavigationStack == nil)
            _languageNavigationStack = [[NSMutableArray array] retain];
        
        NSArray *sublanguages = [ObjectCollection sublanguagesForLanguage:self.rootLanguage];

        // Include the back button if needed
        NSUInteger additionalItemCount = (isLevel0 == NO  ?  3  :  1);
        
        // Normal additional buttons (when at level 0): expand all 
        // (when at level > 0): expand all, back, all (=root)
        _tabItemsForLanguages = [[NSMutableArray alloc] initWithCapacity:sublanguages.count + additionalItemCount];
        
        LSTabItem *expandItem = [[[LSTabItem alloc] init] autorelease];
        expandItem.idMask = MultiTabItemOptionsType | MultiTabItemLanguageType;
        [_tabItemsForLanguages addObject:expandItem];
        
        if (isLevel0 == NO) {
            LSTabItem *backItem = [[[LSTabItem alloc] init] autorelease];
            backItem.idMask = MultiTabItemBackType | MultiTabItemLanguageType;
            [_tabItemsForLanguages addObject:backItem];
        }
        
        [sublanguages enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
            MultiTabItem *newItem = [MultiTabItem tabItemWithLanguage:obj];
            newItem.idMask = MultiTabItemCurrentLevelType | MultiTabItemLanguageType;
            [_tabItemsForLanguages addObject:newItem];
        }];
    }
    
    return _tabItemsForLanguages;
}


- (NSMutableArray *)tabItemsForCategories {
	if (_tabItemsForCategories == nil) {
		NSArray *categories = [ObjectCollection sharedInstance].categories;
        
		_tabItemsForCategories = [[NSMutableArray alloc] initWithCapacity:categories.count + 1]; // +1 for Expand all button
		
		LSTabItem *expandItem = [[[LSTabItem alloc] init] autorelease];
		expandItem.idMask = MultiTabItemOptionsType | MultiTabItemCategoryType;
		[_tabItemsForCategories addObject:expandItem];
		
		[categories enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
			LSTabItem *newItem = [MultiTabItem tabItemWithLanguage:obj];
            newItem.idMask = MultiTabItemCurrentLevelType | MultiTabItemCategoryType;
			[_tabItemsForCategories addObject:newItem];
		}];
	}
	
	return _tabItemsForCategories;
}


#pragma mark -
#pragma mark Public

- (void)setRootLanguage:(NSDictionary *)language animated:(BOOL)animated {
    CGRect initialFrame = self.languageScrollTabView.frame; 
    
    // Temporary brings the border line view to front so that 
    // the currently selected tab tail is not visible during the shifting
    [self.view bringSubviewToFront:_borderLineView];
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect finalFrame = initialFrame;
                         finalFrame.origin.x += finalFrame.size.width;
                         self.languageScrollTabView.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         self.rootLanguage = language;
                         [UIView animateWithDuration:0.35f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseOut    
                                          animations:^{
                                              self.languageScrollTabView.frame = initialFrame;
                                          }
                                          completion:^(BOOL finished) {
                                              // Send the border line view to its original priority
                                              [self.view sendSubviewToBack:_borderLineView];
                                              [self.languageScrollTabView scrollToTopAnimated:YES];
                                          }];
                     }];
}


- (LSTabItem *)selectedTabItem {
    LSTabItem *selected = nil;
    if (self.viewState == ScrollTabBarViewStateLanguages)
		selected = [self.languageScrollTabView selectedTabItem];
	else
		selected = [self.categoryScrollTabView selectedTabItem];
	
	return selected;
}


- (void)setViewState:(ScrollTabBarViewState)newViewState animated:(BOOL)animated {
    if (animated) {
        _viewState = newViewState;
        [self _switchInnerViewAnimated:YES];
    }
    else    // No animation required
        self.viewState = newViewState;
}


#pragma mark -
#pragma mark Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.view) {
        if ([keyPath isEqualToString:@"frame"]) {
            // Update the border line view position.
            // This is the only way to know when the _view frame is set; when this notification is called the border view
            // is positioned to its right corner. The notification is called just one time because the bounds will not
            // change during its life
            CGRect borderViewFrame = _borderLineView.frame;
            borderViewFrame.origin.x = self.view.frame.size.width - _borderLineView.bounds.size.width;
            borderViewFrame.origin.y = 0.0f;
            _borderLineView.frame = borderViewFrame;
        }
    }
}


- (void)parentControllerViewWillAppear {
    // Do something usefull! This method is similar to a viewWillAppear for a UIViewController...
}


- (void)parentControllerViewDidUnload {
    [_view removeObserver:self forKeyPath:@"frame"];
    [_view removeObserver:self forKeyPath:@"hidden"];
    [_view release];    // its subviews are released as conseguence
    _view = nil;
	self.tabItemsForLanguages = nil;
	self.tabItemsForCategories = nil;
    _languageScrollTabView = nil;
    _categoryScrollTabView = nil;
    _borderLineView = nil;
    _viewState = ScrollTabBarViewStateUndefined;
    _subviewUpdateRequired = YES;
}


#pragma mark -
#pragma mark LSTabBarViewDelegate Methods

- (LSTabControl *)tabBar:(LSTabBarView *)tabBar 
          tabViewForItem:(LSTabItem *)item 
                 atIndex:(NSInteger)index 
{
    LSTabControl *tabView = nil;
    
    if (item.idMask & MultiTabItemCurrentLevelType) {
        if (item.idMask & MultiTabItemLanguageType)
            tabView = [[[MultiTabControl alloc] initWithItem:item] autorelease];
        else {  // Category
            UIColor *color = [((NSDictionary *)item.object) objectForKey:ObjectCollectionColorKey];
            tabView = [[[MultiTabControl alloc] initWithItem:item tintColor:color] autorelease];
        }
    }
    
    else if (item.idMask & MultiTabItemInnerLevelType) {  // Only for languages (nested levels)
        UIColor *color = [UIColor colorWithWhite:0.2 alpha:0.4f];
        tabView = [[[InnerTabControl alloc] initWithItem:item tintColor:color] autorelease];
    }
    
    else if (item.idMask & MultiTabItemOptionsType || item.idMask & MultiTabItemBackType) {
        tabView = [[[SimpleTabControl alloc] initWithItem:item] autorelease];
        
        NSString *imageName = nil;
        if (item.idMask & MultiTabItemOptionsType)
            imageName = @"tab-options.png";
        else
            imageName = @"tab-back.png";
        
        [tabView setImage:[UIImage imageNamed:imageName] 
                 forState:UIControlStateNormal];
    }
    
    return tabView;
}


- (CGFloat)tabBar:(LSTabBarView *)tabBar paddingForItem:(LSTabItem *)item atIndex:(NSInteger)index {
    CGFloat padding = tabBar.itemPadding;
    
    if (item.idMask & MultiTabItemOptionsType)
        padding = 15.0f;
    else if (item.idMask & MultiTabItemBackType)
        padding = 8.0f;
	else if (index == tabBar.numberOfItems-2) {     // Space after "All" item and penultimate item
		if (item.idMask & MultiTabItemLanguageType && self.rootLanguage == nil) { // I'm in the first level
            padding = -20.0f;
		}
	}
	
    return padding;
}


- (void)tabBar:(TestVerticalScrollTabBarView *)tabBar 
   tabSelected:(LSTabItem *)item 
       atIndex:(NSInteger)selectedIndex 
{
    // Expand all button selected
    if (item.idMask & MultiTabItemOptionsType) {
        if ([self.delegate respondsToSelector:@selector(tabBarController:accessoryButtonSelected:tabItem:atIndex:)])
            [self.delegate tabBarController:self 
                    accessoryButtonSelected:MultiTabItemOptionsType 
                                    tabItem:item 
                                    atIndex:selectedIndex];
        return;
    }
    // Back button selected (only for languages)
    else if (item.idMask & MultiTabItemBackType) {
        id parentLanguage = [_languageNavigationStack lastObject];
        [_languageNavigationStack removeLastObject];
        
        [self setRootLanguage:(parentLanguage == [NSNull null] ? nil : parentLanguage) animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(tabBarController:accessoryButtonSelected:tabItem:atIndex:)])
            [self.delegate tabBarController:self 
                    accessoryButtonSelected:MultiTabItemBackType 
                                    tabItem:item 
                                    atIndex:selectedIndex];
        return;
    }
    
    if (self.viewState == ScrollTabBarViewStateLanguages) {
        BOOL itemWasSelectedTwice = (selectedIndex == tabBar.lastSelectedTabIndex);
        
        // A language at the current level was selected
        if ( (item.idMask & MultiTabItemInnerLevelType) != MultiTabItemInnerLevelType) {
            if (itemWasSelectedTwice == NO) {
                if ([((MultiTabItem *)item) isExpanded] == NO)
                    [tabBar expandItemAtIndex:selectedIndex animated:YES];
                
                if ([self.delegate respondsToSelector:@selector(tabBarController:tabSelected:atIndex:)])
                    [self.delegate tabBarController:self 
                                        tabSelected:item 
                                            atIndex:selectedIndex];
            }
        }
        // A sublanguage was selected
        else if (itemWasSelectedTwice == NO) {
            if ([self.delegate respondsToSelector:@selector(tabBarController:tabSelected:atIndex:)])
                [self.delegate tabBarController:self 
                                    tabSelected:item 
                                        atIndex:selectedIndex];
        }
        
        // The same language or sublanguage was selected twice, 
		// now it is going to become the new root language
        if (itemWasSelectedTwice == YES) {
            NSDictionary *selectedLanguage = ((NSDictionary *)item.object);
            if ([[selectedLanguage objectForKey:ObjectCollectionChildrenKey] count] == 0) {
                // Signal that there are no other inner levels to display
                [(MultiTabControl *)tabBar.selectedTabView flashMe];
                if ([self.delegate respondsToSelector:@selector(tabBarController:mostNestedLevelReachedForTabItem:)])
                    [self.delegate tabBarController:self mostNestedLevelReachedForTabItem:item];
            }
            else {
                // Save the pointer to the current root language, so I will be able to navigate back in the history
                id currentLanguage;
                if (self.rootLanguage == nil)
                    currentLanguage = [NSNull null];
                else
                    currentLanguage = self.rootLanguage;
                
                [_languageNavigationStack addObject:currentLanguage];
                
                [self setRootLanguage:(NSDictionary *)item.object animated:YES];
                if ([self.delegate respondsToSelector:@selector(tabBarController:tabSelected:atIndex:)])
                    [self.delegate tabBarController:self 
                                        tabSelected:item 
                                            atIndex:selectedIndex];
            }
        }        
    }
    else { // ScrollTabBarViewStateCategories
        if ([self.delegate respondsToSelector:@selector(tabBarController:tabSelected:atIndex:)])
            [self.delegate tabBarController:self 
                                tabSelected:item 
                                    atIndex:selectedIndex];
    }
}


#pragma mark -
#pragma mark Private methods

- (void)_switchInnerViewAnimated:(BOOL)animated {
    TestVerticalScrollTabBarView *viewToDisplay = nil;

    // Get the new view to display
    if (self.viewState == ScrollTabBarViewStateLanguages) {
        viewToDisplay = self.languageScrollTabView;
        if (animated == NO && _categoryScrollTabView != nil)
            _categoryScrollTabView.hidden = YES;
    }
    else if (self.viewState == ScrollTabBarViewStateCategories) {
        viewToDisplay = self.categoryScrollTabView;
        if (animated == NO && _languageScrollTabView != nil)
            _languageScrollTabView.hidden = YES;
    }
    
    if (animated)
        viewToDisplay.alpha = 0.0f;
    
    viewToDisplay.hidden = NO;
    
    // Display the new view
    if ([_view.subviews containsObject:viewToDisplay] == NO)
        [_view addSubview:viewToDisplay];
    else 
        [_view bringSubviewToFront:viewToDisplay];
    
    if (animated) {
        [UIView animateWithDuration:0.25f 
             animations:^{        
                 viewToDisplay.alpha = 1.0f;
                 
                 if (self.viewState == ScrollTabBarViewStateLanguages) {
                     if (_categoryScrollTabView != nil)
                         _categoryScrollTabView.alpha = 0.0f;
                 }
                 else if (self.viewState == ScrollTabBarViewStateCategories) {
                     if (_languageScrollTabView != nil)
                         _languageScrollTabView.alpha = 0.0f;
                 }
             } 
             completion:^(BOOL finished) {
                 // Normally the border line view is always on back, it is going to become to front only during tabs transitions
                 [_view sendSubviewToBack:_borderLineView];
                 
                 _subviewUpdateRequired = NO;
                 
                 if (self.viewState == ScrollTabBarViewStateLanguages) {
                     if (_categoryScrollTabView != nil)
                         _categoryScrollTabView.hidden = YES;
                 }
                 else if (self.viewState == ScrollTabBarViewStateCategories) {
                     if (_languageScrollTabView != nil)
                         _languageScrollTabView.hidden = YES;
                 }
                 
                 [viewToDisplay setNeedsDisplay];
                 
                 [self _reselectLastTabItemForTabView:viewToDisplay];
             }];
    }
    
    // No animation required
    else {
        // Normally the border line view is always on back, it is going to become to front only during tabs transitions
        [_view sendSubviewToBack:_borderLineView];
        _subviewUpdateRequired = NO;
        viewToDisplay.alpha = 1.0f; // Important! if the previous view switch used animation but this switch not!
        [viewToDisplay setNeedsDisplay];
        [self _reselectLastTabItemForTabView:viewToDisplay];
    }
}


/**
 * Notify the delegate that it needs to refetch the items list.
 * This method is called each time a tabView is switched with the other
 */
- (void)_reselectLastTabItemForTabView:(TestVerticalScrollTabBarView *)tabView {
    NSInteger selIndex = tabView.selectedTabIndex;
    if (selIndex != LSTabBarViewNoItem) {
        [self.delegate tabBarController:self 
                            tabSelected:[tabView itemAtIndex:selIndex]
                                atIndex:selIndex];
    }
}


@end
