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

@end

@implementation NGSegmentedViewController

- (NSArray *)viewControllers {
    return [NSArray arrayWithArray:self.mutableViewControllers];
}

- (NSArray *)titles {
    return [NSArray arrayWithArray:self.mutableTitles];
}

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

- (SDSegmentedControl *)segmentedControl {
	if (!_segmentedControl) {
		_segmentedControl = [[SDSegmentedControl alloc] initWithItems:self.mutableTitles];
		_segmentedControl.selectedSegmentIndex = 0;
        
		[_segmentedControl addTarget:self action:@selector(segmentIndexChanged:) forControlEvents:UIControlEventValueChanged];
	}
    
	return _segmentedControl;
}

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
        
        _selectedIndex = 0;
    }
    
    return self;
}

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
        [self addChildViewController:currentViewController];
        
        currentViewController.view.frame = self.view.bounds;
        [self.view insertSubview:currentViewController.view belowSubview:self.segmentedControl];
        
        [currentViewController didMoveToParentViewController:self];
        
        self.currentViewController = currentViewController;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.segmentedControl.selectedSegmentIndex = selectedIndex;
    _selectedIndex = selectedIndex;
    [self changeViewController];
}

- (void)segmentIndexChanged:(id)sender {
    _selectedIndex = self.segmentedControl.selectedSegmentIndex;
    [self changeViewController];
}

- (void)changeViewController {
    // Swap view controllers
    UIViewController *currentViewController = self.currentViewController;
    UIViewController *newViewController = self.viewControllers[self.selectedIndex];
    if (currentViewController != newViewController) {
        [currentViewController willMoveToParentViewController:nil];
        [self addChildViewController:newViewController];
        
        // Determine with view controller has the higher index
        NSUInteger currentIndex = [self.viewControllers indexOfObject:currentViewController];
        
        int newMultiplier = 0;
        int oldEndMultiplier = 0;
        
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
                                  duration:0.25
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

@end
