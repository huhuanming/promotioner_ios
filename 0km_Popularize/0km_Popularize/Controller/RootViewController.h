//
//  RootViewController.h
//  0km_Popularize
//
//  Created by 郑鸿川 on 14/8/8.
//  Copyright (c) 2014年 agile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (atomic, copy) NSDictionary* receiveData;
@property (nonatomic, strong)  UINavigationBar * navigationBar;
@property (atomic, readonly) float screenWidth;
@property (atomic, readonly) float screenHeight;
@property (nonatomic, assign) float keyboardHeight;
@property (nonatomic, copy) NSDictionary *previousControllerData;

- (void)pushToNextViewController:(NSString*)ControllerName withDatas:(NSDictionary *)receiveData;
- (void)popToPreviousContrller:(NSDictionary *)popDatas;

/**
 *  初始化导航栏
 *
 *  @param title 导航栏标题
 *  @param leftButtonType 导航栏标题左上方按钮样式
 *  @param rightButtonType 导航栏标题右上方按钮样式
 *
 */
- (void)keyboardDidChange;

@end
