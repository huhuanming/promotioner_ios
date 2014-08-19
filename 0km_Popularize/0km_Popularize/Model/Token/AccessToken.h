//
//  AccessToken.h
//  AccessToken
//
//  Created by 胡 桓铭 on 14/8/13.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 * Created by hu on 14/8/13.
 *
 * AccessToken is a generic class base NSObject that build a token which used to
 *  authenticated.
 * Subclasses can branched their custom attributes, or methods.
 *
 */

@interface AccessToken : NSObject

/**
 *  token which belongs to user.
 */
@property (copy, nonatomic) NSString *token;


/**
 *  key which belongs to user.
 */
@property (copy, nonatomic) NSString *key;


/**
 *  Initialize instance with token, and the key.
 *  @param theToken the token which belongs to user
 *  @param thekey the key which belongs to user
 *  @return AccessToken Instance
 */
- (id)initWithToken:(NSString *)theToken Key:(NSString *)theKey;


/**
 *  Build a access token by the token and key. default token live is 300s.
 *  @return it is used to authenticated.
 */
- (NSString *)accessToken;


/**
 *  Build a access token by the token and key. default token live is 300s.
 *  @param ttl it is time for token live
 *  @return it is used to authenticated.
 */

- (NSString *)accessTokenWithTTL:(unsigned int)ttl;

@end
