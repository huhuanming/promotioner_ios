//
//  RootViewController.m
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/8.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize receiveData;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont  systemFontOfSize:21.0], NSFontAttributeName, nil]];
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
}

- (UINavigationBar *)navigationBar
{
    return self.navigationController.navigationBar;
}

- (void)pushToNextViewController:(NSString*)ControllerName withDatas:(NSDictionary *)theReceiveData
{
    Class class = NSClassFromString(ControllerName);
    RootViewController *destinationController = [[class alloc] init];
    [destinationController setReceiveData:theReceiveData];
    [self.navigationController pushViewController:destinationController animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)popToPreviousContrller:(NSDictionary *)popData
{
    RootViewController *destinationController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValuesForKeysWithDictionary:destinationController.receiveData];
    [dic setValuesForKeysWithDictionary:popData];
    destinationController.receiveData = [dic copy];
    [self.navigationController popToViewController: destinationController animated:YES];
}

- (void)keyboardWasChange:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyboardHeight = kbSize.height;
    [self keyboardDidChange];
}

- (void)keyboardDidChange
{

}

-(float)screenWidth
{
    return [UIScreen mainScreen].applicationFrame.size.width;
}

-(float)screenHeight
{
    return [UIScreen mainScreen].applicationFrame.size.height;
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
