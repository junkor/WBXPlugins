//
//  WBOTAUploadViewController.m
//  WBXPlugins
//
//  Created by jun on 5/2/16.
//  Copyright © 2016 sina. All rights reserved.
//

#import "WBOTAUploadViewController.h"
#import "WBArchiveInfo.h"

@interface WBOTAUploadViewController ()

@property (nonatomic,strong) WBOTAUploadViewController *retainSelf;

@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *descTextField;
@property (weak) IBOutlet NSTextField *bundleLabel;
@property (weak) IBOutlet NSTextField *versionLabel;

@property (weak) IBOutlet NSTextField *tipsLabel;

@end

@implementation WBOTAUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // retainSelf
    self.retainSelf = self;
}


- (void) resetFormInfoForArchInfo:(WBArchiveInfo *)archInfo
{
    self.nameTextField.stringValue = archInfo.name;
    self.bundleLabel.stringValue = [NSString stringWithFormat:@"BundleID: %@",archInfo.bundleID];
    self.versionLabel.stringValue = [NSString stringWithFormat:@"版本: %@",archInfo.shortVersionString];
}

- (IBAction)uploadButtonClicked:(NSButton *)sender
{    
    NSString *name = self.nameTextField.stringValue;
    NSString *desc = self.descTextField.stringValue;
    if (name == nil || name.length == 0) {
        self.tipsLabel.stringValue = @"should input name";
    }else{
        self.tipsLabel.stringValue = @"";
    }
    if (self.uploadBlock) {
        self.uploadBlock(name,desc);
    }
    
    self.retainSelf = nil;
}

- (void)dealloc
{
    
}

@end
