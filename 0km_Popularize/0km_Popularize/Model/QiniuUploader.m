//
//  QiniuUploader.m
//  QiniuUploadDemo
//
//  Created by 胡 桓铭 on 14-5-17.
//  Copyright (c) 2014年 hu. All rights reserved.
//

#import "QiniuUploader.h"
#import <AFNetworking.h>

#define kQiniuUpUploadUrl @"http://up.qiniu.com"

@implementation QiniuUploader

- (id)init
{
    return [self initWithToken:nil];
}

- (id)initWithToken:(QiniuToken *)theToken
{
    if (self = [super init]) {
        self.files = [[NSMutableArray alloc] init];
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:1];
        self.token = theToken;
    }
    return self;
}

- (void)addFile:(QiniuFile *)file
{
    [self.files addObject:file];
}

- (void)addFiles:(NSArray *)theFiles
{
    [self.files addObjectsFromArray:theFiles];
}

- (Boolean)startUpload
{
    if (!self.files) {
        return NO;
    }
    NSOperation *operation = [[NSOperation alloc] init];
    [self.operationQueue addOperation:operation];
    
    for (NSInteger i = 0; i < self.files.count; i++) {
        AFHTTPRequestOperation *theOperation = [self QiniuOperation:i];
        [theOperation addDependency:operation];
        [self.operationQueue addOperation:theOperation];
        operation = theOperation;
    }
    return YES;
}

- (Boolean)cancelAllUploadTask
{
    if (self.operationQueue.operations.count == 0) {
        return NO;
    }
    [self.operationQueue cancelAllOperations];
    return YES;
}

- (AFHTTPRequestOperation*)QiniuOperation:(NSInteger)index
{
    QiniuFile *theFile = self.files[index];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kQiniuUpUploadUrl]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (theFile.key){
        parameters[@"key"] = theFile.key;
    }
    parameters[@"token"] = [self.token uploadToken];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:kQiniuUpUploadUrl parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:theFile.fileData name:@"file" fileName:@"file" mimeType:theFile.mimeType];
    }];
    
    AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:request
                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                      if ([self.delegate respondsToSelector:@selector(uploadOneFileSucceeded:Index:ret:)]) {
                                                                                          NSLog(@"%@",[responseObject class]);
                                                                                          [self.delegate uploadOneFileSucceeded:operation Index:index ret: [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]];
                                                                                      }
                                                                                      
                                                                                      if (index == self.files.count -1) {
                                                                                          [self.delegate uploadAllFilesComplete];
                                                                                      }
                                                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                      if ([self.delegate respondsToSelector:@selector(uploadOneFileFailed:Index:error:)]) {
                                                                                          [self.delegate uploadOneFileFailed:operation Index:index error:error];
                                                                                      }
                                                                                  }];

    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        double percent = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
        if ([self.delegate respondsToSelector:@selector(uploadOneFileProgress:UploadPercent:)]) {
            [self.delegate uploadOneFileProgress:index UploadPercent:percent];
        }
    }];

    return operation;
}

@end
