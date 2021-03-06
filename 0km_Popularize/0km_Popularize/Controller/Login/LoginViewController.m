//
//  LoginViewController.m
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/15.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "LoginViewController.h"
#import "Article.h"
#import "AccessToken.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController{
    UIImageView *welcome;
    UIView *loginBackground;
    float moveHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSelf];
    [self addViews];
}

- (void)setSelf
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationBar setHidden:YES];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
}

- (void)addViews
{
    [self.view addSubview:self.logo];
    [self addWelcome];
    [self addLoginBackground];
    [self.view addSubview:self.phoneNum];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.login];
}

//UI控件

- (UIImageView *)logo
{
    if (!_logo) {
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(90, 70, 140, 140)];
        [_logo setImage:[UIImage imageNamed:@"logo"]];
    }
    return _logo;
}

- (void)addWelcome
{
    welcome = [[UIImageView alloc] initWithFrame:CGRectMake(124.75, 90 + 140 + 5, 141/2, 33/2)];
    [welcome setImage:[UIImage imageNamed:@"welcome"]];
    [self.view addSubview:welcome];
}

- (void)addLoginBackground
{
    loginBackground = [[UIView alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 29, 320, 102)];
    [loginBackground setBackgroundColor:[UIColor whiteColor]];
    [loginBackground.layer setBorderWidth:0.5];
    [loginBackground.layer setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
    [self.view addSubview:loginBackground];
}

- (UITextField *)phoneNum
{
    if (!_phoneNum) {
        _phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 30, 320, 50)];
        [_phoneNum setBackgroundColor:[UIColor whiteColor]];
        [_phoneNum setPlaceholder:@"手机号"];
        [_phoneNum setLeftViewMode:UITextFieldViewModeAlways];
        [_phoneNum setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_phoneNum setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)]];
        [_phoneNum setDelegate:self];
        CALayer *layer = [[CALayer alloc] init];
        [layer setFrame:CGRectMake(20, 49.75, 300, 0.25)];
        [layer setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
        [_phoneNum.layer addSublayer:layer];
    }
         return _phoneNum;
}

- (UITextField *)passWord
{
    if (!_passWord) {
        _passWord = [[UITextField alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 80, 320, 50)];
        [_passWord setBackgroundColor:[UIColor whiteColor]];
        [_passWord setPlaceholder:@"密码"];
        [_passWord setLeftViewMode:UITextFieldViewModeAlways];
        [_passWord setSecureTextEntry:YES];
        [_passWord setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_passWord setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)]];
        [_passWord setDelegate:self];
        CALayer *layer = [[CALayer alloc] init];
        [layer setFrame:CGRectMake(20, 0, 300, 0.25)];
        [layer setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor];
        [_passWord.layer addSublayer:layer];
    }
    return _passWord;
}

- (UIButton *)login
{
    if (!_login) {
        _login = [[UIButton alloc] initWithFrame:CGRectMake(30, loginBackground.frame.size.height + loginBackground.frame.origin.y + 40, 260, 40)];
        [_login setBackgroundColor:[UIColor colorWithRed:0.19 green:0.68 blue:0.9 alpha:1]];
        [_login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [_login setTitle:@"登陆" forState:UIControlStateNormal];
        [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _login;
}

//UI控件 完

- (IBAction)login:(id)sender
{
    RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[AccessToken class]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(201);
    [contactMapping addAttributeMappingsFromDictionary:@{
                                                         @"token": @"token",
                                                         @"key": @"key"
                                                         }];
    RKResponseDescriptor *contactDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:contactMapping method:RKRequestMethodAny pathPattern:@"/v1/promotioners/login" keyPath:nil statusCodes:statusCodes];
    NSURL *url = [NSURL URLWithString:@"http://www.0km.me:9000"];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:url];
    [manager addResponseDescriptor:contactDescriptor];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    [parma setValue:self.phoneNum.text forKey:@"username"];
    [parma setValue:self.passWord.text forKey:@"password"];
    NSLog(@"%@",parma);
    [SVProgressHUD showWithStatus:@"登陆中"];
    [manager postObject:nil path:@"/v1/promotioners/login" parameters:parma.copy success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        AccessToken *tokenAndKey = result.array.lastObject;
        AccessToken *accessToken = [[AccessToken alloc] initWithToken:tokenAndKey.token Key:tokenAndKey.key];
        NSLog(@"actk:%@",accessToken.accessToken);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:accessToken.accessToken forKey:@"token"];
        [self pushToNextViewController:@"HomeViewController" withDatas:nil];
        NSMutableArray *viewArray = [[NSMutableArray alloc] init];
        viewArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewArray removeObjectAtIndex:[viewArray count]-2];
        self.navigationController.viewControllers = [NSArray arrayWithArray:viewArray];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNum) {
        [self.phoneNum resignFirstResponder];
        [self.passWord becomeFirstResponder];
    }
    else if(textField == self.passWord) {
        [self.passWord resignFirstResponder];
        [self login:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneNum) {
        moveHeight = -30;
    }else{
        moveHeight = -30;
    }
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,moveHeight,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,0,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
