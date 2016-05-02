//
//  WBArchiveInfo.m
//  WBXPlugins
//
//  Created by jun on 5/2/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBArchiveInfo.h"
#import "IDEArchive.h"

@interface WBArchiveInfo ()

@property (nonatomic,assign,readwrite) BOOL isMoveToDesktop;

@end

@implementation WBArchiveInfo

- (instancetype) initWithArchive:(IDEArchive *)archive
                   isMoveDesktop:(BOOL)isMoveDesktop
{
    if (self = [super init]) {
        
        if (archive) {
            _sysArchive = archive;
            _isMoveToDesktop = isMoveDesktop;
            [self setupInfosForArchive:archive];
        }
    }
    return self;
}

- (void) setupInfosForArchive:(IDEArchive *)archive
{
    _productsDirectoryPath = archive.productsDirectoryPath.pathString;
    _name = archive.name;
    _ipaName = [archive.name stringByAppendingString:@".ipa"];
    _creationDate = archive.creationDate;
    
    NSDictionary *appProperties = archive.infoDictionary[@"ApplicationProperties"];
    _shortVersionString = appProperties[@"CFBundleShortVersionString"];
    _bundleID = appProperties[@"CFBundleIdentifier"];
    _appPath = appProperties[@"ApplicationPath"];
    _signingIdentity = appProperties[@"SigningIdentity"];
    _bundleVersion = appProperties[@"CFBundleVersion"];
}

- (BOOL) generateIpa
{
    // Change current directory to the product path
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:self.productsDirectoryPath];
    
    // Execute terminal commands
    NSString *cmdCopy = @"cp -r Applications Payload";
    NSString *cmdZip = [NSString stringWithFormat:@"zip -r '%@' Payload", self.ipaName];
    NSString *cmdRemove = @"rm -r Payload";
    NSArray *cmds = @[cmdCopy, cmdZip, cmdRemove];
    
    if (self.isMoveToDesktop) {
        NSString *cmdMove = [NSString stringWithFormat:@"mv '%@' ~/Desktop", self.ipaName];
        cmds = @[cmdCopy, cmdZip, cmdRemove, cmdMove];
    }
    
    for (NSString *cmd in cmds) {
        system(cmd.UTF8String);
    }
    
    NSString *ipaPath = [self.productsDirectoryPath stringByAppendingFormat:@"/%@",self.ipaName];
    BOOL generateSuccess = [[NSFileManager defaultManager] fileExistsAtPath:ipaPath];
    if (generateSuccess) {
        self.ipaPath = ipaPath;
        return YES;
    }
    return NO;
}

@end
