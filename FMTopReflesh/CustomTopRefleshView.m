//
//  CustomTopRefleshView.m
//  FMTopReflesh
//
//  Created by 李传格 on 16/6/25.
//  Copyright © 2016年 lichuange. All rights reserved.
//

#import "CustomTopRefleshView.h"

@interface CustomTopRefleshView ()

@property (nonatomic, strong) UIImageView *indicator;

@end

@implementation CustomTopRefleshView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 12, CGRectGetHeight(self.frame) - 24 - 12, 24, 24)];
        [self addSubview:v];
        
        NSMutableArray *imgs = [[NSMutableArray alloc] init];
        for (NSInteger idx = 0; idx < 45; ++idx) {
            [imgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)(idx + 1)]]];
        }
        v.animationImages = imgs;
        
        self.indicator = v;
    }
    
    return self;
}

- (void)pullToReflesh {
    self.backgroundColor = [UIColor blueColor];
}

- (void)releaseToReflesh {
    self.backgroundColor = [UIColor yellowColor];
}

- (void)startReflesh {
    self.backgroundColor = [UIColor redColor];
    [self.indicator startAnimating];
}

- (void)refleshFinished {
    self.backgroundColor = [UIColor grayColor];
    [self.indicator stopAnimating];
}

@end
