//
//  ObjectCollection.m
//  LSTabs
//
//  Created by Marco Mussini on 6/29/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "ObjectCollection.h"


NSString *ObjectCollectionTitleKey     = @"title";
NSString *ObjectCollectionBadgeKey     = @"badgeNumber";
NSString *ObjectCollectionChildrenKey  = @"children";
NSString *ObjectCollectionColorKey     = @"color";


@interface ObjectCollection () {
    NSArray *_languages;
    NSArray *_categories;
}

@end



@implementation ObjectCollection


static ObjectCollection *_collectionSharedInstance = nil; 

@synthesize languages;
@synthesize categories;


#pragma mark - Singleton design pattern 

+ (ObjectCollection *)sharedInstance {
    @synchronized(self) {
        if (_collectionSharedInstance == nil) {
            _collectionSharedInstance = [NSAllocateObject([self class], 0, NULL) init];
            [[NSNotificationCenter defaultCenter] addObserver:_collectionSharedInstance
                                                     selector:@selector(didReceiveMemoryWarning)
                                                         name:UIApplicationDidReceiveMemoryWarningNotification
                                                       object:nil];
        }
	}
    
    return _collectionSharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
	return [[self sharedInstance] retain];
}


- (id)copyWithZone:(NSZone *)zone {
	return self;
}


- (id)retain {
	return self;
}


- (NSUInteger)retainCount {
	return NSUIntegerMax;
}


- (oneway void)release {
	// do nothing
}


- (id)autorelease {
	return self;
}


#pragma mark -
#pragma mark Accessors

- (NSArray *)languages {
    if (_languages == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"languages" ofType:@"plist"];
        _languages = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Root"] retain];
    }
        
    return _languages;
}


- (NSArray *)categories {
    if (_categories == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];

        // Create a mutable structure from a plist file which is usually immutable
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *root = [NSPropertyListSerialization propertyListWithData:data 
                                                                       options:NSPropertyListMutableContainersAndLeaves 
                                                                        format:NULL 
                                                                         error:NULL];
        _categories = [[root objectForKey:@"Root"] retain];
        
        // Assign a color to each category
        NSArray *colors = [NSArray arrayWithObjects:
                            [UIColor colorWithRed:0.4f green:0.8f blue:0.3f alpha:0.5f],          // 0
                            [UIColor colorWithRed:0.3f green:0.5f blue:0.9f alpha:0.5f],          // 1
                            [UIColor colorWithRed:0.9f green:0.2f blue:0.1f alpha:0.5f],          // 2
                            [UIColor colorWithRed:1.0f green:0.4f blue:0.4f alpha:0.5f],          // 3
                            [UIColor colorWithRed:0.6f green:0.3f blue:0.5f alpha:0.5f],          // 4
                            [UIColor colorWithRed:0.3f green:0.6f blue:0.6f alpha:0.5f],          // 5
                            [UIColor colorWithRed:0.0f green:0.3f blue:0.7f alpha:0.5f],          // 6
                            [UIColor colorWithRed:0.1f green:0.5f blue:0.2f alpha:0.5f],          // 7
                            [UIColor colorWithRed:0.9f green:0.0f blue:0.0f alpha:0.5f],          // 8
                            [UIColor colorWithRed:0.7f green:0.6f blue:0.4f alpha:0.5f],          // 9
                            [UIColor colorWithRed:0.3f green:0.3f blue:0.7f alpha:0.5f],          // 10
                            nil];
        [_categories enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
            [obj setObject:[colors objectAtIndex:idx] forKey:ObjectCollectionColorKey];
        }];
    }
    
    return _categories;
}


#pragma mark -

+ (NSArray *)sublanguagesForLanguage:(NSDictionary *)language {
    return (language == nil ? [[self class] sharedInstance].languages : [language objectForKey:ObjectCollectionChildrenKey]);
}


#pragma mark -
#pragma mark Private methods

- (void)didReceiveMemoryWarning {
    [_languages release]; _languages = nil;
    [_categories release]; _categories = nil;
}


@end
