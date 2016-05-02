//
//  WBPluginsIpaExporter.m
//  WBXPlugins
//
//  Created by jun on 5/1/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBPluginsIpaExporter.h"
#import "IDEArchive.h"
#import "IDEArchivesViewController+IpaExporter.h"

@interface WBPluginsIpaExporter ()

@property (nonatomic, strong) NSMenuItem *exportMenuItem;

@end

@implementation WBPluginsIpaExporter

- (instancetype)init
{
    if (self = [super init]) {
        [NSClassFromString(@"IDEArchivesViewController") hookIpaExporter];
    }
    return self;
}

- (NSMenuItem *)exportMenuItem
{
    if (_exportMenuItem == nil) {
        
        NSMenu *ipaMenu = [[NSMenu alloc] initWithTitle:@"WBIpaExporter"];
        
        NSMenuItem *menuItem0 = [[NSMenuItem alloc] init];
        menuItem0.title = @"Export to desktop";
        menuItem0.target = nil;
        menuItem0.action = @selector(doMenuAction0);
        [ipaMenu addItem:menuItem0];
        
        NSMenuItem *menuItem1 = [[NSMenuItem alloc] init];
        menuItem1.title = @"Export to OTA";
        menuItem1.target = nil;
        menuItem1.action = @selector(doMenuAction1);
        [ipaMenu addItem:menuItem1];
        
        NSMenuItem *ipaMenuItem = [[NSMenuItem alloc] init];
        ipaMenuItem.title = @"WBIpaExporter";
        [ipaMenuItem setSubmenu:ipaMenu];
        
        _exportMenuItem = ipaMenuItem;
    }
    return _exportMenuItem;
}

- (void)setEnableExportMenuItem:(BOOL)enableExportMenuItem
{
    _enableExportMenuItem = enableExportMenuItem;
    NSArray *items = self.exportMenuItem.submenu.itemArray;
    if (enableExportMenuItem) {
        for (NSMenuItem *item in items) {
            item.target = self;
        }
    } else {
        for (NSMenuItem *item in items) {
            item.target = nil;
        }
    }
}

- (void)doMenuAction0
{
    [self exportIpaForDesktop:YES];
}

- (void)doMenuAction1
{
    [self exportIpaForDesktop:NO];
}

- (void) exportIpaForDesktop:(BOOL)isDesktop
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ExportIpaNotification
                                                        object:@(isDesktop)];
}

- (NSMenuItem *) pluginMenuItem
{
    return self.exportMenuItem;
}

@end
