//
//  LSVerticalScrollTabViewController.h
//  LSTabs
//
//  Created by Marco Mussini on 6/23/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoViewControllerProtocol.h"
#import "LSTabBarView.h"


@interface LSVerticalScrollTabViewDemoViewController : UIViewController <LSTabBarViewDelegate, UITextFieldDelegate, DemoViewControllerProtocol>

@property (nonatomic, retain) IBOutlet UIImageView *controlPanelView;
@property (nonatomic, retain) IBOutlet UIImageView *borderImageView;
@property (nonatomic, retain) IBOutlet UILabel     *selectedTabLabel;
@property (nonatomic, retain) IBOutlet UIButton    *addButton;
@property (nonatomic, retain) IBOutlet UIButton    *removeButton;
@property (nonatomic, retain) IBOutlet UITextField *tabIndexTextField;
@property (nonatomic, retain) IBOutlet UITextField *quantityTextField;
@property (nonatomic, retain) IBOutlet UISwitch    *useAnimationsSwitch;

- (IBAction)addTab:(id)sender;
- (IBAction)removeTab:(id)sender;

@end
