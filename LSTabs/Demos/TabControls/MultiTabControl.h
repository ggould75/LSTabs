//
//  CustomTabControl.h
//  LSTabs
//
//  Created by Marco Mussini on 6/26/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "TintedVerticalTabControl.h"


UIKIT_EXTERN NSString *MultiTabControlSelectedImageName;
UIKIT_EXTERN NSString *MultiTabControlNormalImageName;       
UIKIT_EXTERN NSString *MultiTabControlNormalImageBWName;
UIKIT_EXTERN NSString *MultiTabControlHighlightedImageName;
UIKIT_EXTERN NSString *MultiTabControlHighlightedImageBWName;


@interface MultiTabControl : TintedVerticalTabControl

- (void)flashMe;

@end
