//
//  NGSegmentedViewController.h
//  NGSegmentedViewController
//
//  Created by Nicky Gerritsen on 19-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 `NGSegmentedViewController` is a view controller that uses the View Controller Containment API's and SDSegmentedControl to show a set of view controllers with a segmented control at the top to switch between them. Switching between view controllers happens using animations.
 
 Each view controller can have a title and an image to be used in the segmented control.
 
 This class works both using code and using Interface Builder.
 
 ## Notes when using Interface Builder
 
 When using Interface Builder, one can not call the designated initializer `initWithViewControllers:titles:` (or `initWithViewControllers:`). Therefore, you should make sure that you call `setupWithViewControllers:titles:` (or `setupWithViewControllers:`) yourself before `viewWillAppear:` is called. A good place to do this is in `awakeFromNib`.
 
 ## Notes on view controllers that are added
 
 If your added `UIViewController` implements `setSegmentedViewController:`, we will call this method as soon as you add the view controller. This can be useful to call functions on the segmented view controller again.
 
 A good way to make sure this function exists, is to define a property:
 
    @property (nonatomic, weak) NGSegmentedViewController *segmentedViewController;
 
 Please make sure this property is weak, as otherwise a retain cycle will occur.
 
 ## Notes on scroll views
 
 If a view controller is a `UITableViewController` or `UICollectionViewController`, we will automatically adjust it's `contentInset` and `scrollIndicatorInsets` to accomodate for the segmented control. We will add a little extra spacing (as specified by `extraScrollViewTopInset` to this to make it visually more appealing.
 
 For other view controllers and / or other scroll views, it is your task to make sure to not place anything under the segmented control. You can use the `frame.size.height` of the `segmentedControl` and `extraScrollViewTopInset` to accomplish this.
 */

@class SDSegmentedControl;

@interface NGSegmentedViewController : UIViewController

///---------------------------------------
/// @name Accessing subviews
///---------------------------------------

/**
 The `SDSegmentedControl` used.
 
 To fetch the current image of a segment, use this property to access them.
 */
@property (nonatomic, retain) SDSegmentedControl *segmentedControl;

/**
 The view controllers currently being managed by this controller.
 */
@property (nonatomic, readonly) NSArray *viewControllers;

///---------------------------------------
/// @name Accessing segment titles
///---------------------------------------

/**
 The titles of the segments currently being used.
 */
@property (nonatomic, readonly) NSArray *titles;

///---------------------------------------
/// @name Querying and selecting child view controllers
///---------------------------------------

/**
 The currently selected view controller index.
 
 @warning Do not try to select an index higher than or equal to `viewControllers.count`! This will raise an exception.
 */
@property (nonatomic) NSInteger selectedIndex;

///---------------------------------------
/// @name Changing appearance information
///---------------------------------------

/**
 The duration of the animiation to switch between view controllers.
 
 Defaults to `segmentedControl.animationDuration`.
 */
@property (nonatomic, assign) CFTimeInterval animationDuration;

/**
 Extra inset to add to the top of scroll views and scroll indicators. Defaults to `2.0f`.
 */
@property (nonatomic, assign) CGFloat extraScrollViewTopInset;

///---------------------------------------
/// @name Creating, initializing and setting up a segmented view controller
///---------------------------------------

/**
 Creates and initializes aa `NGSegmentedViewController` object with the specified view controllers.
 
 @param viewControllers Array of `UIViewController`'s to use as childs. Needs to have valid `title`'s.
 
 @return The newly-initialized segmented view controller.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

/**
 Creates and initializes aa `NGSegmentedViewController` object with the specified view controllers.
 
 @param viewControllers Array of `UIViewController`'s to use as childs.
 @param titles Array of `NSString`'s to use as titles.
 
 @return The newly-initialized segmented view controller.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;

/**
 Sets up this segmented view controller with the given view controllers.
 
 @param viewControllers Array of `UIViewController`'s to use as childs. Needs to have valid `title`'s.
 
 @warning Only call this function if you did not call `initWithViewControllers:titles:` or `initWithViewControllers:`! These functions call this function internally.
 */
- (void)setupWithViewControllers:(NSArray *)viewControllers;

/**
 Sets up this segmented view controller with the given view controllers.
 
 @param viewControllers Array of `UIViewController`'s to use as childs.
 @param titles Array of `NSString`'s to use as titles.
 
 @warning Only call this function if you did not call `initWithViewControllers:titles:` or `initWithViewControllers:`! These functions call this function internally.
 */
- (void)setupWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;

///---------------------------------------
/// @name Adding or removing child view controllers
///---------------------------------------

/**
 Adds a view controller as the last child view controller.
 
 @param viewController The view controller to add. Needs to have a valid `title`.
 */
- (void)addViewController:(UIViewController *)viewController;

/**
 Adds a view controller as the last child view controller
 
 @param viewController The view controller to add.
 @param title The title for the new view controller.
 */
- (void)addViewController:(UIViewController *)viewController withTitle:(NSString *)title;

/**
 Inserts a view controller at the given position.
 
 @param viewController The view controller to add. Needs to have a valid `title`.
 @param index The index to insert this view controller at. Should be at least `0` and at most `viewControllers.count`.
 */
- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;

/**
 Inserts a view controller at the given position.
 
 @param viewController The view controller to add.
 @param title The title for the new view controller.
 @param index The index to insert this view controller at. Should be at least `0` and at most `viewControllers.count`.
 */
- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index withTitle:(NSString *)title;

/**
 Removes the view controller at the given index.
 
 @param index The index of the view controller to remove. Should be at least `0` and at most `viewControllers.count - 1`.
 
 @note If the view controller at `index` is currently selected, the first child view controller will be selected.
 */
- (void)removeViewControllerAtIndex:(NSUInteger)index;

/**
 Removes the given view controller.
 
 @param viewController The view controller to remove. Uses `isEqual:` to determine which view controller to remove.
 
 @note If the view controller at `index` is currently selected, the first child view controller will be selected.
 @note If the view controller is not found, nothing happens.
 */
- (void)removeViewController:(UIViewController *)viewController;

/**
 Removes the view controller corresponding to the given title.
 
 @param title The title to check. Removes view controller which has a title in the segmented control that is equal to `title`. Uses `isEqualToString:` to check.
 
 @note If the view controller at `index` is currently selected, the first child view controller will be selected.
 @note If multiple view controllers have the same title, the first one will be removed.
 @note If the title is not found, nothing happens.
 */
- (void)removeViewControllerWithTitle:(NSString *)title;

///---------------------------------------
/// @name Setting images and titles
///---------------------------------------

/**
 Sets the image of the segment at the given index.
 
 @param image The image to use. If `nil`, the image will be removed.
 @param index The index of the segment to set the image for. Should be at least `0` and at most `viewControllers.count - 1`.
 */
- (void)setImage:(UIImage *)image forViewControllerAtIndex:(NSUInteger)index;

/**
 Sets the image of the segment corresponding to the given view controller.
 
 @param image The image to use. If `nil`, the image will be removed.
 @param viewController The view controller to set the image for. Uses `isEqual:` to determine which view controller to to  use.
 
 @note If the view controller is not found, nothing happens.
 */
- (void)setImage:(UIImage *)image forViewController:(UIViewController *)viewController;

/**
 Sets the image of the segment corresponding to the given title.
 
 @param image The image to use. If `nil`, the image will be removed.
 @param title The title to check. Changes the image of the segment which has a title that is equal to `title`. Uses `isEqualToString:` to check.
 
 @note If the title is not found, nothing happens.
 */
- (void)setImage:(UIImage *)image forViewControllerWithTitle:(NSString *)title;

/**
 Sets the title of the segment at the given index.
 
 @param title The title to use. If `nil`, the title will be removed.
 @param index The index of the segment to set the title for. Should be at least `0` and at most `viewControllers.count - 1`.
 */
- (void)setTitle:(NSString *)title forViewControllerAtIndex:(NSUInteger)index;

/**
 Sets the title of the segment corresponding to the given view controller.
 
 @param title The title to use. If `nil`, the title will be removed.
 @param viewController The view controller to set the title for. Uses `isEqual:` to determine which view controller to to  use.
 
 @note If the view controller is not found, nothing happens.
 */
- (void)setTitle:(NSString *)title forViewController:(UIViewController *)viewController;

/**
 Sets the title of the segment corresponding to the given title.
 
 @param title The title to use. If `nil`, the title will be removed.
 @param currentTitle The title to check. Changes the title of the segment which has a title that is equal to `currentTitle`. Uses `isEqualToString:` to check.
 
 @note If the title is not found, nothing happens.
 */
- (void)setTitle:(NSString *)title forViewControllerWithTitle:(NSString *)currentTitle;

@end
