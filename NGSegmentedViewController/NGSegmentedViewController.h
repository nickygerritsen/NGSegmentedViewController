//
//  NGSegmentedViewController.h
//  NGSegmentedViewController
//
//  Created by Nicky Gerritsen on 19-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDSegmentedControl;

@interface NGSegmentedViewController : UIViewController

@property (nonatomic, retain) SDSegmentedControl *segmentedControl;
@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, readonly) NSArray *titles;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, assign) CFTimeInterval animationDuration;
@property (nonatomic, assign) CGFloat extraScrollViewTopInset;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;

- (void)setupWithViewControllers:(NSArray *)viewControllers;
- (void)setupWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;

- (void)addViewController:(UIViewController *)viewController;
- (void)addViewController:(UIViewController *)viewController withTitle:(NSString *)title;
- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index withTitle:(NSString *)title;
- (void)removeViewControllerAtIndex:(NSUInteger)index;
- (void)removeViewController:(UIViewController *)viewController;
- (void)removeViewControllerWithTitle:(NSString *)title;
- (void)setImage:(UIImage *)image forViewControllerAtIndex:(NSUInteger)index;
- (void)setImage:(UIImage *)image forViewController:(UIViewController *)viewController;
- (void)setImage:(UIImage *)image forViewControllerWithTitle:(NSString *)title;
- (void)setTitle:(NSString *)title forViewControllerAtIndex:(NSUInteger)index;
- (void)setTitle:(NSString *)title forViewController:(UIViewController *)viewController;
- (void)setTitle:(NSString *)title forViewControllerWithTitle:(NSString *)currentTitle;

@end
