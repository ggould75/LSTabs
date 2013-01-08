//
//  LSStaticTabViewDemoViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSStaticTabViewDemoViewController.h"

// View shortcuts
#import "UIView+Addictions.h"


@interface LSStaticTabViewDemoViewController ()

@end


@implementation LSStaticTabViewDemoViewController


+ (NSString *)viewTitle {
    return @"Static Tab View";
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = [[self class] viewTitle];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
