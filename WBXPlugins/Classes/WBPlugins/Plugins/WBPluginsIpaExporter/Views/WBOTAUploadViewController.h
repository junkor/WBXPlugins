//
//  WBOTAUploadViewController.h
//  WBXPlugins
//
//  Created by jun on 5/2/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WBArchiveInfo;
@interface WBOTAUploadViewController : NSViewController

@property (nonatomic, copy) void (^uploadBlock)(NSString *name,NSString *desc);

- (void) resetFormInfoForArchInfo:(WBArchiveInfo *)archInfo;

@end
