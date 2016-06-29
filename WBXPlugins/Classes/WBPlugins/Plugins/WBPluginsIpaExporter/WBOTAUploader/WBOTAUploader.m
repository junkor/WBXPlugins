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

+ (NSString * _Nonnull) OTABaseUrl
{
    return @"http://ota.client.weibo.cn/ios";
}

+ (NSString * _Nonnull) OTAUploadUrl;
{
    return [NSString stringWithFormat:@"%@/upload",[self OTABaseUrl]];
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
       appBundleID:(NSString *)appBundleID
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

    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath] == NO) {
        if (failure) {
            failure(nil,[NSError errorWithDomain:@"ipa生成失败，请重试。" code:10001 userInfo:nil]);
        }
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (appBundleID) {
        [paramDic setObject:appBundleID forKey:@"app_bundle_id"];
    }
    if (bundleID) {
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
    NSURLSessionDataTask *dataTask = [manager POST:[self OTAUploadUrl] parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        // 因为是网页的form，成功和失败都会返回状态码200，需要check返回回来的html内容找是否出错
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSString *htmlResult = [[NSString alloc] initWithData:(NSData *)responseObject
                                                         encoding:NSUTF8StringEncoding];
            // 错误信息会出现在li标签里 <li class="error">该APP中已经存在相同Version的Package</li>
            NSRange range = [htmlResult rangeOfString:@"<li class=\"error\">.*</li>" options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                NSString *errHtmlMsg = [htmlResult substringWithRange:range];
                if (errHtmlMsg.length > 23) {
                    errHtmlMsg = [errHtmlMsg substringWithRange:(NSRange){18,errHtmlMsg.length-23}];
                    errHtmlMsg = [errHtmlMsg stringByReplacingOccurrencesOfString:@"Version" withString:@"名称"];
                }
                if (failure) {
                    failure(task,[NSError errorWithDomain:errHtmlMsg code:10001 userInfo:nil]);
                }
                return;
            }
        }
        
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
    
    NSString *app_bundle_id = archiveInfo.bundleID;
    // app_bundle_id主要用于应用分类。微博Inhouse包也归类于微博
    if ([app_bundle_id isEqualToString:@"com.sina.weibo.inhouse"]) {
        app_bundle_id = @"com.sina.weibo";
    }
    archiveInfo.app_bundle_id = app_bundle_id;
    
    [self uploadIpa:archiveInfo.ipaPath
           bundleID:archiveInfo.bundleID
        appBundleID:archiveInfo.app_bundle_id
               name:name
               desc:archiveInfo.formDesc
            pkgType:WBEPKG_TYPE_Temp
           progress:uploadProgress
            success:success
            failure:failure];
}

@end
