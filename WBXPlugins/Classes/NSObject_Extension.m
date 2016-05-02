//
//  NSObject_Extension.m
//  WBXPlugins
//
//  Created by jun on 4/30/16.
//  Copyright © 2016 sina. All rights reserved.
//


#import "NSObject_Extension.h"
#import "WBXPlugins.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugins = [[WBXPlugins alloc] initWithBundle:plugin];
        });
    }
}
@end
