//
//  BaseViewController.m
//  ZENWork
//
//  Created by zhangming on 17/3/30.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@property (nonatomic,assign) NSInteger  indexFlag;//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0

@end

@implementation BaseViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 没有返回的navBar
- (void)setNavBarHeaderTitle:(NSString *)title
{
    self.title = title;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_back_normal" selectedImageName:@"icon_back_normal" target:self action:@selector(back)];
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取uid
- (NSString *)getuid{
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *uid = [ud valueForKey:USER_UID];
//    
//    return uid;
    return @"1";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self preferredStatusBarStyle];
}

- (LoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    }
    return _loadingView;
}
#pragma mark - 加载loading
- (void)addLoadingView:(CGFloat)y{
    
    self.loadingView.y = y;
    self.loadingView.height = ScreenHeight-y-49;
    self.loadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.loadingView];
}

#pragma mark - 跳到登陆页面
- (void)goLogin{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
