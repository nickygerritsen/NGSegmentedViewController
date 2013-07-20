//
//  NGFirstViewController.h
//  NGSegmentedViewController IB example
//
//  Created by Nicky Gerritsen on 20-07-13.
//  Copyright (c) 2013 Nicky Gerritsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGSegmentedViewController;

@interface NGFirstViewController : UIViewController
@property (nonatomic, weak) NGSegmentedViewController *segmentedViewController;

- (IBAction)removeMe:(id)sender;
- (IBAction)addDuplicate:(id)sender;

@end
