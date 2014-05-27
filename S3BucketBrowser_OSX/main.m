//
//  main.m
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreData+MagicalRecord.h"

int main(int argc, const char * argv[])
{
    [MagicalRecord setupCoreDataStack];
    return NSApplicationMain(argc, argv);
}
