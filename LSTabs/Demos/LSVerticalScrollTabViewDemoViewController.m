//
//  LSVerticalScrollTabViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 6/23/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSVerticalScrollTabViewDemoViewController.h"
#import "VerticalScrollTabBarView.h"
#import "MultiTabControl.h"
#import "LSTabItem.h"

// View shortcuts
#import "UIView+Addictions.h"



@interface LSVerticalScrollTabViewDemoViewController () {
    VerticalScrollTabBarView *tabView;
}

@end



@implementation LSVerticalScrollTabViewDemoViewController

@synthesize controlPanelView;
@synthesize selectedTabLabel;
@synthesize addButton;
@synthesize removeButton;
@synthesize tabIndexTextField;
@synthesize quantityTextField;
@synthesize useAnimationsSwitch;



+ (NSString *)viewTitle {
    return @"Vertical Scroll Tab View";
}


#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"LSVerticalScrollTabView" bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = [[self class] viewTitle];
    
    self.borderImageView.image = [UIImage imageNamed:@"scrolltabs_border"];
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
    ((LSTabItem *)tabItems[0]).badgeNumber = 10;
    ((LSTabItem *)tabItems[2]).badgeNumber = 35;
    ((LSTabItem *)tabItems[3]).badgeNumber = 70;
    ((LSTabItem *)tabItems[7]).badgeNumber = 75;
    ((LSTabItem *)tabItems[8]).badgeNumber = 1000;
    ((LSTabItem *)tabItems[13]).badgeNumber = 380;
    
    tabView = [[VerticalScrollTabBarView alloc] initWithItems:tabItems delegate:self];
    tabView.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
    tabView.itemPadding = -50.0f;
    tabView.margin = 0.0f;
    tabView.frame = CGRectMake(0.0f, 0.0f, 76.0f, self.view.bounds.size.height);
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
    return [[[MultiTabControl alloc] initWithItem:item] autorelease];
}


- (void)tabBar:(LSTabBarView *)tabBar 
   tabSelected:(LSTabItem *)item 
       atIndex:(NSInteger)selectedIndex
{
    self.selectedTabLabel.text = [NSString stringWithFormat:@"%@ selected", item.title];
    self.tabIndexTextField.text = [NSString stringWithFormat:@"%d", selectedIndex];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark Actions

- (IBAction)addTab:(id)sender {
    static NSInteger newItemIndex = 1;
    NSInteger quantity = [self.quantityTextField.text integerValue];
    
    if (quantity >= 1)
        ((UIButton *)sender).enabled = NO;
    
    if (quantity == 1) {
        LSTabItem *newItem = [[[LSTabItem alloc] initWithTitle:[NSString stringWithFormat:@"New tab item %d", newItemIndex]] autorelease];
        [tabView insertItem:newItem 
                    atIndex:[self.tabIndexTextField.text integerValue] 
                   animated:self.useAnimationsSwitch.isOn];
        
        newItemIndex++;
    }
    else if (quantity > 1) {
        NSMutableArray *allItems = [NSMutableArray arrayWithCapacity:quantity];
        for (int i=1; i<=quantity; i++) {
            LSTabItem *newItem = [[LSTabItem alloc] initWithTitle:[NSString stringWithFormat:@"New tab item %d", newItemIndex]];
            [allItems addObject:newItem];
            [newItem release];
            newItemIndex++;
        }
        [tabView insertItems:allItems 
           startingFromIndex:[self.tabIndexTextField.text integerValue] 
                    animated:self.useAnimationsSwitch.isOn];
    }
    
    [self performSelector:@selector(_enableButtons) withObject:nil afterDelay:0.4f];
}


- (IBAction)removeTab:(id)sender {
    NSInteger quantity = [self.quantityTextField.text integerValue];
    
    if (quantity >= 1)
        ((UIButton *)sender).enabled = NO;
    
    if (quantity == 1) {
        [tabView removeItemAtIndex:[self.tabIndexTextField.text integerValue] 
                          animated:self.useAnimationsSwitch.isOn];
    }
    else if (quantity > 1) {
        [tabView removeItemsInRange:NSMakeRange([self.tabIndexTextField.text integerValue], quantity) 
                           animated:self.useAnimationsSwitch.isOn];
    }
    
    [self performSelector:@selector(_enableButtons) withObject:nil afterDelay:0.4f];
}


#pragma mark -
#pragma mark Private methods

- (void)_enableButtons {
    self.addButton.enabled = YES;
    self.removeButton.enabled = YES;
}


@end
