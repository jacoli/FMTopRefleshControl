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
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CustomTopRefleshView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.indicator];
        [self addSubview:self.textLabel];
    }
    
    return self;
}

- (UIImageView *)indicator {
    if (!_indicator) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:v];
        
        NSMutableArray *imgs = [[NSMutableArray alloc] init];
        for (NSInteger idx = 0; idx < 45; ++idx) {
            [imgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)(idx + 1)]]];
        }
        v.animationImages = imgs;
        
        _indicator = v;
    }
    
    return _indicator;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _textLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) / 2 - 100, CGRectGetHeight(self.frame) - 24 - 20, 200, 24);
    self.indicator.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame) - 24, CGRectGetHeight(self.frame) - 24 - 20, 24, 24);
}

- (void)pullToReflesh {
    //self.backgroundColor = [UIColor blueColor];
    self.textLabel.text = @"pull to relfesh";
}

- (void)releaseToReflesh {
    //self.backgroundColor = [UIColor yellowColor];
    self.textLabel.text = @"release to relfesh";
}

- (void)startReflesh {
    //self.backgroundColor = [UIColor redColor];
    [self.indicator startAnimating];
    self.textLabel.text = @"relfesh...";
}

- (void)refleshFinished {
    //self.backgroundColor = [UIColor whiteColor];
    [self.indicator stopAnimating];
    self.textLabel.text = nil;
}

@end
