//
//  FMTopRefleshControl.m
//  FMTopReflesh
//
//  Created by 李传格 on 16/6/25.
//  Copyright © 2016年 lichuange. All rights reserved.
//

#import "FMTopRefleshControl.h"

@interface FMTopRefleshDefaultStyleView : UIView <FMTopRefleshControlTopView>

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FMTopRefleshDefaultStyleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.indicator];
        [self addSubview:self.textLabel];
    }
    
    return self;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    return _indicator;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:12.f];
        _textLabel.textColor = [UIColor grayColor];
    }
    
    return _textLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.indicator.frame = CGRectMake(CGRectGetMidX(self.bounds) - 12, CGRectGetMidY(self.bounds) - 24, 24, 24);
    self.textLabel.frame = CGRectMake(0, CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds), 24);
}

- (void)pullToReflesh {
    [self.indicator startAnimating];
    self.textLabel.text = @"下拉刷新";
}

- (void)releaseToReflesh {
    self.textLabel.text = @"释放刷新";
}

- (void)startReflesh {
    self.textLabel.text = @"刷新中...";
}

- (void)refleshFinished {
    [self.indicator stopAnimating];
    self.textLabel.text = @"刷新结束";
}

@end

static char __stateDesc[4][30] = {"None", "Possible", "ReleaseToReflesh", "Refleshing"};

typedef NS_ENUM(NSInteger, FMRefleshState) {
    kFMRefleshStateNone = 0,
    kFMRefleshStatePossible,
    kFMRefleshStateReleaseToReflesh,
    kFMRefleshStateRefleshing
};

@interface FMTopRefleshControl ()

@property (nonatomic, assign) FMRefleshState state;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<FMTopRefleshControlTopView> *topRefleshView;
@property (nonatomic, copy) void(^refleshCallback)(FMTopRefleshControl *control);
@property (nonatomic, assign) CGFloat refleshingTopInset;
@property (nonatomic, assign) CGFloat refleshingToReleaseTopInset;

@end

@implementation FMTopRefleshControl

- (instancetype)initWithScrollView:(UIScrollView *)scrollView withRefleshCallback:(void(^)(FMTopRefleshControl *control))refleshCallback withTopView:(UIView<FMTopRefleshControlTopView> *)topView {
    if (self = [super init]) {
        self.state = kFMRefleshStateNone;
        self.scrollView = scrollView;
        self.refleshCallback = refleshCallback;
        self.topRefleshView = topView;
        
        if (topView) {
            CGRect rc = topView.frame;
            rc.origin.y = -rc.size.height;
            topView.frame = rc;
            self.refleshingTopInset = rc.size.height;
        } else {
            self.refleshingTopInset = 64;
        }
        self.refleshingToReleaseTopInset = self.refleshingTopInset + 20;
        
        if (scrollView) {
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
            [scrollView addSubview:self.topRefleshView];
        }
    }
    
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView withRefleshCallback:(void(^)(FMTopRefleshControl *control))refleshCallback {
    return [self initWithScrollView:scrollView withRefleshCallback:refleshCallback withTopView:[[FMTopRefleshDefaultStyleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)]];
}

- (BOOL)refleshing {
    return self.state == kFMRefleshStateRefleshing;
}

- (void)dealloc {
    if (self.state == kFMRefleshStateRefleshing) {
        self.state = kFMRefleshStateNone;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top -= self.refleshingTopInset;
        self.scrollView.contentInset = insets;
    }
    [self.topRefleshView removeFromSuperview];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)setState:(FMRefleshState)state {
    NSLog(@"Top reflesh state from %s to %s.", __stateDesc[_state], __stateDesc[state]);
    _state = state;
    
    switch (self.state) {
        case kFMRefleshStateNone:
            [self.topRefleshView refleshFinished];
            break;
        case kFMRefleshStatePossible:
            [self.topRefleshView pullToReflesh];
            break;
        case kFMRefleshStateReleaseToReflesh:
            [self.topRefleshView releaseToReflesh];
            break;
        case kFMRefleshStateRefleshing:
            [self.topRefleshView startReflesh];
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqual:@"contentOffset"]) {
        [self scrollViewContentOffsetChanged];
        //NSLog(@"Top reflesh offset %f, presenter %f", self.scrollView.contentOffset.y, self.scrollView.layer.presentationLayer.bounds.origin.y);
    }
}

- (void)scrollViewContentOffsetChanged {
    if (!self.scrollView.dragging && !self.scrollView.decelerating) {
        return;
    }
    
    switch (self.state) {
    case kFMRefleshStateNone:
            if (self.scrollView.contentOffset.y < -self.scrollView.contentInset.top) {
                self.state = kFMRefleshStatePossible;
            }
        break;
    case kFMRefleshStatePossible:
            if (self.scrollView.contentOffset.y <= -self.refleshingToReleaseTopInset - self.scrollView.contentInset.top) {
                self.state = kFMRefleshStateReleaseToReflesh;
            }
            else if (self.scrollView.contentOffset.y >= -self.scrollView.contentInset.top) {
                self.state = kFMRefleshStateNone;
            }
        break;
    case kFMRefleshStateReleaseToReflesh:
            if (self.scrollView.decelerating) {
                self.state = kFMRefleshStateRefleshing;
                
                CGFloat presentationLayerOffsetY = self.scrollView.layer.presentationLayer.bounds.origin.y;
                
                UIEdgeInsets insets = self.scrollView.contentInset;
                insets.top += self.refleshingTopInset;
                self.scrollView.contentInset = insets;
                self.scrollView.contentOffset = CGPointMake(0, presentationLayerOffsetY);
                [self.scrollView setContentOffset:CGPointMake(0, -insets.top) animated:YES];
                
                if (self.refleshCallback) {
                    self.refleshCallback(self);
                }
            }
            else {
                if (self.scrollView.contentOffset.y > -(self.refleshingToReleaseTopInset) - self.scrollView.contentInset.top) {
                    self.state = kFMRefleshStatePossible;
                }
            }
        break;
    case kFMRefleshStateRefleshing:
        break;
    default:
        break;
    }
}

- (void)endReflesh {
    if (self.state == kFMRefleshStateRefleshing) {
        self.state = kFMRefleshStateNone;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top -= self.refleshingTopInset;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = insets;
        }];
    }
}

@end
