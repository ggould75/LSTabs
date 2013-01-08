//
//  ColorButton.h
//  LSTabs
//
//  Created by Marco Mussini on 18/06/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorButton : UIControl {
  @private
    UIColor  *_color;
}

@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, retain) UIColor  *color;


@end
