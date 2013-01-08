//
//  LSTabItem.m
//  LSTabs
//
//  Created by Marco Mussini on 1/3/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabItem.h"


@implementation LSTabItem


@synthesize title;
@synthesize object;
@synthesize badgeNumber;
@synthesize idMask;
@synthesize parentTabControl;


- (id)init {
    return [self initWithTitle:nil];
}


- (id)initWithTitle:(NSString *)aTitle {
    self = [super init];
    if (self) {
        title = [aTitle copy];
        badgeNumber = 0;
        idMask = NSIntegerMax;
    }
    
    return self;
}


- (void)dealloc {
    [title release]; title = nil;
    [object release]; object = nil;
    parentTabControl = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (void)setTitle:(NSString *)newTitle {
    if ([newTitle isEqualToString:title] == NO) {
        [title release];
        title = [newTitle copy];
        [parentTabControl performSelector:@selector(tabItem:titleChangedTo:)
                               withObject:self
                               withObject:newTitle];
    }
}


- (void)setBadgeNumber:(int)value {
    value = value < 0 ? 0 : value;
    badgeNumber = value;
    [parentTabControl performSelector:@selector(tabItem:badgeNumberChangedTo:)
                           withObject:self
                           withObject:(id)value];
}


@end
