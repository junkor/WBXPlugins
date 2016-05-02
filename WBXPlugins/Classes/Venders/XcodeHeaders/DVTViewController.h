//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

//#import "DVTControllerContentViewViewControllerAdditions.h"
//#import "DVTEditor.h"
//#import "DVTInvalidation.h"

@class DVTControllerContentView, DVTExtension, DVTStackBacktrace, NSString;

@interface DVTViewController : NSViewController
{
    BOOL _didCallViewWillUninstall;
    void *_keepSelfAliveUntilCancellationRef;
    BOOL _isViewLoaded;
    DVTExtension *_representedExtension;
}

+ (id)defaultViewNibBundle;
+ (id)defaultViewNibName;
+ (void)initialize;
//- (void).cxx_destruct;
- (void)_didInstallContentView:(id)arg1;
- (void)_willUninstallContentView:(id)arg1;
- (BOOL)becomeFirstResponder;
@property(readonly) BOOL canBecomeMainViewController;
- (BOOL)commitEditingForAction:(int)arg1 errors:(id)arg2;
- (BOOL)delegateFirstResponder;
@property(readonly, copy) NSString *description;
- (void)dvtViewController_commonInit;
- (id)initUsingDefaultNib;
- (id)initWithCoder:(id)arg1;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (void)invalidate;
@property BOOL isViewLoaded; // @synthesize isViewLoaded=_isViewLoaded;
- (void)loadView;
- (void)primitiveInvalidate;
@property(retain, nonatomic) DVTExtension *representedExtension; // @synthesize representedExtension=_representedExtension;
- (void)separateKeyViewLoops;
//@property(retain) DVTControllerContentView *view;
- (id)supplementalMainViewController;
- (void)viewDidInstall;
- (void)viewWillUninstall;

// Remaining properties
@property(retain) DVTStackBacktrace *creationBacktrace;
@property(readonly, copy) NSString *debugDescription;
@property(readonly) unsigned long long hash;
@property(readonly) DVTStackBacktrace *invalidationBacktrace;
@property(readonly) Class superclass;
@property(readonly, nonatomic, getter=isValid) BOOL valid;

@end

