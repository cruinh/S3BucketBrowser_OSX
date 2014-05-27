//
//  Bucket.h
//  S3BucketBrowser_OSX
//
//  Created by cruinh on 5/26/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BucketObject;

@interface Bucket : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *objects;
@end

@interface Bucket (CoreDataGeneratedAccessors)

- (void)addObjectsObject:(BucketObject *)value;
- (void)removeObjectsObject:(BucketObject *)value;
- (void)addObjects:(NSSet *)values;
- (void)removeObjects:(NSSet *)values;

@end
