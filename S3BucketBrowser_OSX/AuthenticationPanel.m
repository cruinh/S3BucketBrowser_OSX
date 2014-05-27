//
//  AuthenticationPanel.m
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "AuthenticationPanel.h"
#import "Notifications.h"
#import "S3Manager.h"
#import "AppDelegate.h"

#define UDKEY_BUCKET_NAME @"UDKEY_BUCKET_NAME"
#define UDKEY_ACCESS_KEY @"UDKEY_ACCESS_KEY"
#define UDKEY_ACCESS_SECRET @"UDKEY_ACCESS_SECRET"

@implementation AuthenticationPanel

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSWindow *window = [AppDelegate shared].window;
    CGFloat xPos = NSWidth([[window screen] frame])/2 - NSWidth([self frame])/2;
    CGFloat yPos = NSHeight([[window screen] frame])/2 - NSHeight([self frame])/2;
    [self setFrame:NSMakeRect(xPos, yPos, NSWidth([self frame]), NSHeight([self frame])) display:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *bucketName = [userDefaults objectForKey:UDKEY_BUCKET_NAME];
    if (bucketName)
        [self.bucketNameField setStringValue:bucketName];
    
    NSString *accessID = [userDefaults objectForKey:UDKEY_ACCESS_KEY];
    if (accessID)
        [self.accessIDField setStringValue:accessID];
    
    NSString *accessSecret = [userDefaults objectForKey:UDKEY_ACCESS_SECRET];
    if (accessSecret)
        [self.accessSecretField setStringValue:accessSecret];
}

- (void)_setUIWaitingForRequest:(BOOL)waiting
{
    [self.submitButton setEnabled:!waiting];
    [self.accessIDField setEnabled:!waiting];
    [self.accessSecretField setEnabled:!waiting];
    [self.bucketNameField setEnabled:!waiting];
    
    if (waiting)
    {
        [self.progressIndicator startAnimation:self];
    }
    else
    {
        [self.progressIndicator stopAnimation:self];
    }
    
}

- (IBAction)onCancel:(id)sender
{
    [self orderOut:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_S3AuthenticationSuccess object:nil];
}

- (IBAction)onSubmit:(id)sender
{
    if ([self _validateInputOrElse:[self _showValidationError]])
    {
        [self _setUIWaitingForRequest:YES];
        
        NSString *accessID = [self.accessIDField stringValue];
        NSString *accessSecret = [self.accessSecretField stringValue];
        NSString *bucketName = [self.bucketNameField stringValue];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:bucketName forKey:UDKEY_BUCKET_NAME];
        [userDefaults setObject:accessID forKey:UDKEY_ACCESS_KEY];
        [userDefaults setObject:accessSecret forKey:UDKEY_ACCESS_SECRET];
        [userDefaults synchronize];
        
        [AppDelegate shared].s3Manager = [S3Manager createSharedInstanceWithAccessKeyID:accessID
                                                                    andSecret:accessSecret];
        [AppDelegate shared].s3Manager.bucketName = bucketName;
        
        [[AppDelegate shared].s3Manager getServiceWithSuccess:[self _bucketListRequestSuccess]
                                                      failure:[self _bucketListRequestError]];
    }
}

- (void(^)(id responseObject))_bucketListRequestSuccess
{
    __weak AuthenticationPanel *weakSelf = self;
    return ^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_S3AuthenticationSuccess object:nil];
        
        [weakSelf orderOut:weakSelf];
        [weakSelf _setUIWaitingForRequest:NO];
        
    };
}

- (void(^)(NSError *error))_bucketListRequestError
{
    __weak AuthenticationPanel *weakSelf = self;
    return ^(NSError *error){
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error"
                                         defaultButton:@"Ok"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"%@",error];
        [alert runModal];
        
        NSLog(@"%@",error);
        
        [weakSelf _setUIWaitingForRequest:NO];
        
    };
}

- (BOOL)_validateInputOrElse:(void(^)(void))failureBlock
{
    NSString *accessID = [self.accessIDField stringValue];
    NSString *accessSecret = [self.accessSecretField stringValue];
    BOOL accessIDValidationSuccess = ((accessID != nil) &&
                                      ([accessID length] > 0));
    BOOL accessSecretValidationSuccess = ((accessSecret != nil) &&
                                          ([accessSecret length] > 0));
    
    BOOL validationSuccess = accessIDValidationSuccess && accessSecretValidationSuccess;
    
    if (!validationSuccess)
    {
        failureBlock();
    }
    return validationSuccess;
}

- (void(^)(void))_showValidationError
{
    return ^{
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error"
                                         defaultButton:@"Ok"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Please do not leave any blank fields"];
        [alert runModal];

    };
}

- (IBAction)_onTextFieldReturn:(id)sender
{
    NSString *accessID = [self.accessIDField stringValue];
    NSString *accessSecret = [self.accessSecretField stringValue];
    NSString *bucketName = [self.bucketNameField stringValue];
    
    if ([accessID length] > 0 && [accessSecret length] > 0 && [bucketName length] > 0)
    {
        [self onSubmit:sender];
    }
}

@end
