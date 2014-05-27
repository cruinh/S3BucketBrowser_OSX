//
//  AppDelegate.m
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthenticationPanel.h"
#import "CoreData+MagicalRecord.h"
#import "Notifications.h"

@implementation AppDelegate

+ (AppDelegate*)shared
{
    return [NSApplication sharedApplication].delegate;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//    [MagicalRecord setupCoreDataStack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onAuthenticationSuccess:) name:kNotification_S3AuthenticationSuccess object:nil];
    
    [self.window orderOut:self];
    [self.bucketsPanel orderOut:self];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    [MagicalRecord cleanUp];

    return NSTerminateNow;
}

#pragma mark - Notification Handlers

- (void)_onAuthenticationSuccess:(NSNotification*)notification
{
    [self.window orderFront:self];
}

#pragma mark - IBActions

- (IBAction)openPreferences:(id)sender
{
    [self.authenticationPanel orderFront:self];
}

- (IBAction)openDocument:(id)sender
{
    [self.bucketsPanel orderFront:self];
}

#pragma mark - Core Data properties


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    return [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
}

- (NSManagedObjectModel *)managedObjectModel
{
    return [NSManagedObjectModel MR_defaultManagedObjectModel];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [NSManagedObjectContext MR_defaultContext];
}

@end
