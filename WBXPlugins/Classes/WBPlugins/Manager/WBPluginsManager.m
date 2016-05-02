//
//  PluginsManager.m
//  WBXPlugins
//
//  Created by jun on 5/1/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBPluginsManager.h"
#import "WBPlugin.h"

@implementation WBPluginsManager

+ (void) launchPluginsFromBundle:(NSBundle *)bundle
{
    NSMenuItem *wbPluginsMenu = [self addMainMenu];
    
    NSArray *pluginInfos = [self pluginInfosFromBundle:bundle];
    [self registPluginsWithInfos:pluginInfos withMenu:wbPluginsMenu];
}

+ (NSMenuItem *) addMainMenu
{
    NSMenu *mainMenu = [NSApp mainMenu];
    if (!mainMenu) {
        return nil;
    }
    
    // Add Plugins menu next to Window menu
    NSMenuItem *pluginsMenuItem = [mainMenu itemWithTitle:@"WBPlugins"];
    if (!pluginsMenuItem) {
        pluginsMenuItem = [[NSMenuItem alloc] init];
        pluginsMenuItem.title = @"WBPlugins";
        pluginsMenuItem.submenu = [[NSMenu alloc] initWithTitle:pluginsMenuItem.title];
        NSInteger windowIndex = [mainMenu indexOfItemWithTitle:@"Window"];
        [mainMenu insertItem:pluginsMenuItem atIndex:windowIndex];
    }
    return pluginsMenuItem;
}

/**
 *  从Plist中加载所有的插件信息 (Class; MenuItem; Order)
 *
 *  @return NSArray
 */
+ (NSArray *)pluginInfosFromBundle:(NSBundle *)bundle
{
    static NSArray * plugins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * filePath = [[bundle resourcePath] stringByAppendingPathComponent:@"WBPlugins.plist"];
        
        
        
        NSDictionary * pluginsDict = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            pluginsDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        }
        plugins = [pluginsDict objectForKey:@"plugins"];
    });
    return plugins;
}

+ (void)registPluginsWithInfos:(NSArray *)pluginInfos withMenu:(NSMenuItem *) wbpluginMenu
{
    NSLog(@" #### 1 pluginInfos : %@ ",pluginInfos);
    
    for (NSString * className in pluginInfos)
    {
        if (className == nil || className.length == 0) {
            continue;
        }
        Class class = NSClassFromString(className);
        if (class && [class isSubclassOfClass:[WBPlugin class]])
        {
            NSLog(@" #### 2 foreach class block");
            
            WBPlugin *plugin = [class performSelector:@selector(sharedPlugin)];
            
            NSLog(@" #### 3 create plugin: %@",plugin);
            
            if (plugin) {
                NSMenuItem *pluginMenuItem = [plugin pluginMenuItem];
                
                NSLog(@" #### 4 pluginMenuItem: %@",pluginMenuItem);
                
                if (pluginMenuItem) {
                    [[wbpluginMenu submenu] addItem:pluginMenuItem];
                }
            }
        }
    }
}

@end
