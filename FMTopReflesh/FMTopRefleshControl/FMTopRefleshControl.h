//
//  FMTopRefleshControl.h
//  FMTopReflesh
//
//  Created by 李传格 on 16/6/25.
//  Copyright © 2016年 lichuange. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMTopRefleshControlTopView <NSObject>

@optional
- (void)pullToReflesh;

- (void)releaseToReflesh;

- (void)startReflesh;

- (void)refleshFinished;

@end

@interface FMTopRefleshControl : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView withRefleshCallback:(void(^)(FMTopRefleshControl *control))refleshCallback withTopView:(UIView<FMTopRefleshControlTopView> *)topView;

- (void)endReflesh;

@end
