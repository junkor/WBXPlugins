//
//  WBOTAUploader.m
//  WBXPlugins
//
//  Created by jun on 5/1/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBOTAUploader.h"
#import "AFHTTPSessionManager.h"
#import "WBArchiveInfo.h"

@implementation WBOTAUploader

+ (NSString *) OTAUploadURL
{
    return @"http://10.208.88.115/ota/ios/upload";
}

/*
 *  直接抓取的上传Ipa的网页的form表单，以form形式提交
 *
 *  pkg_file        : ipa
 *  dsym_file       : Archive文件(.zip)           （忽略不传，太大了，占服务器磁盘）
 *  version         : 版本(实际上就是网页上的文件名)  （让用户填写）
 *  description     : 描述                        （让用户填写）
 *  app_bundle_id   : 包名                        （自动获取）
 *  pkg_type        : 包类型(appStore:99 正式包:0 第三方渠道包:2 开发临时测试包:1 每日构建包:3)
 */
+ (void) uploadIpa:(NSString *)filepath
          bundleID:(NSString *)bundleID
              name:(NSString *)name
              desc:(NSString *)desc
           pkgType:(WBEPKG_TYPE)pkgType
          progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (filepath == nil || bundleID == nil || name == nil) {
        return;
    }

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (bundleID) {
        NSString *app_bundle_id = bundleID;
        // app_bundle_id主要用于应用分类。微博Inhouse包也归类于微博
        if ([app_bundle_id isEqualToString:@"com.sina.weibo.inhouse"]) {
            app_bundle_id = @"com.sina.weibo";
        }
        [paramDic setObject:app_bundle_id forKey:@"app_bundle_id"];
        [paramDic setObject:bundleID forKey:@"force_bundle_id"];
    }
    if (name) {
        [paramDic setObject:name forKey:@"version"];
    }
    if (desc) {
        [paramDic setObject:desc forKey:@"description"];
    }
    [paramDic setObject:@(pkgType) forKey:@"pkg_type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 默认是Json解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager POST:[self OTAUploadURL] parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        NSURL *fileURL = [NSURL fileURLWithPath:filepath];
        if (fileURL) {
            [formData appendPartWithFileURL:fileURL name:@"pkg_file" error:&error];
            if (error && failure) {
                failure(nil,error);
            }
        }else{
            if (failure) {
                failure(nil,[NSError errorWithDomain:@"Error fileURL" code:10001 userInfo:nil]);
            }
        }
    } progress:^(NSProgress * _Nonnull progress) {
        if (uploadProgress) {
            uploadProgress(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
    [dataTask resume];
}

+ (void) uploadArchive:(WBArchiveInfo * _Nonnull)archiveInfo
              progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
               success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    if (archiveInfo == nil) {
        return;
    }
    NSString *name = archiveInfo.formName;
    if (name == nil) {
        name = archiveInfo.name;
    }
    [self uploadIpa:archiveInfo.ipaPath
           bundleID:archiveInfo.bundleID
               name:name
               desc:archiveInfo.formDesc
            pkgType:WBEPKG_TYPE_Temp
           progress:uploadProgress
            success:success
            failure:failure];
}

@end
