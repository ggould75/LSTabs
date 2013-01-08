//
//  LSHorizontalScrollTabViewDemoViewController.h
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoViewControllerProtocol.h"
#import "LSTabBarView.h"


@interface LSHorizontalScrollTabViewDemoViewController : UIViewController <LSTabBarViewDelegate, DemoViewControllerProtocol>

@property (nonatomic, retain) IBOutlet UIImageView *controlPanelView;
@property (nonatomic, retain) IBOutlet UIImageView *borderImageView;
@property (nonatomic, retain) IBOutlet UILabel     *selectedTabLabel;

@end
