//
//  DistanceHelper.h
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/19.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface DistanceHelper : NSObject

- (NSDictionary *)distanceHelper:(double)distance withCoords:(CLLocationCoordinate2D)coords;

@end
