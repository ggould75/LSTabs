//
//  AppDelegate.h
//  LSTabs
//
//  Created by Marco Mussini on 6/16/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;


+ (BOOL)isRetinaDisplay;

@end
