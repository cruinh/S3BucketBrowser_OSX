//
//  BucketContentsWindow.h
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BucketContentsWindow : NSWindow<NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, weak) IBOutlet NSArrayController *arrayController;
@property (nonatomic, weak) IBOutlet NSTextField *filterTextField;

@end
