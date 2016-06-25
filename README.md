# Top Reflesh Control
![License](https://img.shields.io/cocoapods/l/TWPhotoPicker.svg)
![Platform](https://img.shields.io/cocoapods/p/TWPhotoPicker.svg)

A simple top reflesh control for scrollview/tableview.

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your `Podfile`.

```
pod 'FMTopReflesh'
```

and run `pod install`, then you're all done!

## How to use

```
    self.refleshControl = [[FMTopRefleshControl alloc] initWithScrollView:v withRefleshCallback:^(FMTopRefleshControl *control) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [control endReflesh];
        });
    } withTopView:[[CustomTopRefleshView alloc] initWithFrame:[UIScreen mainScreen].bounds]];

```

## Requirements

* iOS 7.0+ 
* ARC