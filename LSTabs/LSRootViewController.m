//
//  LSRootViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 18/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSRootViewController.h"


static NSString *const LSRootViewControllerTitleKey = @"title";
static NSString *const LSRootViewControllerClassKey = @"classesList";



@implementation LSRootViewController {
	NSArray *_viewControllers;
}


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _viewControllers = @[ @{LSRootViewControllerClassKey : @[@"LSTintedButtonsDemoViewController", @"LSTabControlsDemoViewController"],
                                LSRootViewControllerTitleKey : @"Buttons & TabControls"},
        
                              @{LSRootViewControllerClassKey : @[@"LSHorizontalScrollTabViewDemoViewController",
                                                                 @"LSVerticalScrollTabViewDemoViewController",
                                                                 @"LSMultiTabDemoViewController"],
                                LSRootViewControllerTitleKey : @"Tab Views"} ];
        
        [_viewControllers retain];
    }
    
    return self;
}


- (void)dealloc {
	[_viewControllers release];
	[super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"LSTabs Demo";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    
	return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_viewControllers count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_viewControllers objectAtIndex:section] objectForKey:LSRootViewControllerClassKey] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
	
    NSDictionary *viewControllerDescriptor = [_viewControllers objectAtIndex:indexPath.section];
	Class demoClass = [[NSBundle mainBundle] classNamed:[[viewControllerDescriptor objectForKey:LSRootViewControllerClassKey] objectAtIndex:indexPath.row]];
		
	cell.textLabel.text = [demoClass performSelector:@selector(viewTitle)];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[_viewControllers objectAtIndex:section] objectForKey:LSRootViewControllerTitleKey];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Class klass = [[NSBundle mainBundle] classNamed:[[[_viewControllers objectAtIndex:indexPath.section] objectForKey:LSRootViewControllerClassKey] objectAtIndex:indexPath.row]];
	UIViewController *viewController = [[klass alloc] init];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

@end
