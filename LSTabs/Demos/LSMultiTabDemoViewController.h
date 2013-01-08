//
//  LSMultiTabDemoViewController.h
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoViewControllerProtocol.h"
#import "ScrollTabBarController.h"  


@interface LSMultiTabDemoViewController : UIViewController <ScrollTabBarControllerDelegate, DemoViewControllerProtocol>

@property (nonatomic, retain) IBOutlet UIView  *controlPanelView;
@property (nonatomic, retain) IBOutlet UILabel *selectedTabLabel;
@property (nonatomic, retain) IBOutlet UILabel *innerLevelsLabel;
@property (nonatomic, retain) IBOutlet UILabel *instr1Label;
@property (nonatomic, retain) IBOutlet UILabel *instr2Label;

- (IBAction)tabTypeChanged:(id)sender;

@end
