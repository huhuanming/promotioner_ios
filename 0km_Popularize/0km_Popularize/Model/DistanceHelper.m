//
//  DistanceHelper.m
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/19.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "DistanceHelper.h"

@implementation DistanceHelper

- (NSDictionary *)distanceHelper:(double)distance withCoords:(CLLocationCoordinate2D)coords
{
    double longtitude1 = [self longtitude1:coords withDistance:distance];
    double longtitude2 = [self longtitude2:coords withDistance:distance];
    double latitude1 = [self latitude1:coords withDistance:distance];
    double latitude2 = [self latitude2:coords withDistance:distance];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue:[NSNumber numberWithDouble:longtitude1] forKey:@"y1"];
    [result setValue:[NSNumber numberWithDouble:longtitude2] forKey:@"y2"];
    [result setValue:[NSNumber numberWithDouble:latitude1] forKey:@"x1"];
    [result setValue:[NSNumber numberWithDouble:latitude2] forKey:@"x2"];
    return result.copy;
}

- (double)latitude1:(CLLocationCoordinate2D)coords withDistance:(double)distance
{
    double result;
    
    MAMapPoint a = MAMapPointForCoordinate(coords);
    coords.latitude += 0.005;
    MAMapPoint b = MAMapPointForCoordinate(coords);
    CLLocationDistance  dis  = MAMetersBetweenMapPoints(a, b);
    result = 0.005/dis * distance;
    NSLog(@"distance:%lf",dis);
    return result;
}

- (double)latitude2:(CLLocationCoordinate2D)coords withDistance:(double)distance
{
    double result;
    
    MAMapPoint a = MAMapPointForCoordinate(coords);
    coords.latitude -= 0.005;
    MAMapPoint b = MAMapPointForCoordinate(coords);
    CLLocationDistance  dis  = MAMetersBetweenMapPoints(a, b);
    result = 0.005/dis * distance;
    NSLog(@"distance:%lf",dis);
    return result;
}

- (double)longtitude1:(CLLocationCoordinate2D)coords withDistance:(double)distance
{
    double result;
    
    MAMapPoint a = MAMapPointForCoordinate(coords);
    coords.longitude += 0.005;
    MAMapPoint b = MAMapPointForCoordinate(coords);
    CLLocationDistance  dis  = MAMetersBetweenMapPoints(a, b);
    result = 0.005/dis * distance;
    NSLog(@"distance:%lf",dis);
    return result;
}

- (double)longtitude2:(CLLocationCoordinate2D)coords withDistance:(double)distance
{
    double result;
    
    MAMapPoint a = MAMapPointForCoordinate(coords);
    coords.longitude -= 0.005;
    MAMapPoint b = MAMapPointForCoordinate(coords);
    CLLocationDistance  dis  = MAMetersBetweenMapPoints(a, b);
    result = 0.005/dis * distance;
    NSLog(@"distance:%lf",dis);
    return result;
}


@end
