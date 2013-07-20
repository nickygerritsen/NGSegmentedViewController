//
//  NGStoryBoardSegmentedViewViewController.m
//  NGSegmentedViewController IB example
//
//  Created by Nicky Gerritsen on 20-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import "NGStoryBoardSegmentedViewViewController.h"

@interface NGStoryBoardSegmentedViewViewController ()

@end

@implementation NGStoryBoardSegmentedViewViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *firstVC = [storyBoard instantiateViewControllerWithIdentifier:@"First"];
    UIViewController *tableVC = [storyBoard instantiateViewControllerWithIdentifier:@"Table"];
    
    NSArray *viewControllers = @[firstVC, tableVC];
    
    [super setupWithViewControllers:viewControllers];
}

@end
