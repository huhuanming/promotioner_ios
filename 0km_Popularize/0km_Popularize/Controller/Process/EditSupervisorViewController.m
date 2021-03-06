//
//  EditSupervisorViewController.m
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/8.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "EditSupervisorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "QiniuUploader.h"
#import "DistanceHelper.h"

@interface EditSupervisorViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, QiniuUploaderDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation EditSupervisorViewController{
    UIScrollView *wholeScrollView;
    UILabel *name;
    UILabel *IDCard;
    UILabel *licence;
    UILabel *bank;
    UILabel *location;
    UILabel *distanceLabel;
    UIPickerView *distancePicker;
    double distance;  //存的商家确定的距离
    NSDictionary *xy;    //存的商家确定范围后的四个点
    CLLocationCoordinate2D point;
    NSArray *pickerSelectionData;
    UIView *distancePickerBackground;
    UILabel *distanceLabelofdistanceButton;
    UILabel *phoneNumberLabel;
    
    UILabel *frontSide;
    UILabel *backSide;
    
    UIButton *allComplete;
    
    QiniuUploader *uploader;
    NSString *keyOfFront;
    NSString *keyOfBack;
    NSString *keyOfLicence;
    
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
    [MAMapServices sharedServices].apiKey =@"cd729ac8c8e8b5846849668bf42633d5";
    [self addWholeScrollView];
    [self addViews];
    [self initLocation];
    [self initKey];
}

- (void)initKey
{
    
}

//UI控件

- (void)addWholeScrollView
{
    wholeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 580)];
    if (self.screenHeight == 460) {
        [wholeScrollView setContentSize:CGSizeMake(self.screenWidth, 860)];
    }else{
        [wholeScrollView setContentSize:CGSizeMake(self.screenWidth, 800)];
    }
    [wholeScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:wholeScrollView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    tap.delegate = self;
    [wholeScrollView addGestureRecognizer:tap];
}

- (void)addViews
{
    [self addName];
    [self addIDCard];
    [self addLicence];
    [self addBank];
    [self addLocation];
    [self addDistance];
    [self addPhoneNumber];
    [self addAllComplete];
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

- (void)addLicence
{
    licence = [[UILabel alloc] initWithFrame:CGRectMake(10, _frontIDCard.frame.origin.y + _frontIDCard.frame.size.height + 5, 150, 30)];
    [licence setText:@"营业执照"];
    [licence setFont:[UIFont systemFontOfSize:14]];
    [licence setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
    [wholeScrollView addSubview:licence];
    [wholeScrollView addSubview:self.licenceButton];
}

- (void)addBank
{
    bank = [[UILabel alloc] initWithFrame:CGRectMake(10, _licenceButton.frame.origin.y + _licenceButton.frame.size.height, 150, 30)];
    [bank setText:@"银行"];
    [bank setFont:[UIFont systemFontOfSize:14]];
    [bank setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
    [wholeScrollView addSubview:bank];
    [wholeScrollView addSubview:self.bankNumber];
}

- (void)addLocation
{
    location = [[UILabel alloc] initWithFrame:CGRectMake(10, _bankNumber.frame.origin.y + _bankNumber.frame.size.height, 150, 30)];
    [location setText:@"店铺定位"];
    [location setFont:[UIFont systemFontOfSize:14]];
    [location setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
    [wholeScrollView addSubview:location];
    [wholeScrollView addSubview:self.locationBackground];
}

- (void)addDistance
{
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _locationBackground.frame.origin.y + _locationBackground.frame.size.height, 150, 30)];
    [distanceLabel setText:@"送餐半径"];
    [distanceLabel setFont:[UIFont systemFontOfSize:14]];
    [distanceLabel setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
    [wholeScrollView addSubview:distanceLabel];
    [wholeScrollView addSubview:self.distanceButton];
}

- (void)addPhoneNumber
{
    phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _distanceButton.frame.origin.y + _distanceButton.frame.size.height, 150, 30)];
    [phoneNumberLabel setText:@"手机号码(商家账号)"];
    [phoneNumberLabel setFont:[UIFont systemFontOfSize:14]];
    [phoneNumberLabel setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
    [wholeScrollView addSubview:phoneNumberLabel];
    [wholeScrollView addSubview:self.phoneNumber];
}

- (void)addAllComplete
{
    allComplete = [[UIButton alloc] initWithFrame:CGRectMake(10, _phoneNumber.frame.origin.y + _phoneNumber.frame.size.height + 10, 300, 40)];
    [allComplete.layer setCornerRadius:3];
    [allComplete setBackgroundColor:[UIColor colorWithRed:0.19 green:0.68 blue:0.89 alpha:1]];
    [allComplete addTarget:self action:@selector(postAll:) forControlEvents:UIControlEventTouchUpInside];
    [allComplete setTitle:@"完成创建" forState:UIControlStateNormal];
    [allComplete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wholeScrollView addSubview:allComplete];
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

- (UIButton *)licenceButton
{
    if (!_licenceButton) {
        _licenceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, licence.frame.origin.y + licence.frame.size.height, 300, 140)];
        [_licenceButton setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [_licenceButton addTarget:self action:@selector(licenceCamera:) forControlEvents:UIControlEventTouchUpInside];
        [_licenceButton setBackgroundColor:[UIColor whiteColor]];
        [_licenceButton.layer setCornerRadius:3];
        [_licenceButton.layer setBorderWidth:1.5];
        [_licenceButton.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
    }
    return _licenceButton;
}

- (UITextField *)bankNumber
{
    if (!_bankNumber) {
        _bankNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, bank.frame.origin.y + bank.frame.size.height, 300, 40)];
        [_bankNumber setBackgroundColor:[UIColor whiteColor]];
        [_bankNumber setPlaceholder:@"银行账号"];
        [_bankNumber setLeftViewMode:UITextFieldViewModeAlways];
        [_bankNumber setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)]];
        [_bankNumber setClearsOnBeginEditing:YES];
        [_bankNumber setKeyboardType:UIKeyboardTypeNumberPad];
        [_bankNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_bankNumber setFont:[UIFont systemFontOfSize:16]];
        [_bankNumber setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
        [_bankNumber.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
        [_bankNumber.layer setBorderWidth:1.5];
        [_bankNumber.layer setCornerRadius:3];
        [_bankNumber setDelegate:self];
    }
    return _bankNumber;
}

- (UIView *)locationBackground
{
    if (!_locationBackground) {
        _locationBackground = [[UIView alloc] initWithFrame:CGRectMake(10, location.frame.origin.y + location.frame.size.height, 300, 40)];
        [_locationBackground setBackgroundColor:[UIColor whiteColor]];
        [_locationBackground.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
        [_locationBackground.layer setBorderWidth:1.5];
        [_locationBackground.layer setCornerRadius:3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(initLocation)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        tap.delegate = self;
        [_locationBackground addGestureRecognizer:tap];
        [_locationBackground addSubview:self.locationLabel];
        [_locationBackground addSubview:self.locationImageView];
    }
    return _locationBackground;
}

- (UIView *)distanceButton
{
    if (!_distanceButton) {
        _distanceButton = [[UIView alloc] initWithFrame:CGRectMake(10, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, 300, 40)];
        [_distanceButton setBackgroundColor:[UIColor whiteColor]];
        [_distanceButton.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
        [_distanceButton.layer setBorderWidth:1.5];
        [_distanceButton.layer setCornerRadius:3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distanceChoose)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        tap.delegate = self;
        [_distanceButton addGestureRecognizer:tap];
        distanceLabelofdistanceButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _distanceButton.frame.size.width, _distanceButton.frame.size.height)];
        [distanceLabelofdistanceButton setText:@"选择送餐距离"];
        [distanceLabelofdistanceButton setTextAlignment:NSTextAlignmentCenter];
        [distanceLabelofdistanceButton setTextColor:[UIColor colorWithRed:0.43 green:0.62 blue:0.72 alpha:1]];
        [_distanceButton addSubview:distanceLabelofdistanceButton];
    }
    return _distanceButton;
}

- (UITextField *)phoneNumber
{
    if (!_phoneNumber) {
        _phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, phoneNumberLabel.frame.origin.y + phoneNumberLabel.frame.size.height, 300, 40)];
        [_phoneNumber setBackgroundColor:[UIColor whiteColor]];
        [_phoneNumber setPlaceholder:@"手机号码"];
        [_phoneNumber setLeftViewMode:UITextFieldViewModeAlways];
        [_phoneNumber setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)]];
        [_phoneNumber setClearsOnBeginEditing:YES];
        [_phoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
        [_phoneNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_phoneNumber setFont:[UIFont systemFontOfSize:16]];
        [_phoneNumber setTextColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.6 alpha:1]];
        [_phoneNumber.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
        [_phoneNumber.layer setBorderWidth:1.5];
        [_phoneNumber.layer setCornerRadius:3];
        [_phoneNumber setDelegate:self];
    }
    return _phoneNumber;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 260, 40)];
        [_locationLabel setTextColor:[UIColor colorWithRed:0.43 green:0.62 blue:0.72 alpha:1]];
        [_locationLabel setText:@"获取地理位置"];
        [_locationLabel setTextAlignment:NSTextAlignmentNatural];
    }
    return _locationLabel;
}

- (UIImageView *)locationImageView
{
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 20, 26)];
        [_locationImageView setImage:[UIImage imageNamed:@"gps"]];
    }
    return _locationImageView;
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
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"没有找到摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
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
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"没有找到摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];//设置可编辑
    [picker setSourceType:sourceType];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)licenceCamera:(id)sender
{
    flag = 3;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"没有找到摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
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
        [_frontIDCard.imageView setClipsToBounds:YES];
        [_frontIDCard.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_frontIDCard setImage:info[@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    }else if (flag == 2) {
        [backSide removeFromSuperview];
        [_backIDCard.imageView setClipsToBounds:YES];
        [_backIDCard.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_backIDCard setImage:info[@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    }else if (flag == 3) {
        [_licenceButton.imageView setClipsToBounds:YES];
        [_licenceButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_licenceButton.imageView.layer setCornerRadius:5];
        [_licenceButton setImage:info[@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchReGeocode:(double)latitude withLongitude:(double)longitude
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    [regeoRequest setSearchType:AMapSearchType_ReGeocode];
    [regeoRequest setLocation:[AMapGeoPoint locationWithLatitude:latitude longitude:longitude]];
    [regeoRequest setRequireExtension:YES];
    [self.search AMapReGoecodeSearch:regeoRequest];
}

- (void)initLocation
{
    self.mapView = [[MAMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"cd729ac8c8e8b5846849668bf42633d5" Delegate:self];
    self.mapView.delegate = self;
}

- (void)distanceChoose
{
    [distanceLabelofdistanceButton setText:@"500米"];
    distance = 500;
    distancePickerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, wholeScrollView.frame.size.height)];
    [distancePickerBackground setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    pickerSelectionData = [[NSArray alloc] initWithObjects:@"500米", @"1000米", @"1500米", @"2000米", nil];
    distancePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(40, self.screenHeight/2 - 40, 240, 80)];
    [distancePicker setDataSource:self];
    [distancePicker setDelegate:self];
    [distancePicker setBackgroundColor:[UIColor whiteColor]];
    [distancePicker.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
    [distancePicker.layer setBorderWidth:1.5];
    [distancePicker.layer setCornerRadius:7];
    UIButton *complete = [[UIButton alloc] initWithFrame:CGRectMake(30, self.screenHeight - 30, 260, 40)];
    [complete setTitle:@"完成" forState:UIControlStateNormal];
    [complete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [complete addTarget:self action:@selector(chooseComplete) forControlEvents:UIControlEventTouchUpInside];
    [complete setBackgroundColor:[UIColor colorWithRed:0.19 green:0.68 blue:0.9 alpha:1]];
    [complete.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor];
    [complete.layer setBorderWidth:1.5];
    [complete.layer setCornerRadius:3];
    [self.view addSubview:distancePickerBackground];
    [distancePickerBackground addSubview:complete];
    [distancePickerBackground addSubview:distancePicker];
}

- (void)chooseComplete
{
    [distancePickerBackground removeFromSuperview];
    DistanceHelper *dic = [[DistanceHelper alloc] init];
    xy = [[NSDictionary alloc] initWithDictionary:[dic distanceHelper:distance withCoords:point]];
    NSLog(@"%@",xy);
}

- (IBAction)postAll:(id)sender
{
    //give token
    QiniuToken *token = [[QiniuToken alloc] initWithScope:kScope SecretKey:kSecretKey Accesskey:kAccessKey];
    [SVProgressHUD showWithStatus:@"餐馆创建中..."];
    //give file
    QiniuFile *file1 = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(_frontIDCard.imageView.image, 0.3f)];
    QiniuFile *file2 = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(_backIDCard.imageView.image, 0.3f)];
    QiniuFile *file3 = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(_licenceButton.imageView.image, 0.3f)];
    
    //startUpload
    uploader = [[QiniuUploader alloc] initWithToken:token];
    [uploader addFile:file1];
    [uploader addFile:file2];
    [uploader addFile:file3];
    [uploader setDelegate:self];
    [uploader startUpload];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[PostAllResponse class]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(201);
    [contactMapping addAttributeMappingsFromDictionary:@{
                                                         @"response_status": @"response_status"
                                                         }];
    RKResponseDescriptor *contactDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:contactMapping method:RKRequestMethodAny pathPattern:@"/v1/restaurants" keyPath:nil statusCodes:statusCodes];
    NSURL *url = [NSURL URLWithString:@"http://www.0km.me:9000"];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:url];
    [manager addResponseDescriptor:contactDescriptor];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    if ([userDefaults objectForKey:@"token"] != NULL && keyOfBack != NULL && keyOfFront != NULL && keyOfLicence != NULL && _shopName.text != NULL && _supervisorName.text != NULL && _bankNumber != NULL && _phoneNumber != NULL && xy != NULL && distance > 0) {
        [parma setValue:[userDefaults objectForKey:@"token"] forKey:@"access_token"];
        [parma setValue:self.shopName.text forKey:@"restaurant_name"];
        [parma setValue:self.supervisorName.text forKey:@"supervisor_name"];
        [parma setValue:self.bankNumber.text forKey:@"back_account"];
        [parma setValue:self.phoneNumber.text forKey:@"phone_number"];
        [parma setValue:keyOfFront forKey:@"id_card_front"];
        [parma setValue:keyOfBack forKey:@"id_card_reverse"];
        [parma setValue:keyOfLicence forKey:@"linsece"];
        [parma setValue:self.locationLabel.text forKey:@"address"];
        [parma setValue:[NSString stringWithFormat:@"%lf",point.longitude] forKey:@"longitude"];
        [parma setValue:[NSString stringWithFormat:@"%lf",point.latitude] forKey:@"latitude"];
        [parma setValue:[xy objectForKey:@"x1"] forKey:@"coordinate_x1"];
        [parma setValue:[xy objectForKey:@"x2"] forKey:@"coordinate_x2"];
        [parma setValue:[xy objectForKey:@"y1"] forKey:@"coordinate_y1"];
        [parma setValue:[xy objectForKey:@"y2"] forKey:@"coordinate_y2"];

        NSLog(@"parma:%@",parma);
        [manager postObject:nil path:@"/v1/restaurants" parameters:parma.copy success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
            [SVProgressHUD showSuccessWithStatus:@"创建成功"];
            PostAllResponse *postResult = result.array.lastObject;
            NSLog(@"successCode:%@",postResult);
            [self popToPreviousContrller:nil];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"创建失败"];
            NSLog(@"%@",error);
            switch (error.code) {
                case 401:
                    [SVProgressHUD showErrorWithStatus:@"请重新安装本应用并登录"];
                    break;
                case 404:
                    [SVProgressHUD showErrorWithStatus:@"本账号不存在，请联系开发人员"];
                    break;
                case 500:
                    [SVProgressHUD showErrorWithStatus:@"未知错误,请联系开发人员"];
                    break;
                case 501:
                    [SVProgressHUD showErrorWithStatus:@"有条目已存在，请检查"];
                    break;
                default:
                    break;
            }
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"尚有项目未完成"];
    }
    
}

//事件  完

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.supervisorName) {
        [self.supervisorName resignFirstResponder];
        [self.shopName becomeFirstResponder];
    }
    else if(textField == self.shopName) {
        [self.shopName resignFirstResponder];
        [self.bankNumber becomeFirstResponder];
    }else if(textField == self.bankNumber){
        [self.bankNumber resignFirstResponder];
        [self.phoneNumber becomeFirstResponder];
    }else{
        [self.phoneNumber resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.bankNumber) {
        NSLog(@"%f",self.screenHeight);
        if (self.screenHeight == 460) {
            [wholeScrollView setContentOffset:CGPointMake(0, 216) animated:YES];
        }else{
            [wholeScrollView setContentOffset:CGPointMake(0, 128) animated:YES];
        }
    }else if (textField == self.phoneNumber){
        NSLog(@"%f",self.screenHeight);
        if (self.screenHeight == 460) {
            [wholeScrollView setContentOffset:CGPointMake(0, 426) animated:YES];
        }else{
            [wholeScrollView setContentOffset:CGPointMake(0, 338) animated:YES];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.bankNumber) {
        [wholeScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)resignKeyboard:(id)sender
{
    [self.supervisorName resignFirstResponder];
    [self.shopName resignFirstResponder];
    [self.bankNumber resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
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

#pragma mark - AMapSearchDelegate

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"err%@",errInfo);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode.formattedAddress];
    NSLog(@"ReGeo: %@", result);
    [_locationLabel setText:response.regeocode.formattedAddress];
    [_locationLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"%@",userLocation.location);
    [self searchReGeocode:userLocation.location.coordinate.latitude withLongitude:userLocation.location.coordinate.longitude];
    self.mapView.showsUserLocation = NO;
    point = userLocation.coordinate;
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - QiniuUploadDelegate

- (void)uploadOneFileFailed:(AFHTTPRequestOperation *)operation Index:(NSInteger)index error:(NSError *)error
{
     NSLog(@"%@",error.description);
    [uploader cancelAllUploadTask];
    [SVProgressHUD showErrorWithStatus:@"图片上传失败，请重试"];
}

- (void)uploadOneFileSucceeded:(AFHTTPRequestOperation *)operation Index:(NSInteger)index ret:(NSDictionary *)ret
{
    NSLog(@"%@",ret);
    switch (index) {
        case 0:
            keyOfFront = [[NSString alloc] initWithString:[ret objectForKey:@"key"]];
            break;
        case 1:
            keyOfBack = [[NSString alloc] initWithString:[ret objectForKey:@"key"]];
            break;
        case 2:
            keyOfLicence = [[NSString alloc] initWithString:[ret objectForKey:@"key"]];
            break;
        default:
            break;
    }
}

- (void)uploadOneFileProgress:(NSInteger)index UploadPercent:(double)percent
{
    NSLog(@"%lf",percent);
}

- (void)uploadAllFilesComplete
{
    
}

#pragma mark - UIPickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (row) {
        case 0:
            distance = 500;
            [distanceLabelofdistanceButton setText:@"500米"];
            break;
        case 1:
            distance = 1000;
            [distanceLabelofdistanceButton setText:@"1000米"];
            break;
        case 2:
            distance = 1500;
            [distanceLabelofdistanceButton setText:@"1500米"];
            break;
        case 3:
            distance = 2000;
            [distanceLabelofdistanceButton setText:@"2000米"];
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerSelectionData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerSelectionData objectAtIndex:row];
}

@end
