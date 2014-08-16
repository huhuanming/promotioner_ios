//
//  LoginViewController.h
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/15.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "RootViewController.h"

@interface LoginViewController : RootViewController

@property (nonatomic,strong) IBOutlet UIImageView *logo;
@property (nonatomic,strong) IBOutlet UITextField *phoneNum;
@property (nonatomic,strong) IBOutlet UITextField *passWord;
@property (nonatomic,strong) IBOutlet UIButton *login;

@end
