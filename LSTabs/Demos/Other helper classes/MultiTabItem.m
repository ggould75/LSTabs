//
//  MultiTabItem.m
//  LSTabs
//
//  Created by Marco Mussini on 6/26/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "MultiTabItem.h"
#import "ObjectCollection.h"


@implementation MultiTabItem


@synthesize color;
@synthesize expanded = _expanded;


#pragma mark -
#pragma mark Initialization

+ (id)tabItemWithLanguage:(NSDictionary *)language {
    MultiTabItem *item = [[MultiTabItem alloc] initWithTitle:[language objectForKey:ObjectCollectionTitleKey]];
    item.badgeNumber = [[language objectForKey:ObjectCollectionBadgeKey] integerValue];
    item.object = language;
    
    return [item autorelease];
}


- (void)dealloc {
    [color release]; color = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (void)setColor:(UIColor *)newColor {
    [color release];
    color = [newColor retain];
    if ([(id)parentTabControl respondsToSelector:@selector(tabItem:tabColorChangedTo:)])
        [parentTabControl performSelector:@selector(tabItem:tabColorChangedTo:)
                               withObject:self
                               withObject:newColor];
}


#pragma mark -

+ (NSInteger)findIndexOfItemWithObject:(NSObject *)anObject inArray:(NSArray *)items {
    __block NSInteger foundIndex = -1;
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([((MultiTabItem *)obj).object isEqual:anObject]) {
            foundIndex = idx;
            *stop = YES;
        }
    }];

    return foundIndex;
}


@end
