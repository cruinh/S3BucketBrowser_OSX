//
//  BucketListPanel.h
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BucketListPanel : NSPanel

@property (nonatomic, weak) IBOutlet NSTableView *bucketsTable;

@end
