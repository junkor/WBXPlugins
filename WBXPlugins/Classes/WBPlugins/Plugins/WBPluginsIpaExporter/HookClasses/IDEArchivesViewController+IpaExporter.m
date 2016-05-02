//
//  IDEArchivesViewController+IpaExporter.m
//  IpaExporter
//
//  Created by Jobs on 15/11/22.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "IDEArchivesViewController+IpaExporter.h"
#import "IDEArchive.h"
#import "WBPluginsIpaExporter.h"
#import "WBArchiveInfo.h"

@implementation NSObject (IDEArchivesViewControllerIpaExporter)

+ (void)hookIpaExporter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jr_swizzleMethod:@selector(viewDidAppear)
                    withMethod:@selector(ipaExporter_viewDidAppear)
                         error:nil];
        [self jr_swizzleMethod:@selector(viewDidDisappear)
                    withMethod:@selector(ipaExporter_viewDidDisappear)
                         error:nil];
    });
}

- (void)ipaExporter_viewDidAppear
{
    [self ipaExporter_viewDidAppear];
    [WBPluginsIpaExporter sharedPlugin].enableExportMenuItem = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveExportIpaNotification:)
                                                 name:ExportIpaNotification
                                               object:nil];
}

- (void)ipaExporter_viewDidDisappear
{
    [self ipaExporter_viewDidDisappear];
    [WBPluginsIpaExporter sharedPlugin].enableExportMenuItem = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ExportIpaNotification object:nil];
}


- (void)receiveExportIpaNotification:(NSNotification *)notification
{
    BOOL isForDesktop = [notification.object boolValue];
    
    // Get the selected archive
    NSArrayController *archivesArrayController = [self valueForKey:@"_archivesArrayController"];
    IDEArchive *archive = archivesArrayController.selectedObjects.firstObject;
    if (!archive) {
        return;
    }
    
    WBArchiveInfo *archInfo = [[WBArchiveInfo alloc] initWithArchive:archive
                                                       isMoveDesktop:isForDesktop];
    [archInfo generateIpa];
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = [NSString stringWithFormat:@"%@ \nis on the desktop now.", archInfo.ipaName];
    [alert runModal];
}

@end
