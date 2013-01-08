//
//  LSScrollableTabView.h
//  LSTabs
//
//  Created by Marco Mussini on 1/6/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSTabBarView.h"


@interface LSScrollTabBarView : LSTabBarView <UIScrollViewDelegate> {
  @protected
    UIView        *overflowLeft;
    UIView        *overflowRight;
    UIScrollView  *scrollView;
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
