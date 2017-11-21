//
//  BaseViewController.h
//  ZENWork
//
//  Created by zhangming on 17/3/30.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
@interface BaseViewController : UIViewController

@property (strong, nonatomic) LoadingView *loadingView;

/**
 * 设置页面标题
 */
- (void)setNavBarHeaderTitle:(NSString *)title;

/**
 * 获取uid
 */
- (NSString *)getuid;

/**
 * 添加loadingView
 */
- (void)addLoadingView:(CGFloat)y;


/**
 * 跳到登陆页面
 */
- (void)goLogin;

@end
