//
//  LSMultiTabDemoViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSMultiTabDemoViewController.h"
#import "LSMultiTabDemoViewController_Notifications.h"


@interface LSMultiTabDemoViewController () {
    ScrollTabBarController *_tabBarController;
    LSTabItem              *_lastSelectedTabItem;
}

@property (nonatomic, retain) ScrollTabBarController *tabBarController;
@property (nonatomic, retain) LSTabItem              *lastSelectedTabItem;

@end



@implementation LSMultiTabDemoViewController


const NSInteger PlaceBrowserTabBarViewTag = 123;

@synthesize controlPanelView;
@synthesize tabBarController = _tabBarController;
@synthesize lastSelectedTabItem = _lastSelectedTabItem;
@synthesize selectedTabLabel;
@synthesize innerLevelsLabel;
@synthesize instr1Label;
@synthesize instr2Label;



+ (NSString *)viewTitle {
    return @"Multi Scroll Tab View";
}


#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _lastSelectedTabItem = nil;
    }
    
    return self;
}


- (void)dealloc {
    [_tabBarController release];
    [_lastSelectedTabItem release];
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors (private)

- (ScrollTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        // Create the tab view
        _tabBarController = [[ScrollTabBarController alloc] init];
        _tabBarController.view.tag = PlaceBrowserTabBarViewTag;
        _tabBarController.delegate = self;
    }
    
    // Setup initial frame if not yet done 
    // (usually at the first reference of this accessor and when viewDidUnload occur)
    if (CGRectIsEmpty(_tabBarController.view.frame)) {
        CGRect screenBounds = [[UIScreen mainScreen] applicationFrame];
        CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
        CGFloat x = 0.0f;
        CGFloat width = 76.0f;
        
        _tabBarController.view.frame = CGRectMake(x, 0.0f, width, screenBounds.size.height - navigationBarFrame.size.height);
    }
    
    return _tabBarController;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = [[self class] viewTitle];
    
    [self.view addSubview:self.tabBarController.view];
    [self.view sendSubviewToBack:self.tabBarController.view];
    
    self.tabBarController.viewState = ScrollTabBarViewStateLanguages;
}


- (void)viewDidUnload {
    self.controlPanelView = nil;
    
    // Notify not-viewcontroller classes about views unload (tabBarController, placeEditorController)
    [[NSNotificationCenter defaultCenter] postNotificationName:LSMultiTabViewDidUnloadNotification object:self];
    
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark ScrollTabBarControllerDelegate Methods

- (void)tabBarController:(ScrollTabBarController *)controller 
 accessoryButtonSelected:(MultiTabItemType)buttonType 
				 tabItem:(LSTabItem *)item 
				 atIndex:(NSInteger)selectedIndex 
{
	if (buttonType == MultiTabItemOptionsType) {
        self.selectedTabLabel.text = @"Options button selected";
	}
	else { // back
		self.selectedTabLabel.text = @"";
        self.innerLevelsLabel.text = @"";
	}
}


- (void)tabBarController:(ScrollTabBarController *)controller 
			 tabSelected:(LSTabItem *)item 
				 atIndex:(NSInteger)selectedIndex
{    
    self.selectedTabLabel.text = [NSString stringWithFormat:@"%@ selected", item.title];
    if (self.lastSelectedTabItem != item)
        self.innerLevelsLabel.text = @"";
    
    self.lastSelectedTabItem = item;
}


- (void)tabBarController:(ScrollTabBarController *)controller mostNestedLevelReachedForTabItem:(LSTabItem *)item {
    self.innerLevelsLabel.text = @"(no other inner levels)";
}


#pragma mark - Actions

- (IBAction)tabTypeChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    ScrollTabBarViewState newViewState;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        newViewState = ScrollTabBarViewStateLanguages;
        [UIView animateWithDuration:0.25f animations:^{
            self.instr1Label.alpha = 1.0f;
            self.instr2Label.alpha = 1.0f;
        }];
    }
    else {
        newViewState = ScrollTabBarViewStateCategories;
        [UIView animateWithDuration:0.25f animations:^{
            self.instr1Label.alpha = 0.0f;
            self.instr2Label.alpha = 0.0f;
        }];
    }
    
    [self.tabBarController setViewState:newViewState animated:YES];
}


@end
