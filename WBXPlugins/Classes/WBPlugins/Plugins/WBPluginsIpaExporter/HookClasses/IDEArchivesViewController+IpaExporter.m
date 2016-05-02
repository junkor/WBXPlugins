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

#import "WBProgressViewController.h"
#import "WBOTAUploadViewController.h"
#import "WBOTAUploader.h"


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

- (WBProgressViewController *) progressViewController
{
    NSBundle *pluginBundle = [NSBundle bundleWithIdentifier:@"com.sina.WBXPlugins"];
    if (pluginBundle) {
        WBProgressViewController *controller = [[WBProgressViewController alloc] initWithNibName:@"WBProgressViewController" bundle:pluginBundle];
        return controller;
    }
    return nil;
}

- (WBOTAUploadViewController *) uploadViewController
{
    NSBundle *pluginBundle = [NSBundle bundleWithIdentifier:@"com.sina.WBXPlugins"];
    if (pluginBundle) {
        WBOTAUploadViewController *controller = [[WBOTAUploadViewController alloc] initWithNibName:@"WBOTAUploadViewController" bundle:pluginBundle];
        return controller;
    }
    return nil;
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
    if (isForDesktop) {
        [self exportIpaToDesktop:archInfo];
    }else{
        [self exportIpaToOTA:archInfo];
    }
}

- (void) exportIpaToDesktop:(WBArchiveInfo *)archInfo
{
    WBProgressViewController * controller = [self progressViewController];
    [controller beginIndeterminate];
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"generating ipa now, hold on...";
    alert.accessoryView = controller.view;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [archInfo generateIpa];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert.accessoryView removeFromSuperview];
            alert.accessoryView = nil;
            alert.messageText = [NSString stringWithFormat:@"%@ \nis on desktop now.", archInfo.ipaName];
            [alert layout];
        });
    });
    
    NSView *contentView = [self valueForKey:@"view"];
    NSWindow *window = contentView.window;
    [alert beginSheetModalForWindow:window completionHandler:nil];
}

- (void) exportIpaToOTA:(WBArchiveInfo *)archInfo
{
    WBProgressViewController * progressController = [self progressViewController];
    [progressController beginIndeterminate];
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"正在创建ipa, 稍后...";
    alert.accessoryView = progressController.view;
    [alert addButtonWithTitle:@"Cancel"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [archInfo generateIpa];
        [progressController endIndeterminate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WBOTAUploadViewController *uploadController = [self uploadViewController];
            alert.messageText = @"请填写相关的包信息";
            [alert.accessoryView removeFromSuperview];
            alert.accessoryView = uploadController.view;
            [alert layout];
            
            // 先添加到界面上，再填充内容
            [uploadController resetFormInfoForArchInfo:archInfo];
            [uploadController setUploadBlock:^(NSString *name, NSString *desc) {
                archInfo.formName = name;
                archInfo.formDesc = desc;
                
                // 修改为上传进度条
                [alert.accessoryView removeFromSuperview];
                alert.accessoryView = progressController.view;
                [alert layout];
                
                [WBOTAUploader uploadArchive:archInfo
                                    progress:^(NSProgress * _Nonnull progress) {
                                        [progressController updateStateWithProgress:progress];
                                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                        [alert.accessoryView removeFromSuperview];
                                        alert.accessoryView = nil;
                                        alert.messageText = @"ipa已成功上传OTA";
                                        [alert layout];
                                        NSButton *button = alert.buttons.firstObject;
                                        [button setTitle:@"OK"];
                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                        [alert.accessoryView removeFromSuperview];
                                        alert.accessoryView = nil;
                                        alert.messageText = error.description;
                                        [alert layout];
                                        NSButton *button = alert.buttons.firstObject;
                                        [button setTitle:@"OK"];
                                    }];
            }];
        });
    });
    NSView *contentView = [self valueForKey:@"view"];
    NSWindow *window = contentView.window;
    [alert beginSheetModalForWindow:window completionHandler:nil];
}




@end
