//
//  AuthenticationPanel.h
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AuthenticationPanel : NSPanel<NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSTextField *accessIDField;
@property (nonatomic, weak) IBOutlet NSTextField *accessSecretField;
@property (nonatomic, weak) IBOutlet NSTextField *bucketNameField;
@property (nonatomic, weak) IBOutlet NSButton *cancelButton;
@property (nonatomic, weak) IBOutlet NSButton *submitButton;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@end
