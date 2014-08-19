//
//  EditSupervisorViewController.h
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/8.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "RootViewController.h"
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface EditSupervisorViewController : RootViewController<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic,strong) IBOutlet UITextField *supervisorName;
@property (nonatomic,strong) IBOutlet UITextField *shopName;
@property (nonatomic,strong) IBOutlet UIButton *frontIDCard;
@property (nonatomic,strong) IBOutlet UIButton *backIDCard;
@property (nonatomic,strong) IBOutlet UIButton *licenceButton;
@property (nonatomic,strong) IBOutlet UITextField *bankNumber;
@property (nonatomic,strong) IBOutlet UIView *locationBackground;
@property (nonatomic,strong) IBOutlet UILabel *locationLabel;
@property (nonatomic,strong) IBOutlet UIImageView *locationImageView;
@property (nonatomic,strong) IBOutlet UIView *distanceButton;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end
