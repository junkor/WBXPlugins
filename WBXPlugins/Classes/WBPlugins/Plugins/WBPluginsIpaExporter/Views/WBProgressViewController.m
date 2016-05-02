//
//  WBProgressViewController.m
//  WBXPlugins
//
//  Created by jun on 5/2/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBProgressViewController.h"

@interface WBProgressViewController ()

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end

@implementation WBProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) beginIndeterminate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressIndicator.indeterminate = YES;
        [self.progressIndicator startAnimation:nil];
    });
}

- (void) endIndeterminate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressIndicator.indeterminate = NO;
        [self.progressIndicator stopAnimation:nil];
    });
}

- (void) updateStateWithProgress:(NSProgress *)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        float completed = progress.fractionCompleted;
        [self.progressIndicator setDoubleValue:completed];
    });
}

@end
