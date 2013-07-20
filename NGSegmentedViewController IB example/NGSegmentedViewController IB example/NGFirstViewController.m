//
//  NGFirstViewController.m
//  NGSegmentedViewController IB example
//
//  Created by Nicky Gerritsen on 20-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import "NGFirstViewController.h"

#import "NGSegmentedViewController.h"

@interface NGFirstViewController ()

@end

@implementation NGFirstViewController

- (IBAction)removeMe:(id)sender {
    [self.segmentedViewController removeViewController:self];
}

- (IBAction)addDuplicate:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"First"];
    viewController.title = [NSString stringWithFormat:@"Controller %d", self.segmentedViewController.viewControllers.count];
    [self.segmentedViewController insertViewController:viewController atIndex:self.segmentedViewController.viewControllers.count - 1];
    self.segmentedViewController.selectedIndex = self.segmentedViewController.viewControllers.count - 2;
}
@end
