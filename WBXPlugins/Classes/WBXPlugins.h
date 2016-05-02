//
//  WBXPlugins.h
//  WBXPlugins
//
//  Created by jun on 4/30/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import <AppKit/AppKit.h>

@class WBXPlugins;

static WBXPlugins *sharedPlugins;

@interface WBXPlugins : NSObject

@property (nonatomic, strong, readonly) NSBundle* bundle;

+ (instancetype)sharedPlugins;
- (id)initWithBundle:(NSBundle *)plugin;

@end