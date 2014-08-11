//
//  HomeViewController.m
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/8.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    // Do any additional setup after loading the view.
    [self setTitle:@"零公里(地推版)"];
    [self addNewSupervisorButton];
}

- (void)addNewSupervisorButton
{
    [self.view addSubview:self.newSupervisorButton];
}

- (UIButton *)newSupervisorButton
{
    if (!_newSupervisorButton) {
        _newSupervisorButton = [[UIButton alloc] initWithFrame:CGRectMake(40, self.screenHeight/2, 240, 40)];
        [_newSupervisorButton setBackgroundColor:[UIColor colorWithRed:0.19 green:0.68 blue:0.9 alpha:1]];
        [_newSupervisorButton setTitle:@"创建新的商家" forState:UIControlStateNormal];
        [_newSupervisorButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
        [_newSupervisorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_newSupervisorButton addTarget:self action:@selector(pushToProcess) forControlEvents:UIControlEventTouchUpInside];
        [_newSupervisorButton.layer setCornerRadius:5];
    }
    return _newSupervisorButton;
}

- (IBAction)pushToProcess
{
    [self pushToNextViewController:@"EditSupervisorViewController" withDatas:nil];
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
