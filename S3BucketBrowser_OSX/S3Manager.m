//
//  S3Manager.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "S3Manager.h"

#import "AFOnoResponseSerializer.h"
#import "Bucket.h"
#import "BucketObject.h"
#import "S3ContentTypes.h"

#import "CoreData+MagicalRecord.h"
#import <Ono/ONOXMLDocument.h>

@implementation S3Manager

static S3Manager* s_instance = nil;
+ (S3Manager*)sharedInstance
{
    return s_instance;
}

+ (S3Manager*)createSharedInstanceWithAccessKeyID:(NSString*)accessKeyID andSecret:(NSString*)secret
{
    return [S3Manager createSharedInstanceWithAccessKeyID:accessKeyID andSecret:secret inRegion:
            s_instance.requestSerializer.region = AFAmazonS3USStandardRegion];
}

+ (S3Manager*)createSharedInstanceWithAccessKeyID:(NSString*)accessKeyID andSecret:(NSString*)secret inRegion:(NSString*)region
{
    s_instance = (S3Manager *) [[S3Manager alloc] initWithAccessKeyID:accessKeyID secret:secret];
    s_instance.requestSerializer.region = region;
    s_instance.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    s_instance.responseSerializer.acceptableContentTypes = [S3ContentTypes acceptableContentTypes];
    return s_instance;
}

- (void)setBucketName:(NSString *)bucketName
{
    _bucketName = bucketName;
    s_instance.requestSerializer.bucket = bucketName;
}

#pragma mark Bucket Operations

- (void)getServiceWithSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    __weak S3Manager *weakSelf = self;
    [super getServiceWithSuccess:^(id responseObject) {
        
        [weakSelf _storeBucketContentsResponse:responseObject completion:^{
        
            if (success != nil)
            {
                success(responseObject);
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        if (failure != nil)
        {
            failure(error);
        }
        
    }];
}

- (void)_storeBucketContentsResponse:(id)responseObject completion:(void(^)(void))completion
{
    ONOXMLDocument *document = responseObject;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'";
    
    [Bucket MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"name=%@",self.bucketName]];
    Bucket *bucket = [Bucket MR_createEntity];
    bucket.name = self.bucketName;
    
    for (ONOXMLElement *object in [document.rootElement childrenWithTag:@"Contents"])
    {
        NSLog(@"%@",object);
        [self _storeXMLElementAsBucketObject:object andAddToBucket:bucket usingDateFormatter:formatter];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        completion();
    }];
}

- (void)_storeXMLElementAsBucketObject:(ONOXMLElement*)element
                        andAddToBucket:(Bucket*)bucket
                    usingDateFormatter:(NSDateFormatter*)formatter
{
    BucketObject *bucketObject = [BucketObject MR_createEntity];
    bucketObject.bucket = bucket;
    
    ONOXMLElement *keyElement = [element firstChildWithTag:@"Key"];
    ONOXMLElement *lastModifiedElement = [element firstChildWithTag:@"LastModified"];
    ONOXMLElement *eTagElement = [element firstChildWithTag:@"ETag"];
    ONOXMLElement *sizeElement = [element firstChildWithTag:@"Size"];
    ONOXMLElement *ownerElement = [element firstChildWithTag:@"Owner"];
    ONOXMLElement *storageClassElement = [element firstChildWithTag:@"StorageClass"];
    
    bucketObject.key = [keyElement stringValue];
    NSString *lastModifiedDateString = [lastModifiedElement stringValue];
    bucketObject.lastModified = [formatter dateFromString:lastModifiedDateString];
    bucketObject.eTag = [eTagElement stringValue];
    bucketObject.size = [sizeElement numberValue];
    bucketObject.owner = [ownerElement stringValue];
    bucketObject.storageClass = [storageClassElement stringValue];
}

@end
