//
//  WBPlugin.h
//  WBXPlugins
//
//  Created by jun on 5/1/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface WBPlugin : NSObject

+ (instancetype)sharedPlugin;

- (NSMenuItem *) pluginMenuItem;

@end
