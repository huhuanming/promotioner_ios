//
//  AccessToken.m
//  AccessToken
//
//  Created by 胡 桓铭 on 14/8/13.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "AccessToken.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMDefines.h"
#import "GTMBase64.h"

@implementation AccessToken

@synthesize token;
@synthesize key;

- (id)initWithToken:(NSString *)theToken Key:(NSString *)theKey
{
    if (self = [super init]) {
        self.token = theToken;
        self.key = theKey;
    }
    return self;
}

- (NSString *)accessToken
{
    return [self accessTokenWithTTL:300];
}

- (NSString *)accessTokenWithTTL:(unsigned int)ttl
{
    if (self.token.length == 0 || self.key.length == 0) {
        return @"empty token or key";
    }
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    [info setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] + ttl] forKey:@"deadline"];
    
    [info setObject:[NSNumber numberWithInt:1] forKey:@"device"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *encoded = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    encoded = [self escape:encoded];
    NSString *encoded_sign = [self hmac_sha1:self.key text:encoded];
    return [NSString stringWithFormat:@"%@:%@:%@",self.token,[self escape:encoded_sign],encoded];
}

- (NSString *)hmac_sha1:(NSString *)theKey text:(NSString *)text{
    
    const char *cKey  = [theKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self base64Encode:HMAC];
    return hash;
}

- (NSString *)base64Encode:(NSData *)text
{
    NSString *base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:text]
                                             encoding:NSUTF8StringEncoding];
    return base64;
}

- (NSString *)escape:(NSString *)string
{
    NSString *escape = [[NSString alloc] init];
    escape = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    escape = [escape stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    escape = [escape stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    escape = [escape stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    escape = [escape stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return escape;
}

@end
