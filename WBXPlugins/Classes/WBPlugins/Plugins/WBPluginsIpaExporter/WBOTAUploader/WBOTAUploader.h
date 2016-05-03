//
//  WBOTAUploader.h
//  WBXPlugins
//
//  Created by jun on 5/1/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WBEPKG_TYPE_Formal      = 0,
    WBEPKG_TYPE_Temp        = 1,
    WBEPKG_TYPE_Channel     = 2,
    WBEPKG_TYPE_daily       = 3,
    WBEPKG_TYPE_AppStore    = 99,
} WBEPKG_TYPE;

@class WBArchiveInfo;
@interface WBOTAUploader : NSObject

+ (NSString * _Nonnull) OTABaseUrl;

+ (NSString * _Nonnull) OTAUploadUrl;

+ (void) uploadArchive:(WBArchiveInfo * _Nonnull)archiveInfo
              progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
               success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

@end
