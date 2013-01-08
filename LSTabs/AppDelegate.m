//
//  AppDelegate.m
//  LSTabs
//
//  Created by Marco Mussini on 6/16/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "AppDelegate.h"
#import "LSRootViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;


static BOOL retinaDisplay;

+ (void)initialize {
	retinaDisplay = ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00);
}


+ (BOOL)isRetinaDisplay {
	return retinaDisplay; 
}


- (void)dealloc {
    [_window release];
    [_navigationController release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    LSRootViewController *viewController = [[LSRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
	self.navigationController = aNavigationController;
    
    [viewController release];
    [aNavigationController release];

    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}


@end
