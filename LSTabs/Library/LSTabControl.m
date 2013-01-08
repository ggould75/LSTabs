//
//  LSTabControl.m
//  LSTabs
//
//  Created by Marco Mussini on 1/3/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabControl.h"
#import "LSTabControl_Protected.h"
#import "LSTabItem.h"
#import "BadgeView.h"

// View shortcuts
#import "UIView+Addictions.h"



@interface LSTabControl () {
    NSUInteger _maxBadgeNumber;
}

- (void)_tabItemChangedTo:(LSTabItem *)newTabItem;

@end



@implementation LSTabControl


@synthesize tabItem;
@synthesize maxBadgeNumber = _maxBadgeNumber;
@synthesize badgeView;


// Not really necessary in this case because if initWithFrame is used instead of
// the designated initializer, tabItem is already nil because is property
- (id)initWithFrame:(CGRect)frame {
    return [self initWithItem:nil];
}


- (id)initWithItem:(LSTabItem *)item {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Diplay "999+" inside of the badge view if the objects count is greater than this value
		_maxBadgeNumber = 999;

        button = [[self buttonWithTitle:item.title] retain];
        [self addSubview:button];
        
        // I set this property to NO because I want to let client's classes to attach any kind of action
        // with addTarget:action:forControlEvents: as if this actions would be attached to the inner button. 
        // See UIResponder's methods implementation below.
        button.userInteractionEnabled = NO;

        [self _tabItemChangedTo:item];
    }
    
    return self;
}


- (void)dealloc {
    [button release]; button = nil;
    [badgeView release]; badgeView = nil;
    [tabItem release]; tabItem = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (void)setTabItem:(LSTabItem *)newTabItem {
    if (newTabItem != tabItem) {
        [self _tabItemChangedTo:newTabItem];
    }
}


- (void)setMaxBadgeNumber:(NSUInteger)maxBadgeNumber {
	if (maxBadgeNumber != _maxBadgeNumber) {
		_maxBadgeNumber = maxBadgeNumber;
		[self updateBadgeNumber];
	}
}


- (void)setHighlighted:(BOOL)newHighlighted {
    if (newHighlighted != self.isHighlighted) {
        [super setHighlighted:newHighlighted];
        button.highlighted = newHighlighted;
    }
}


- (void)setSelected:(BOOL)newSelected {
    if (newSelected != self.isSelected) {
        [super setSelected:newSelected];
        button.selected = newSelected;
    }
}


// Subclass might override this method to provide a different view subclass
- (UIView *)badgeView {
    if (badgeView == nil) {
        badgeView = [[BadgeView alloc] initWithFrame:CGRectZero];
        badgeView.backgroundColor = [UIColor clearColor];
    }
    
    return badgeView;
}


#pragma mark -
#pragma mark UIResponder methods
 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
    
    // Forward the event to button only for touches inside of it
    UITouch *touch = [touches anyObject];
    CGPoint pointInside = [touch locationInView:[touch view]];
    if ([button pointInside:pointInside withEvent:event])
        [button beginTrackingWithTouch:touch withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    [button endTrackingWithTouch:touch withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
    
	// Forward the event to button
	[button continueTrackingWithTouch:[[event allTouches] anyObject] withEvent:event];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    
    [button cancelTrackingWithEvent:event];
}


#pragma mark -

/**
 * Just return the button's size because the badge is always within its bounding box.
 * Reimplement this method in subclass to perform different sizing policy
 */
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize buttonSize = [button sizeThatFits:size];
    
    return buttonSize;
}


- (void)layoutSubviews { 
    [super layoutSubviews];
    
    // Position to the right upper corner
    if (CGRectIsEmpty(self.frame) == NO && CGRectIsEmpty(badgeView.frame) == NO) {
        badgeView.frame = CGRectMake(self.viewWidth - (badgeView.viewWidth/2), -(badgeView.viewHeight/2),
                                     badgeView.viewWidth, badgeView.viewHeight);
        badgeView.hidden = NO;
    }
    else
        badgeView.hidden = YES;
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [button setTitle:title forState:state];
}


- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [button setTitleColor:color forState:state];
}


- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state {
    [button setTitleShadowColor:color forState:state];
}


- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [button setImage:image forState:state];
}


- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [button setBackgroundImage:image forState:state];
}


- (NSString *)titleForState:(UIControlState)state {
    return [button titleForState:state];
}


- (UIColor *)titleColorForState:(UIControlState)state {
    return [button titleColorForState:state];
}


- (UIColor *)titleShadowColorForState:(UIControlState)state {
    return [button titleShadowColorForState:state];
}


- (UIImage *)imageForState:(UIControlState)state {
    return [button imageForState:state];
}


- (UIImage *)backgroundImageForState:(UIControlState)state {
    return [button backgroundImageForState:state];
}


#pragma mark -
#pragma mark LSTabItemDelegate

- (void)tabItem:(LSTabItem *)item badgeNumberChangedTo:(int)value {
    [self updateBadgeNumber];
}


- (void)tabItem:(LSTabItem *)item titleChangedTo:(NSString *)title {
    [self setTitle:item.title forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Protected methods

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [newButton setTitle:title forState:UIControlStateNormal];
    
    return newButton;
}


- (void)updateBadgeNumber {
    if (self.tabItem.badgeNumber > 0) {
        if (badgeView == nil)
            [self addSubview:self.badgeView];   // Will automatically call setNeedsLayout
        
        if (self.tabItem.badgeNumber <= [self maxBadgeNumber])
            [self updateBadgeText:[NSString stringWithFormat:@"%d", self.tabItem.badgeNumber]];
        else
            [self updateBadgeText:[NSString stringWithFormat:@"%d+", self.maxBadgeNumber]];

        badgeView.hidden = CGRectIsEmpty(self.frame);
        [badgeView sizeToFit];
    } 
    else
        badgeView.hidden = YES;
}


- (void)updateBadgeText:(NSString *)text {
    ((BadgeView *)badgeView).textLabel.text = text;
}


#pragma mark -
#pragma mark Private

/**
 * Implements the behavior of setTabItem accessor method.
 * I moved its implementation to a private function because the tabItem property needs
 * to be initialized also within the init method, but, because it's not safe to do so
 * during an object initialization, I moved all this stuff here.
 * This ensure that the object is correctly initialized even if a subclass override the accessor
 * or do something different with the accessor.
 * @SEE: http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmPractical.html
 * @SEE: http://stackoverflow.com/questions/3424382/why-shoudnt-i-use-accessor-methods-in-init-methods
 */
- (void)_tabItemChangedTo:(LSTabItem *)newTabItem {
    [tabItem performSelector:@selector(setParentTabControl:) withObject:nil];
    [tabItem release];
    tabItem = [newTabItem retain];
    [tabItem performSelector:@selector(setParentTabControl:) withObject:self];
    
    [button setTitle:tabItem.title 
            forState:UIControlStateNormal];

	[self updateBadgeNumber];
}


@end
