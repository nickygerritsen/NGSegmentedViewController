//
//  NGAppDelegate.m
//  NGSegmentedViewController example
//
//  Created by Nicky Gerritsen on 19-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import "NGAppDelegate.h"

#import "NGSegmentedViewController.h"

@implementation NGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *redViewController = [[UIViewController alloc] init];
    redViewController.view.backgroundColor = [UIColor redColor];
    redViewController.title = @"Red";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, redViewController.view.bounds.size.height - 50, redViewController.view.bounds.size.width - 20, 40);
    [button setTitle:@"Add controller" forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [button addTarget:self action:@selector(addController) forControlEvents:UIControlEventTouchUpInside];
    [redViewController.view addSubview:button];
    
    UIViewController *greenViewController = [[UIViewController alloc] init];
    greenViewController.view.backgroundColor = [UIColor greenColor];
    greenViewController.title = @"Green";
    
    UIViewController *blueViewController = [[UIViewController alloc] init];
    blueViewController.view.backgroundColor = [UIColor blueColor];
    blueViewController.title = @"Blue";
    
    NSArray *viewControllers = @[redViewController, greenViewController, blueViewController];
    
    NGSegmentedViewController *rootViewController = [[NGSegmentedViewController alloc] initWithViewControllers:viewControllers];
    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)addController {
    NGSegmentedViewController *rootViewController = (NGSegmentedViewController *)self.window.rootViewController;

    UIViewController *yellowViewController = [[UIViewController alloc] init];
    yellowViewController.view.backgroundColor = [UIColor yellowColor];
    yellowViewController.title = @"Yellow";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, yellowViewController.view.bounds.size.height - 50, yellowViewController.view.bounds.size.width - 20, 40);
    [button setTitle:@"Remove this controller" forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [button addTarget:self action:@selector(removeController:) forControlEvents:UIControlEventTouchUpInside];
    [yellowViewController.view addSubview:button];
    
    [rootViewController addViewController:yellowViewController];
    rootViewController.selectedIndex = rootViewController.viewControllers.count - 1;
}

- (void)removeController:(id)sender {
    UIButton *button = sender;
    UIView *buttonSuperView = button.superview;
    NGSegmentedViewController *rootViewController = (NGSegmentedViewController *)self.window.rootViewController;
    __block NSInteger index = -1;
    [rootViewController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController = obj;
        if (viewController.view == buttonSuperView) {
            index = idx;
            (*stop) = YES;
        }
    }];
    [rootViewController removeViewControllerAtIndex:index];
}

@end
