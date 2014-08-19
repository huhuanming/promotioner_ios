//
//  QiniuToken.m
//  QiniuUploadDemo
//
//  Created by 胡 桓铭 on 14-5-17.
//  Copyright (c) 2014年 hu. All rights reserved.
//

#import "QiniuToken.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMDefines.h"
#import "GTMBase64.h"

@implementation QiniuToken

@synthesize scope;
@synthesize accessKey;
@synthesize secretKey;

- (id)initWithScope:(NSString *)theScope SecretKey:(NSString*)theSecretKey Accesskey:(NSString*)theAccessKey{
    if (self = [super init]) {
            self.scope = theScope;
            self.secretKey = theSecretKey;
            self.accessKey = theAccessKey;
        }
    return self;
}

- (NSString *)uploadToken
{
    NSMutableDictionary *authInfo = [[NSMutableDictionary alloc]init];
    [authInfo setObject:scope forKey:@"scope"];
    [authInfo setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]+300] forKey:@"deadline" ];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *authInfoEncoded = [self urlSafeBase64Encode:jsonData];
    NSString *authDigestEncoded = [self hmac_sha1:secretKey text:authInfoEncoded];
    
    return [NSString stringWithFormat:@"%@:%@:%@",accessKey,authDigestEncoded,authInfoEncoded];
}


- (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text{
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self urlSafeBase64Encode:HMAC];
    return hash;
}

- (NSString *)urlSafeBase64Encode:(NSData *)text
{
    NSString *base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:text]
                                             encoding:NSUTF8StringEncoding];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64;
}

- (NSString *)encodedEntryURI:(NSString*)entry
{
    
    return [self urlSafeBase64Encode:[[NSString stringWithFormat:@"motor:%@", [self encryptMD5String:entry]] dataUsingEncoding:NSUTF8StringEncoding]];
}

-(NSString*)encryptMD5String:(NSString*)string{
    const char *cStr = [string UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


@end
