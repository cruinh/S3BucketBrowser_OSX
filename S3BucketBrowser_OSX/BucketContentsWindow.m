//
//  BucketContentsWindow.m
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "BucketContentsWindow.h"

#import "AppDelegate.h"
#import "BucketObject.h"
#import "S3Manager.h"

@implementation BucketContentsWindow

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGFloat xPos = NSWidth([[self screen] frame])/2 - NSWidth([self frame])/2;
    CGFloat yPos = NSHeight([[self screen] frame])/2 - NSHeight([self frame])/2;
    [self setFrame:NSMakeRect(xPos, yPos, NSWidth([self frame]), NSHeight([self frame])) display:YES];
}

- (void)orderFront:(id)sender
{
    [super orderFront:sender];
    
    NSString *title = [[AppDelegate shared].s3Manager bucketName];
    if (title)
    {
        self.title = title;
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [self.arrayController setSortDescriptors:[tableView sortDescriptors]];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 25;
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    NSTextField *textField = [aNotification object];
    
    NSString *value = [textField stringValue];
    if ([value length] > 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key CONTAINS[cd] %@", value, value];
        [self.arrayController setFilterPredicate:predicate];
    }
    else
        [self.arrayController setFilterPredicate:nil];
}

@end
