//
//  LSTintedButtonsDemoViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LSTintedButtonsDemoViewController.h"
#import "UIColor+components.h"
#import "UIButton+shortcuts.h"
#import "UIImage+shortcuts.h"
#import "LSTintedButton.h"
#import "ColorButton.h"



const  CGFloat   LSTintColorAlphaValue = 0.6f;

const  CGFloat   LSButtonsMargin = 20.0f;

const  NSInteger LSFirstColorButtonTag = 999;

static NSString *LSButtonLabelFont = @"MarkerFelt-Thin";



@interface LSTintedButtonsDemoViewController () {
    UIView          *_selectionView;
    NSInteger        _selectedColorIndex;
    NSArray         *_availableColors;
    LSTintedButton  *_tintedButton1;
    LSTintedButton  *_tintedButton2;
    LSTintedButton  *_tintedButton3;
}

@property (nonatomic, retain) UIView   *selectionView;

- (void)_initColorsPalette;
- (void)_createTestingButtons;
- (void)_setSelectedColorButton:(ColorButton *)button;
- (void)_setupButton:(UIButton *)button;

@end



@implementation LSTintedButtonsDemoViewController


@synthesize gradientBackgroundView;
@synthesize selectionView = _selectionView;
@synthesize delegate;


+ (NSString *)viewTitle {
    return @"Tinted buttons";
}


#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"LSTintedButtonsView" bundle:nil];
    if (self) {
        _selectedColorIndex = 0;
        _availableColors = [[NSArray alloc] initWithObjects:
                            [UIColor colorWithRed:0.0f green:0.6f blue:0.2f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.9f green:0.4f blue:0.1f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.6f green:0.3f blue:0.5f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.1f green:0.9f blue:1.0f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.3f green:0.4f blue:0.5f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.9f green:0.0f blue:0.0f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.0f green:0.3f blue:0.7f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.3f green:0.5f blue:0.9f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.8f green:0.8f blue:0.2f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:1.0f green:0.4f blue:0.4f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.4f green:0.8f blue:0.3f alpha:LSTintColorAlphaValue],
                            [UIColor colorWithRed:0.3f green:0.3f blue:0.7f alpha:LSTintColorAlphaValue],
                            nil
                            ];
    }
    
    return self;
}


- (void)dealloc {
    [_availableColors release];
    self.gradientBackgroundView = nil;
    self.delegate = nil;
    _selectionView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (UIView *)selectionView {
    if (_selectionView == nil) {
        _selectionView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        _selectionView.backgroundColor = [UIColor whiteColor];
        _selectionView.tag = 1001;
        
        CALayer *l = _selectionView.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        [l setBorderWidth:4.0];
        UIColor *borderColor = [[UIColor alloc] initWithWhite:1.0f alpha:0.8f];
        [l setBorderColor:[borderColor CGColor]];
        [borderColor release];
    }
    
    return _selectionView;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationItem.title = [LSTintedButtonsDemoViewController viewTitle];
	
    [self _createTestingButtons];
    
    [self _initColorsPalette];
    
    // Pre-select the first color
    [self _setSelectedColorButton:(ColorButton *)[self.gradientBackgroundView viewWithTag:LSFirstColorButtonTag]];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.gradientBackgroundView = nil;
    _selectionView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Button handlers

- (void)colorButtonTouchDown:(ColorButton *)sender {
    UIEdgeInsets capInsets;
    UIColor *newColor = sender.color;
    
    _tintedButton1.backgroundTintColor = newColor;
    capInsets = [_tintedButton1 backgroundImageForState:UIControlStateNormal].capInsets;
    // Re-apply the images after changing the tint color
    [_tintedButton1 setBackgroundImage:[[UIImage imageNamed:@"button1-normal"] createImageWithCapInsets:capInsets]
                              forState:UIControlStateNormal];
    [_tintedButton1 setBackgroundImage:[[UIImage imageNamed:@"button1-pressed"] createImageWithCapInsets:capInsets]
                              forState:UIControlStateHighlighted];
    
    _tintedButton2.backgroundTintColor = newColor;
    capInsets = [_tintedButton2 backgroundImageForState:UIControlStateNormal].capInsets;
    [_tintedButton2 setBackgroundImage:[[UIImage imageNamed:@"back-button"] createImageWithCapInsets:capInsets]
                              forState:UIControlStateNormal];
    
    _tintedButton3.backgroundTintColor = newColor;
    capInsets = [_tintedButton3 backgroundImageForState:UIControlStateNormal].capInsets;
    [_tintedButton3 setBackgroundImage:[UIImage imageNamed:@"shaped-button"]
                              forState:UIControlStateNormal];
    
    _selectedColorIndex = sender.colorIndex;
    
    [self _setSelectedColorButton:sender];
}


#pragma mark -
#pragma mark Private

- (void)_initColorsPalette {
    CGFloat marginX = 13.0f;
    CGFloat marginY = 10.0f;
    CGFloat offsetX = 18.0f;
    CGFloat offsetY = 15.0f;
    CGFloat posX;
    CGFloat posY = marginY;
    CGFloat dim = 34.0f;
    NSInteger index = 0;
    ColorButton *button = nil;
    
    CGFloat redComponent;
    CGFloat greenComponent;
    CGFloat blueComponent;
    const CGFloat *components = NULL;
    NSInteger maxColors = _availableColors.count;
    
    for (int row=0; row < 6; row++) {
        posX = marginX;
        for (int column=0; column < 6; column++) {
            button = [[ColorButton alloc] initWithFrame:CGRectMake(posX, posY, dim, dim)];
            if (index == 0)
                button.tag = LSFirstColorButtonTag;   // Reference to the first color button
            
            UIColor *color = [_availableColors objectAtIndex:index];
            components = [color getRGBAColorComponents];
            redComponent   = components[0];
            greenComponent = components[1];
            blueComponent  = components[2];
            
            UIColor *colorWithoutAlpha = [[UIColor alloc] initWithRed:redComponent green:greenComponent blue:blueComponent alpha:1.0f];
            button.colorIndex = index;
            [button setColor:colorWithoutAlpha];
            [colorWithoutAlpha release];
            
            [button addTarget:self action:@selector(colorButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [self.gradientBackgroundView addSubview:button];
            [button release];
            posX += dim + offsetX;
            index++;
            
            if (index == maxColors)
                break;
        }
        
        if (index == maxColors)
            break;
        
        posY += dim + offsetY;
    }
}


- (void)_createTestingButtons {
    // Button 1
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0f, 6.0f, 22.0f, 6.0f);
    UIButton *sourceButton1 = [UIButton buttonWithNormalStateImage:[UIImage imageNamed:@"button1-normal"] 
                                                    highlightImage:[UIImage imageNamed:@"button1-pressed"] 
                                                     selectedImage:nil 
                                                         capInsets:capInsets];
    [self _setupButton:sourceButton1];
    [sourceButton1 setTitle:@"Button 1" forState:UIControlStateNormal];
    sourceButton1.frame = CGRectMake(LSButtonsMargin, 50.0f, 100.0f, 44.0f);
    [self.view addSubview:sourceButton1];
    
    
    UIColor *tintColor = [_availableColors objectAtIndex:_selectedColorIndex];
    CGRect viewFrame = self.view.frame;
    
    _tintedButton1 = [LSTintedButton buttonWithTintColor:tintColor];
    [self _setupButton:_tintedButton1];
    [_tintedButton1 setTitle:@"Button 1" forState:UIControlStateNormal];
    [_tintedButton1 setBackgroundImage:[[UIImage imageNamed:@"button1-normal"] createImageWithCapInsets:capInsets]
                              forState:UIControlStateNormal];
    [_tintedButton1 setBackgroundImage:[[UIImage imageNamed:@"button1-pressed"] createImageWithCapInsets:capInsets]
                              forState:UIControlStateHighlighted];
    _tintedButton1.frame = CGRectMake(viewFrame.size.width-LSButtonsMargin-sourceButton1.frame.size.width, sourceButton1.frame.origin.y, 
                                      sourceButton1.frame.size.width, sourceButton1.frame.size.height);
    [self.view addSubview:_tintedButton1];
    
    
    // Button 2
    capInsets = UIEdgeInsetsMake(6.0f, 14.0f, 6.0f, 6.0f);
    UIButton *sourceButton2 = [UIButton buttonWithNormalStateImage:[UIImage imageNamed:@"back-button"] 
                                                    highlightImage:nil
                                                     selectedImage:nil 
                                                         capInsets:capInsets];
    sourceButton2.titleEdgeInsets = UIEdgeInsetsMake(2.0f, 10.0f, 2.0f, 4.0f);
    sourceButton2.titleLabel.font = [UIFont fontWithName:LSButtonLabelFont size:13.0f];
    sourceButton2.titleLabel.shadowOffset = CGSizeMake(0, 0);	// one point above the text
    [sourceButton2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sourceButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sourceButton2 setTitle:@"Button 2" forState:UIControlStateNormal];
    sourceButton2.frame = CGRectMake(LSButtonsMargin, 120.0f, 100.0f, 31.0f);
    [self.view addSubview:sourceButton2];
    
    _tintedButton2 = [LSTintedButton buttonWithTintColor:tintColor];
    _tintedButton2.titleEdgeInsets = UIEdgeInsetsMake(2.0f, 10.0f, 2.0f, 4.0f);
    _tintedButton2.titleLabel.font = [UIFont fontWithName:LSButtonLabelFont size:13.0f];
    _tintedButton2.titleLabel.shadowOffset = CGSizeMake(0, 0);	// one point above the text
    [_tintedButton2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_tintedButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_tintedButton2 setTitle:@"Button 2" forState:UIControlStateNormal];
    [_tintedButton2 setBackgroundImage:[[UIImage imageNamed:@"back-button"] createImageWithCapInsets:capInsets]
                              forState:UIControlStateNormal];
    _tintedButton2.frame = CGRectMake(viewFrame.size.width-LSButtonsMargin-sourceButton2.frame.size.width, sourceButton2.frame.origin.y, 
                                      sourceButton2.frame.size.width, sourceButton2.frame.size.height);
    [self.view addSubview:_tintedButton2];
    
    
    // Button 3
    capInsets = UIEdgeInsetsMake(6.0f, 14.0f, 6.0f, 6.0f);
    UIButton *sourceButton3 = [UIButton buttonWithNormalStateImage:[UIImage imageNamed:@"shaped-button"] 
                                                    highlightImage:nil
                                                     selectedImage:nil 
                                                         capInsets:UIEdgeInsetsZero];
    [self _setupButton:sourceButton3];
    sourceButton3.titleLabel.numberOfLines = 3;
    sourceButton3.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 8.0f, 0.0f, 6.0f);
    [sourceButton3 setTitle:@"Sample button 3" forState:UIControlStateNormal];
    sourceButton3.frame = CGRectMake(LSButtonsMargin, 150.0f, 0.0f, 0.0f);
    [sourceButton3 sizeToFit];
    [self.view addSubview:sourceButton3];
    
    _tintedButton3 = [LSTintedButton buttonWithTintColor:tintColor];
    [self _setupButton:_tintedButton3];
    _tintedButton3.titleLabel.numberOfLines = 3;
    _tintedButton3.titleEdgeInsets = sourceButton3.titleEdgeInsets;
    [_tintedButton3 setTitle:@"Sample button 3" forState:UIControlStateNormal];
    [_tintedButton3 setBackgroundImage:[UIImage imageNamed:@"shaped-button"]
                              forState:UIControlStateNormal];
    _tintedButton3.frame = CGRectMake(viewFrame.size.width-LSButtonsMargin-sourceButton3.frame.size.width, sourceButton3.frame.origin.y, 
                                      sourceButton3.frame.size.width, sourceButton3.frame.size.height);
    [self.view addSubview:_tintedButton3];
}


- (void)_setSelectedColorButton:(ColorButton *)button {
    CGRect selectionFrame = button.frame;
    selectionFrame.origin.x -= 4.0f;
    selectionFrame.origin.y -= 4.0f;
    selectionFrame.size.width += 8.0f;
    selectionFrame.size.height += 8.0f;
    
    self.selectionView.frame = selectionFrame;
    
    if ([self.gradientBackgroundView viewWithTag:1001] == nil) 
        [self.gradientBackgroundView addSubview:self.selectionView];
    
    [self.gradientBackgroundView bringSubviewToFront:button];
}


- (void)_setupButton:(UIButton *)button {
    button.titleLabel.font = [UIFont fontWithName:LSButtonLabelFont size:13.0f];
    button.titleLabel.textAlignment = UITextAlignmentCenter;
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [button setTitleColor:[UIColor whiteColor] 
                 forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor]
                       forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.7f]
                       forState:UIControlStateSelected];    
//    button.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 8.0f, 0.0f, 6.0f);
}


@end
