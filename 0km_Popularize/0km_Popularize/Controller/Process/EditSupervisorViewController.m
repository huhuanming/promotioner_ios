//
//  EditSupervisorViewController.m
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/8.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "EditSupervisorViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditSupervisorViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate>

@end

@implementation EditSupervisorViewController{
    UIScrollView *wholeScrollView;
    UILabel *name;
    UILabel *IDCard;
    
    UILabel *frontSide;
    UILabel *backSide;
    
    int flag;    //判断是照的正面，反面，还是营业执照， 1是正面，2是反面，3是营业执照
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
    flag = 0;
    [self setTitle:@"新的商家"];
    [self addWholeScrollView];
    [self addViews];
}

//UI控件

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
    [self addIDCardShadow];
    [wholeScrollView addSubview:self.frontIDCard];
    [wholeScrollView addSubview:self.backIDCard];
}

- (void)addNameShadow
{
    UIView *nameShadow = [[UIView alloc] initWithFrame:CGRectMake(9, name.frame.origin.y + name.frame.size.height - 1, 302, 82)];
    [nameShadow setBackgroundColor:[UIColor clearColor]];
    [nameShadow.layer setBorderWidth:2];
    [nameShadow.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
    [nameShadow.layer setCornerRadius:3];
    [wholeScrollView addSubview:nameShadow];
}

- (void)addIDCardShadow
{
    UIView *IDCardShadow = [[UIView alloc] initWithFrame:CGRectMake(9, IDCard.frame.origin.y + IDCard.frame.size.height - 1, 302, 102)];
    [IDCardShadow setBackgroundColor:[UIColor whiteColor]];
    [IDCardShadow.layer setBorderWidth:1.5];
    [IDCardShadow.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
    [IDCardShadow.layer setCornerRadius:3];
    [wholeScrollView addSubview:IDCardShadow];
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
        [_supervisorName.layer setBorderColor:RGBColor(233, 233, 233, 1).CGColor];
        [_supervisorName.layer setBorderWidth:0.3];
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
        [_shopName.layer setBorderColor:RGBColor(233, 233, 233, 1).CGColor];
        [_shopName.layer setBorderWidth:0.3];
        [_shopName.layer setCornerRadius:1];
        [_shopName setDelegate:self];
    }
    return _shopName;
}

- (UIButton *)frontIDCard
{
    if (!_frontIDCard) {
        _frontIDCard = [[UIButton alloc] initWithFrame:CGRectMake(15, IDCard.frame.origin.y + IDCard.frame.size.height + 5, 140, 90)];
        [_frontIDCard setImage:[UIImage imageNamed:@"addIDCard"] forState:UIControlStateNormal];
        [_frontIDCard addTarget:self action:@selector(frontIDCardCamera:) forControlEvents:UIControlEventTouchUpInside];
        [_frontIDCard.layer setCornerRadius:5];
        [_frontIDCard.imageView.layer setCornerRadius:5];
        frontSide = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, 40, 20)];
        [frontSide setFont:[UIFont boldSystemFontOfSize:12]];
        [frontSide setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        [frontSide setTextAlignment:NSTextAlignmentCenter];
        [frontSide setText:@"正面"];
        [_frontIDCard addSubview:frontSide];
    }
    return _frontIDCard;
}

- (UIButton *)backIDCard
{
    if (!_backIDCard) {
        _backIDCard = [[UIButton alloc] initWithFrame:CGRectMake(165, IDCard.frame.origin.y + IDCard.frame.size.height + 5, 140, 90)];
        [_backIDCard setImage:[UIImage imageNamed:@"addIDCard"] forState:UIControlStateNormal];
        [_backIDCard addTarget:self action:@selector(backIDCardCamera:) forControlEvents:UIControlEventTouchUpInside];
        [_backIDCard.layer setCornerRadius:5];
        [_backIDCard.imageView.layer setCornerRadius:5];
        backSide = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, 40, 20)];
        [backSide setFont:[UIFont boldSystemFontOfSize:12]];
        [backSide setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        [backSide setTextAlignment:NSTextAlignmentCenter];
        [backSide setText:@"反面"];
        [_backIDCard addSubview:backSide];
    }
    return _backIDCard;
}

//UI控件  完

//事件

- (IBAction)frontIDCardCamera:(id)sender
{
    flag = 1;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];//设置可编辑
    [picker setSourceType:sourceType];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)backIDCardCamera:(id)sender
{
    flag = 2;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];//设置可编辑
    [picker setSourceType:sourceType];
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info[@"UIImagePickerControllerOriginalImage"]);
    if (flag == 1) {
        [frontSide removeFromSuperview];
        [_frontIDCard setImage:info[@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
        [_frontIDCard.imageView setClipsToBounds:YES];
        [_frontIDCard.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }else if (flag == 2)
    {
        [backSide removeFromSuperview];
        [_backIDCard setImage:info[@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
        [_backIDCard.imageView setClipsToBounds:YES];
        [_backIDCard.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//事件  完

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
