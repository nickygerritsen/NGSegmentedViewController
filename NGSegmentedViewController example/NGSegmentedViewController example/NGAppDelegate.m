//
//  NGAppDelegate.m
//  NGSegmentedViewController example
//
//  Created by Nicky Gerritsen on 19-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import "NGAppDelegate.h"

#import "NGSegmentedViewController.h"
#import "NGExampleTableViewController.h"
#import "NGExampleCollectionViewController.h"

@implementation NGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *redViewController = [[UIViewController alloc] init];
    redViewController.view.backgroundColor = [UIColor redColor];
    redViewController.title = @"Red";
        
    UIViewController *greenViewController = [[UIViewController alloc] init];
    greenViewController.view.backgroundColor = [UIColor greenColor];
    greenViewController.title = @"Green";
    
    UIViewController *blueViewController = [[UIViewController alloc] init];
    blueViewController.view.backgroundColor = [UIColor blueColor];
    blueViewController.title = @"Blue";
    
    NGExampleTableViewController *tableViewController = [[NGExampleTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tableViewController.title = @"Table view";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    NGExampleCollectionViewController *collectionViewController = [[NGExampleCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    collectionViewController.title = @"Collection view";
    
    NSArray *viewControllers = @[redViewController, greenViewController, blueViewController, tableViewController, collectionViewController];
    
    NGSegmentedViewController *rootViewController = [[NGSegmentedViewController alloc] initWithViewControllers:viewControllers];

    [rootViewController setImage:[UIImage imageNamed:@"clock"] forViewControllerWithTitle:@"Blue"];
    [rootViewController setTitle:@"Clock" forViewControllerWithTitle:@"Blue"];

    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
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
    [rootViewController removeViewControllerAtIndex:2];
}

@end
