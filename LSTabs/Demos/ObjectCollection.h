//
//  ObjectCollection.h
//  LSTabs
//
//  Created by Marco Mussini on 6/29/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <Foundation/Foundation.h>


UIKIT_EXTERN NSString *ObjectCollectionTitleKey;
UIKIT_EXTERN NSString *ObjectCollectionBadgeKey;
UIKIT_EXTERN NSString *ObjectCollectionChildrenKey;
UIKIT_EXTERN NSString *ObjectCollectionColorKey;


@interface ObjectCollection : NSObject { }

@property (nonatomic, retain, readonly) NSArray *languages;
@property (nonatomic, retain, readonly) NSArray *categories;

/**
 * Returns an instance of this class (singleton pattern)
 */
+ (ObjectCollection *)sharedInstance;

+ (NSArray *)sublanguagesForLanguage:(NSDictionary *)language;


@end
