//
//  EditSupervisorViewController.m
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/8.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "EditSupervisorViewController.h"

@interface EditSupervisorViewController ()<UITextFieldDelegate>

@end

@implementation EditSupervisorViewController{
    UIScrollView *wholeScrollView;
    UILabel *name;
    UILabel *IDCard;
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
    [self setTitle:@"新的商家"];
    [self addWholeScrollView];
    [self addViews];
}

- (void)addWholeScrollView
{
    wholeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight + 80)];
    [wholeScrollView setContentSize:CGSizeMake(self.screenWidth, self.screenHeight + 80)];
    [wholeScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:wholeScrollView];
}

- (void)addViews
{
    [self addName];
    [self addIDCard];
}

- (void)addName
{
    name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    [name setText:@"名称"];
    [name setFont:[UIFont systemFontOfSize:14]];
    [name setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
    [wholeScrollView addSubview:name];
    [self addNameShadow];
    [wholeScrollView addSubview:self.supervisorName];
    [wholeScrollView addSubview:self.shopName];
}

- (void)addIDCard
{
    IDCard = [[UILabel alloc] initWithFrame:CGRectMake(10, _shopName.frame.origin.y + _shopName.frame.size.height, 150, 30)];
    [IDCard setText:@"负责人身份证"];
    [IDCard setFont:[UIFont systemFontOfSize:14]];
    [IDCard setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
    [wholeScrollView addSubview:IDCard];
}

- (void)addNameShadow
{
    UIView *nameShadow = [[UIView alloc] initWithFrame:CGRectMake(9, name.frame.origin.y + name.frame.size.height - 1, 302, 82)];
    [nameShadow setBackgroundColor:[UIColor clearColor]];
    [nameShadow.layer setBorderWidth:2];
    [nameShadow.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
    [nameShadow.layer setCornerRadius:1];
    [wholeScrollView addSubview:nameShadow];
}

- (UITextField *)supervisorName
{
    if (!_supervisorName) {
        _supervisorName = [[UITextField alloc] initWithFrame:CGRectMake(10, name.frame.origin.y + name.frame.size.height, 300, 40)];
        [_supervisorName setBackgroundColor:[UIColor whiteColor]];
        [_supervisorName setPlaceholder:@"商家名称"];
        [_supervisorName setLeftViewMode:UITextFieldViewModeAlways];
        [_supervisorName setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)]];
        [_supervisorName setClearsOnBeginEditing:YES];
        [_supervisorName setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_supervisorName setFont:[UIFont systemFontOfSize:16]];
        [_supervisorName setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
        [_supervisorName.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
        [_supervisorName.layer setBorderWidth:0.5];
        [_supervisorName.layer setCornerRadius:1];
        [_supervisorName setDelegate:self];
    }
    return _supervisorName;
}

- (UITextField *)shopName
{
    if (!_shopName) {
        _shopName = [[UITextField alloc] initWithFrame:CGRectMake(10, _supervisorName.frame.origin.y + _supervisorName.frame.size.height, 300, 40)];
        [_shopName setBackgroundColor:[UIColor whiteColor]];
        [_shopName setPlaceholder:@"店铺名称"];
        [_shopName setLeftViewMode:UITextFieldViewModeAlways];
        [_shopName setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)]];
        [_shopName setClearsOnBeginEditing:YES];
        [_shopName setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_shopName setFont:[UIFont systemFontOfSize:16]];
        [_shopName setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
        [_shopName.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
        [_shopName.layer setBorderWidth:0.5];
        [_shopName.layer setCornerRadius:1];
        [_shopName setDelegate:self];
    }
    return _shopName;
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
