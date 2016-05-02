//
//  WBPlugin.m
//  WBXPlugins
//
//  Created by jun on 5/1/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBPlugin.h"

@implementation WBPlugin

+ (instancetype)sharedPlugin
{
    static WBPlugin *plugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plugin = [[[self class] alloc] init];
    });
    return plugin;
}

- (NSMenuItem *) pluginMenuItem
{
    return nil;
}

@end
