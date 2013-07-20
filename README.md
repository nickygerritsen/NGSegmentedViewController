# NGSegmentedViewController: A segmented view controller

UIViewController subclass using SDSegmentedControl and View Controller Containment API's to switch between child view controllers

[![NGSegmentedViewController](https://raw.github.com/nickygerritsen/NGSegmentedViewController/master/screenshot%20and%20video/NGSegmentedViewController.png)](https://raw.github.com/nickygerritsen/NGSegmentedViewController/master/screenshot%20and%20video/NGSegmentedViewController.mov)

(click to download a video of the controller in action).

## Features

- Uses View Controller Containment API's to display a list of view controllers
- Uses the excellent [SDSegmentedControl](http://github.com/rs/SDSegmentedControl) to display a view controller switcher at the top
- Can be used with code and Interface Builder
- Can be used with Autolayout
- When using `UITableView`'s or `UICollectionView`'s automatically adjusts `contentInset` and `scrollIndicatorInsets` to accomodate for segmented control

## Requirements

- ARC
- Xcode 4.4+ (needed for modern Objective-C syntax)
- iOS 6+

## Installation

### From CocoaPods

Add `pod 'NGSegmentedViewController'` to your Podfile.

### Manually

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `NGSegmentedViewController.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `NGSegmentedViewController/NGSegmentedViewController` folder into your project
* Download [SDSegmentedControl](http://github.com/rs/SDSegmentedControl) and drag `SDSegmentedControl.{h,m}` into your project
* Add the **QuartzCore** framework to your project
* You might need to change the `#import <SDSegmentedControl/SDSegmentedControl.h>` in `NGSegmentedViewController.h` to `#import "SDSegmentedControl.h"`

## Demos

I have added two demos. `NGSegmentedViewController example` uses code to set up a segmented view controller and `NGSegmentedViewController IB example` uses Interface Builder to set one up.

## Note

As this is my first open source iOS control, it is possible that I made mistakes. Furthermore, I only implemented features that seemed useful to me. If you find any errors or want extra features, feel free to fork this project and sent in a Pull Request.

## Usage

Instantiate a segmented view controller with `initWithViewControllers:` or `initWithViewControllers:titles:`.

When using Interface Builder, create a subclass and overwrite `awakeFromNib` to call `setupWithViewControllers:` or `setupWithViewControllers:titles:`.

## License and copyright

All source code is licensed under the [MIT-License](https://raw.github.com/nickygerritsen/NGSegmentedViewController/master/LICENSE).

Copyright 2013 Nicky Gerritsen.

## Authors

- Nicky Gerritsen (<nickygerritsen@me.com>)