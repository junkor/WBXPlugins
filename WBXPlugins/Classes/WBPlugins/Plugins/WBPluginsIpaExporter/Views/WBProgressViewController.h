//
//  WBProgressViewController.h
//  WBXPlugins
//
//  Created by jun on 5/2/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WBProgressViewController : NSViewController

- (void) beginIndeterminate;
- (void) endIndeterminate;

- (void) updateStateWithProgress:(NSProgress *)progress;

@end
