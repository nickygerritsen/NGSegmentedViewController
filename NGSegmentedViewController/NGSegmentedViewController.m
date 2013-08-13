//
//  NGSegmentedViewController.m
//  NGSegmentedViewController
//
//  Created by Nicky Gerritsen on 19-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import "NGSegmentedViewController.h"

#import <SDSegmentedControl/SDSegmentedControl.h>

#pragma mark Constants
const CGFloat kNGSegmentedViewControllerExtraScrollViewTopInset = 2.0f;

@interface NGSegmentedViewController ()

// Private properties
@property (nonatomic) BOOL hasAppeared;

@property (nonatomic, retain) NSMutableArray *mutableViewControllers;
@property (nonatomic, retain) NSMutableArray *mutableTitles;
@property (nonatomic, weak) UIViewController *currentViewController;

// Private methods
- (void)changeViewController;
- (void)configureScrollView:(UIViewController *)viewController;

@end

@implementation NGSegmentedViewController

#pragma mark - Public property getters
- (NSArray *)viewControllers {
    return [NSArray arrayWithArray:self.mutableViewControllers];
}

- (NSArray *)titles {
    return [NSArray arrayWithArray:self.mutableTitles];
}

- (SDSegmentedControl *)segmentedControl {
	if (!_segmentedControl) {
		_segmentedControl = [[SDSegmentedControl alloc] initWithItems:self.mutableTitles];
		_segmentedControl.selectedSegmentIndex = 0;
        
		[_segmentedControl addTarget:self action:@selector(segmentIndexChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (_animationDuration == -1) {
            _animationDuration = self.segmentedControl.animationDuration;
        }
	}
    
	return _segmentedControl;
}

#pragma mark - Private property getters
- (NSMutableArray *)mutableViewControllers {
    if (!_mutableViewControllers) {
        _mutableViewControllers = [NSMutableArray array];
    }
    return _mutableViewControllers;
}

- (NSMutableArray *)mutableTitles {
    if (!_mutableTitles) {
        _mutableTitles = [NSMutableArray array];
    }
    return _mutableTitles;
}

#pragma mark - Public property setters
// Also set the animation duration of the segmented control
- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    _animationDuration = animationDuration;
    self.segmentedControl.animationDuration = animationDuration;
}

// Can be called from outside this class, will change the view controller that is selected
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.segmentedControl.selectedSegmentIndex = selectedIndex;
    _selectedIndex = selectedIndex;
    [self changeViewController];
}

#pragma mark - Initializers
- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    return [self initWithViewControllers:viewControllers titles:[viewControllers valueForKeyPath:@"@unionOfObjects.title"]];
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles {
    self = [super init];
    
    if (self) {
        [self setupWithViewControllers:viewControllers titles:titles];
    }
    
    return self;
}

- (id)init {
    self = [self init];
    if (self) {
        [self setupWithViewControllers:nil titles:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWithViewControllers:nil titles:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupWithViewControllers:nil titles:nil];
    }
    return self;
}

#pragma mark - Public functions
- (void)setupWithViewControllers:(NSArray *)viewControllers {
    [self setupWithViewControllers:viewControllers titles:[viewControllers valueForKeyPath:@"@unionOfObjects.title"]];
}

- (void)setupWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles {
    _mutableViewControllers = [NSMutableArray array];
    _mutableTitles = [NSMutableArray array];
    
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIViewController class]] && idx < [titles count]) {
            UIViewController *viewController = obj;
            
            if ([viewController respondsToSelector:@selector(setSegmentedViewController:)]) {
                [viewController performSelector:@selector(setSegmentedViewController:) withObject:self];
            }
            
            [_mutableViewControllers addObject:viewController];
            [_mutableTitles addObject:titles[idx]];
        }
    }];
    
    _animationDuration = -1;
    _extraScrollViewTopInset = kNGSegmentedViewControllerExtraScrollViewTopInset;
}

- (void)addViewController:(UIViewController *)viewController {
    [self addViewController:viewController withTitle:viewController.title];
}

- (void)addViewController:(UIViewController *)viewController withTitle:(NSString *)title {
    if ([viewController respondsToSelector:@selector(setSegmentedViewController:)]) {
        [viewController performSelector:@selector(setSegmentedViewController:) withObject:self];
    }
    
    [_mutableViewControllers addObject:viewController];
    [_mutableTitles addObject:title];
    
    [self.segmentedControl insertSegmentWithTitle:title atIndex:self.segmentedControl.numberOfSegments animated:YES];
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
    [self insertViewController:viewController atIndex:index withTitle:viewController.title];
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index withTitle:(NSString *)title {
    if ([viewController respondsToSelector:@selector(setSegmentedViewController:)]) {
        [viewController performSelector:@selector(setSegmentedViewController:) withObject:self];
    }
    
    [_mutableViewControllers insertObject:viewController atIndex:index];
    [_mutableTitles insertObject:title atIndex:index];
    
    [self.segmentedControl insertSegmentWithTitle:title atIndex:index animated:YES];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index {
    if (index >= self.viewControllers.count) {
        NSString *reason = [NSString stringWithFormat:@"Trying to remove view controller at index %d, while only %d view controllers exist",
                            index, self.viewControllers.count];
        [[NSException exceptionWithName:@"NGSegmentedViewController: index out of range"
                                 reason:reason
                               userInfo:nil] raise];
    } else if (self.viewControllers.count == 1) {
        NSString *reason = @"Trying to remove the last view controller, which is not allowed";
        [[NSException exceptionWithName:@"NGSegmentedViewController: too few view controllers"
                                 reason:reason
                               userInfo:nil] raise];
    }
    if (index == self.segmentedControl.selectedSegmentIndex) {
        // This is the currently selected index, select another one
        if (index == 0) {
            self.selectedIndex = 1;
        } else {
            self.selectedIndex = 0;
        }
    }
    [self.segmentedControl removeSegmentAtIndex:index animated:YES];
    [_mutableViewControllers removeObjectAtIndex:index];
    [_mutableTitles removeObjectAtIndex:index];
}

- (void)removeViewController:(UIViewController *)viewController {
    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
    if (controllerIndex != NSNotFound) {
        [self removeViewControllerAtIndex:controllerIndex];
    }
}

- (void)removeViewControllerWithTitle:(NSString *)title {
    NSUInteger titleIndex = [self.titles indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([title isEqualToString:obj]) {
            (*stop) = YES;
            return YES;
        }
        return NO;
    }];
    if (titleIndex != NSNotFound) {
        [self removeViewControllerAtIndex:titleIndex];
    }
}

- (void)setImage:(UIImage *)image forViewControllerAtIndex:(NSUInteger)index {
    if (index >= self.viewControllers.count) {
        NSString *reason = [NSString stringWithFormat:@"Trying to remove view controller at index %d, while only %d view controllers exist",
                            index, self.viewControllers.count];
        [[NSException exceptionWithName:@"NGSegmentedViewController: index out of range"
                                 reason:reason
                               userInfo:nil] raise];
    }
    [self.segmentedControl setImage:image forSegmentAtIndex:index];
}

- (void)setImage:(UIImage *)image forViewController:(UIViewController *)viewController {
    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
    if (controllerIndex != NSNotFound) {
        [self setImage:image forViewControllerAtIndex:controllerIndex];
    }
}

- (void)setImage:(UIImage *)image forViewControllerWithTitle:(NSString *)title {
    NSUInteger titleIndex = [self.titles indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([title isEqualToString:obj]) {
            (*stop) = YES;
            return YES;
        }
        return NO;
    }];
    if (titleIndex != NSNotFound) {
        [self setImage:image forViewControllerAtIndex:titleIndex];
    }
}

- (void)setTitle:(NSString *)title forViewControllerAtIndex:(NSUInteger)index {
    if (index >= self.viewControllers.count) {
        NSString *reason = [NSString stringWithFormat:@"Trying to remove view controller at index %d, while only %d view controllers exist",
                            index, self.viewControllers.count];
        [[NSException exceptionWithName:@"NGSegmentedViewController: index out of range"
                                 reason:reason
                               userInfo:nil] raise];
    }
    [_mutableTitles replaceObjectAtIndex:index withObject:title];
    [self.segmentedControl setTitle:title forSegmentAtIndex:index];
}

- (void)setTitle:(NSString *)title forViewController:(UIViewController *)viewController {
    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
    if (controllerIndex != NSNotFound) {
        [self setTitle:title forViewControllerAtIndex:controllerIndex];
    }
}

- (void)setTitle:(NSString *)title forViewControllerWithTitle:(NSString *)currentTitle {
    NSUInteger titleIndex = [self.titles indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([currentTitle isEqualToString:obj]) {
            (*stop) = YES;
            return YES;
        }
        return NO;
    }];
    if (titleIndex != NSNotFound) {
        [self setTitle:title forViewControllerAtIndex:titleIndex];
    }
}

#pragma mark - View lifecycle methods
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.hasAppeared) {
        if (self.viewControllers.count == 0) {
            NSString *reason = @"viewWillAppear: called while no child view controllers exist yet. If instantiating from a NIB, override awakeFromNib: and call setupWithViewControllers:titles: to setup view controllers";
            [[NSException exceptionWithName:@"NGSegmentedViewController: too few view controllers"
                                     reason:reason
                                   userInfo:nil] raise];
        }
        
        self.hasAppeared = YES;
        
        CGRect segmentFrame = self.segmentedControl.frame;
        segmentFrame.size.width = self.view.bounds.size.width;
        segmentFrame.origin = self.view.bounds.origin;
        self.segmentedControl.frame = segmentFrame;
        [self.view addSubview:self.segmentedControl];
        
        UIViewController *currentViewController = self.viewControllers[self.selectedIndex];
        [self configureScrollView:currentViewController];
        
        [self addChildViewController:currentViewController];
        
        currentViewController.view.frame = self.view.bounds;
        currentViewController.view.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view insertSubview:currentViewController.view belowSubview:self.segmentedControl];
        
        [currentViewController didMoveToParentViewController:self];
        
        self.currentViewController = currentViewController;
    }
}

#pragma mark - Internal actions
// Called when the user taps on a segment in the segmented control
- (void)segmentIndexChanged:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == -1) {
        self.segmentedControl.selectedSegmentIndex = 0;
        _selectedIndex = 0;
    } else {
        _selectedIndex = self.segmentedControl.selectedSegmentIndex;
    }
    [self changeViewController];
}

#pragma mark - Private functions
- (void)changeViewController {
    // Swap view controllers using the containment view controller animation methods
    UIViewController *currentViewController = self.currentViewController;
    UIViewController *newViewController = self.viewControllers[self.selectedIndex];

    // If we change to the view controller we're already on, do not do anything
    if (currentViewController != newViewController) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedViewController:willChangeToIndex:)]) {
            [self.delegate segmentedViewController:self willChangeToIndex:self.selectedIndex];
        }
        
        [currentViewController willMoveToParentViewController:nil];
        [self addChildViewController:newViewController];
        [self configureScrollView:newViewController];
        
        // Determine which view controller has the higher index, to decide whether to animate
        // to the right or to the left
        NSUInteger currentIndex = [self.viewControllers indexOfObject:currentViewController];
        
        int newMultiplier;
        int oldEndMultiplier;
        
        if (currentIndex < self.selectedIndex) {
            newMultiplier = 1;
            oldEndMultiplier = -1;
        } else {
            newMultiplier = -1;
            oldEndMultiplier = 1;
        }
        CGRect newFrame = CGRectMake(newMultiplier * self.view.bounds.size.width,
                                     0,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
        CGRect oldEndFrame = CGRectMake(oldEndMultiplier * self.view.bounds.size.width,
                                        0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height);
        
        newViewController.view.frame = newFrame;
        newViewController.view.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self transitionFromViewController:currentViewController
                          toViewController:newViewController
                                  duration:self.animationDuration
                                   options:0
                                animations:^{
                                    [self.view bringSubviewToFront:self.segmentedControl];
                                    newViewController.view.frame = currentViewController.view.frame;
                                    currentViewController.view.frame = oldEndFrame;
                                } completion:^(BOOL finished) {
                                    [currentViewController removeFromParentViewController];
                                    [newViewController didMoveToParentViewController:self];
                                    
                                    self.currentViewController = newViewController;
                                    
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedViewController:didChangeToIndex:)]) {
                                        [self.delegate segmentedViewController:self didChangeToIndex:self.selectedIndex];
                                    }
                                }];
    }
}

// When the view controller is a table or collection view controller, we modify the top inset to accomodate for the segmented control
- (void)configureScrollView:(UIViewController *)viewController {
    UIScrollView *scrollView;
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tableViewController = (UITableViewController *)viewController;
        scrollView = tableViewController.tableView;
    } else if ([viewController isKindOfClass:[UICollectionViewController class]]) {
        UICollectionViewController *collectionViewController = (UICollectionViewController *)viewController;
        scrollView = collectionViewController.collectionView;
    }
    
    if (scrollView) {
        UIEdgeInsets contentInsets = scrollView.contentInset;
        contentInsets.top = MAX(contentInsets.top, self.segmentedControl.frame.size.height + self.extraScrollViewTopInset);
        scrollView.contentInset = contentInsets;
        
        UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
        scrollIndicatorInsets.top = MAX(scrollIndicatorInsets.top, self.segmentedControl.frame.size.height + self.extraScrollViewTopInset);
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    }
}

@end
