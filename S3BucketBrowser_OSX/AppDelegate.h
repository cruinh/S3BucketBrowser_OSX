//
//  AppDelegate.h
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AuthenticationPanel;
@class S3Manager;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet NSPanel *bucketsPanel;
@property (nonatomic, weak) IBOutlet AuthenticationPanel *authenticationPanel;
@property (nonatomic, strong) S3Manager *s3Manager;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (AppDelegate*)shared;
- (void)openPreferences:(id)sender;
- (void)openDocument:(id)sender;

@end
