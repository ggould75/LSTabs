//
//  LSTabControlsDemoViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabControlsDemoViewController.h"
#import "LSTabControl.h"
#import "TintedTabControl.h"
#import "TintedVerticalTabControl.h"
#import "HorizontalTabControl.h"



@implementation LSTabControlsDemoViewController


+ (NSString *)viewTitle {
    return @"Tab Controls";
}


#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"LSTabControlsView" bundle:nil];
    if (self) {
        
    }
    
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationItem.title = [LSTabControlsDemoViewController viewTitle];
    
    LSTabItem *tabItem;
    LSTabControl *tabControl;
    
    // Creates a simple tab control. The encapsulated button is a standard UIButton
    tabItem = [[[LSTabItem alloc] initWithTitle:@"Simple tab"] autorelease];
    tabItem.badgeNumber = 100;
    // A tab control based on a standard UIButton
    tabControl = [[LSTabControl alloc] initWithItem:tabItem];
    tabControl.frame = CGRectMake(8.0f, 34.0f, 110.0f, 44.0f);
    [self.view addSubview:tabControl];
    [tabControl release];
    
    // Creates a new tinted tab control. The encapsulated button is a LSTintedButton
    tabItem = [[[LSTabItem alloc] initWithTitle:@"Tinted tab"] autorelease];
    tabItem.badgeNumber = 5000;
    tabControl = [[TintedTabControl alloc] initWithItem:tabItem 
                                              tintColor:[UIColor colorWithRed:0.0f green:0.2f blue:0.6f alpha:0.6f]];
    tabControl.frame = CGRectMake(8.0f, 125.0f, 110.0f, 44.0f);
    [self.view addSubview:tabControl];
    [tabControl release];
    
    // Creates a new tinted tab control (suitable for vertical layout)
    // The encapsulated button is a LSTintedButton configured with 2 different tintColor for normal/highlighted and selected/selected-highlighted states.
    tabItem = [[[LSTabItem alloc] initWithTitle:@"Vertical tab"] autorelease];
    tabItem.badgeNumber = 75;
    tabControl = [[TintedVerticalTabControl alloc] initWithItem:tabItem
                                                      tintColor:[UIColor colorWithRed:0.4f green:0.8f blue:0.3f alpha:0.6f]];
    [tabControl addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
    tabControl.frame = CGRectMake(8.0f, 180.0f, 0.0f, 0.0f);
    [tabControl sizeToFit];
    [self.view addSubview:tabControl];
    [tabControl release];
    
    
    // Creates a new tab control (suitable for horizontal layout)
    tabItem = [[[LSTabItem alloc] initWithTitle:@"Horizontal tab"] autorelease];
    tabItem.badgeNumber = 75;
    tabControl = [[HorizontalTabControl alloc] initWithItem:tabItem];
    tabControl.frame = CGRectMake(-10.0f, 330.0f, 0.0f, 0.0f);
    [tabControl sizeToFit];
    [self.view addSubview:tabControl];
    [tabControl release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Actions

- (void)tabSelected:(LSTabControl *)tab {
	tab.selected = !tab.isSelected;
    tab.tabItem.badgeNumber++;
}


@end
