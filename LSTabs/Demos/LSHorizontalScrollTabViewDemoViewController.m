//
//  LSHorizontalScrollTabViewDemoViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSHorizontalScrollTabViewDemoViewController.h"
#import "LSScrollTabBarView.h"
#import "HorizontalTabControl.h"
#import "LSTabItem.h"



@interface LSHorizontalScrollTabViewDemoViewController () {
    LSScrollTabBarView *tabView;
}

@end


@implementation LSHorizontalScrollTabViewDemoViewController


+ (NSString *)viewTitle {
    return @"Horizontal Scroll Tab View";
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"LSHorizontalScrollTabView" bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = [[self class] viewTitle];
    
    self.borderImageView.image = [UIImage imageNamed:@"scrolltabs_horizontal_border"];
    self.controlPanelView.image = [UIImage imageNamed:@"controlpanel_view_background"];
    
    NSArray *tabItems = @[ [[[LSTabItem alloc] initWithTitle:@"Apple"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Apricot"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Avocado"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Banana"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Blackberry"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Cherry"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Canistel"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Coconut"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Coffee"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Grape"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Mango"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Orange"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Papaya"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Passion fruit"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Pear"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Pineapple"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Melon"] autorelease],
                           [[[LSTabItem alloc] initWithTitle:@"Watermelon"] autorelease] ];
    
    // Assigns some badge number
    ((LSTabItem *)tabItems[1]).badgeNumber = 5;
    ((LSTabItem *)tabItems[2]).badgeNumber = 20;
    ((LSTabItem *)tabItems[4]).badgeNumber = 1000;
    ((LSTabItem *)tabItems[6]).badgeNumber = 32;
    ((LSTabItem *)tabItems[9]).badgeNumber = 64;
    ((LSTabItem *)tabItems[13]).badgeNumber = 7;
    
    tabView = [[LSScrollTabBarView alloc] initWithItems:tabItems delegate:self];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tabView.itemPadding = -36.0f;
    tabView.margin = 0.0f;
    tabView.frame = CGRectMake(0.0f, 12.0f, self.view.bounds.size.width, 42.0f);
    [self.view addSubview:tabView];
    [tabView release];
    
    [self.view bringSubviewToFront:self.controlPanelView];
    [self.view bringSubviewToFront:self.borderImageView];
    [self.view bringSubviewToFront:tabView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark LSTabBarViewDelegate Methods

- (LSTabControl *)tabBar:(LSTabBarView *)tabBar
          tabViewForItem:(LSTabItem *)item
                 atIndex:(NSInteger)index
{
    return [[[HorizontalTabControl alloc] initWithItem:item] autorelease];
}


- (void)tabBar:(LSTabBarView *)tabBar
   tabSelected:(LSTabItem *)item
       atIndex:(NSInteger)selectedIndex
{
    self.selectedTabLabel.text = [NSString stringWithFormat:@"%@ selected", item.title];
}


@end
