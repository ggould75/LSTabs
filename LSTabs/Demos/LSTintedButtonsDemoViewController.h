//
//  LSTintedButtonsDemoViewController.h
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoViewControllerProtocol.h"
#import "ColorPickerBackgroundView.h"


@class LSTintedButtonsDemoViewController;

@protocol CategoryColorPickerViewControllerDelegate <NSObject>

- (void)viewController:(LSTintedButtonsDemoViewController *)controller didSelectColor:(UIColor *)color;

@end



@interface LSTintedButtonsDemoViewController : UIViewController <DemoViewControllerProtocol>

@property (nonatomic, retain) IBOutlet ColorPickerBackgroundView            *gradientBackgroundView;
@property (nonatomic, assign) id<CategoryColorPickerViewControllerDelegate>  delegate;

@end
