//
//  NGSegmentedViewController.m
//  NGSegmentedViewController
//
//  Created by Nicky Gerritsen on 19-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import "NGSegmentedViewController.h"

#import <SDSegmentedControl/SDSegmentedControl.h>

@interface NGSegmentedViewController ()

@property (nonatomic) BOOL hasAppeared;

@property (nonatomic, retain) NSMutableArray *mutableViewControllers;
@property (nonatomic, retain) NSMutableArray *mutableTitles;
@property (nonatomic, weak) UIViewController *currentViewController;

// Private methods
- (void)changeViewController;
- (void)configureScrollView:(UIViewController *)viewController;

@end

@implementation NGSegmentedViewController

#pragma mark Public property getters
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

#pragma mark Private property getters
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

#pragma mark Public property setters
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

#pragma mark -
#pragma mark Initializers
- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    return [self initWithViewControllers:viewControllers titles:[viewControllers valueForKeyPath:@"@unionOfObjects.title"]];
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles {
    self = [super init];
    
    _mutableViewControllers = [NSMutableArray array];
    _mutableTitles = [NSMutableArray array];
    
    if (self) {
        [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIViewController class]] && idx < [titles count]) {
                UIViewController *viewController = obj;
                
                [_mutableViewControllers addObject:viewController];
                [_mutableTitles addObject:titles[idx]];
            }
        }];
        
        _animationDuration = -1;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public functions
- (void)addViewController:(UIViewController *)viewController {
    [self addViewController:viewController title:viewController.title];
}

- (void)addViewController:(UIViewController *)viewController title:(NSString *)title {
    [_mutableViewControllers addObject:viewController];
    [_mutableTitles addObject:title];
    
    [self.segmentedControl insertSegmentWithTitle:title atIndex:self.segmentedControl.numberOfSegments animated:YES];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index {
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

#pragma mark -
#pragma mark View lifecycle methods
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.hasAppeared) {
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
        [self.view insertSubview:currentViewController.view belowSubview:self.segmentedControl];
        
        [currentViewController didMoveToParentViewController:self];
        
        self.currentViewController = currentViewController;
    }
}

#pragma mark -
#pragma mark Internal actions
// Called when the user taps on a segment in the segmented control
- (void)segmentIndexChanged:(id)sender {
    _selectedIndex = self.segmentedControl.selectedSegmentIndex;
    [self changeViewController];
}

#pragma mark Private functions
- (void)changeViewController {
    // Swap view controllers using the containment view controller animation methods
    UIViewController *currentViewController = self.currentViewController;
    UIViewController *newViewController = self.viewControllers[self.selectedIndex];
    if (currentViewController != newViewController) {
        [currentViewController willMoveToParentViewController:nil];
        [self addChildViewController:newViewController];
        [self configureScrollView:newViewController];
        
        // Determine with view controller has the higher index
        NSUInteger currentIndex = [self.viewControllers indexOfObject:currentViewController];
        
        int newMultiplier;
        int oldEndMultiplier;
        
        if (currentIndex < self.selectedIndex) {
            newMultiplier = 2;
            oldEndMultiplier = -1;
        } else {
            newMultiplier = -1;
            oldEndMultiplier = 2;
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
                                }];
    }
}

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
        contentInsets.top = MAX(contentInsets.top, self.segmentedControl.frame.size.height);
        scrollView.contentInset = contentInsets;
        
        UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
        scrollIndicatorInsets.top = MAX(scrollIndicatorInsets.top, self.segmentedControl.frame.size.height);
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    }
}

@end
