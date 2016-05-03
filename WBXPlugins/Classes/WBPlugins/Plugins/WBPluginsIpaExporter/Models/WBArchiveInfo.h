//
//  WBArchiveInfo.h
//  WBXPlugins
//
//  Created by jun on 5/2/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDEArchive;

@interface WBArchiveInfo : NSObject

@property (nonatomic,assign,readonly) BOOL isMoveToDesktop;

@property (nonatomic,strong) IDEArchive *sysArchive;
@property (nonatomic,strong) NSString *productsDirectoryPath;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ipaName;
@property (nonatomic,strong) NSDate *creationDate;

// app Info Dictionary app相关信息
@property (nonatomic,strong) NSString *shortVersionString;
@property (nonatomic,strong) NSString *bundleID;
@property (nonatomic,strong) NSString *appPath;
@property (nonatomic,strong) NSString *signingIdentity;
@property (nonatomic,strong) NSString *bundleVersion;

@property (nonatomic,strong) NSString *formName;
@property (nonatomic,strong) NSString *formDesc;

// 根据当前Archive的信息、路径，生成的创建本地ipa的shell命令
@property (nonatomic,strong,readonly) NSArray *ipaCmd;

// ipaCachePath : 生成ipa的位置，用于上传&上传成功后删除
@property (nonatomic,strong) NSString *ipaPath;

@property (nonatomic,strong) NSString *app_bundle_id;

- (instancetype) initWithArchive:(IDEArchive *)archive
                   isMoveDesktop:(BOOL)isMoveDesktop;

- (BOOL) generateIpa;
- (BOOL) cleanTmpIpa;

@end
