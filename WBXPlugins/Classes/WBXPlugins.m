//
//  WBXPlugins.m
//  WBXPlugins
//
//  Created by jun on 4/30/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBXPlugins.h"
#import "WBPluginsManager.h"

@interface WBXPlugins()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation WBXPlugins

+ (instancetype)sharedPlugins
{
    return sharedPlugins;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    [self setupPlugins];
}

- (void) setupPlugins
{
    [WBPluginsManager launchPluginsFromBundle:self.bundle];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
