//
//  WBXPlugins.h
//  WBXPlugins
//
//  Created by jun on 4/30/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import <AppKit/AppKit.h>

@class WBXPlugins;

static WBXPlugins *sharedPlugin;

@interface WBXPlugins : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end