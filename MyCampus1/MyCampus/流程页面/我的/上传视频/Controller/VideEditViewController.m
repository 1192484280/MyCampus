//
//  VideEditViewController.m
//  Take goods
//
//  Created by zhangming on 17/5/2.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "VideEditViewController.h"
#import "BrandSelectViewController.h"
#import "VideoPathList.h"
#import "UpALYVideoInfo.h"
#import "PostOurSeverParameters.h"
#import "BrandSelectInfo.h"
#import "UpLoadingView.h"
#import "UpView.h"

@interface VideEditViewController ()<UpViewDelegate>

@property (strong, nonatomic) UpALYVideoInfo *model;
@property (copy, nonatomic) NSString *select_status;//视频公开？
@property (copy, nonatomic) NSString *brandIdStr;

@property (strong, nonatomic) UILabel *processLa;

@property (strong, nonatomic) UpLoadingView *upLoadingView;

@property (strong, nonatomic) UpView *upView;
@property (strong, nonatomic) UIView *bgView;

@end

@implementation VideEditViewController

- (UpView *)upView{
    
    if (!_upView) {
        
        _upView = [[UpView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 230)];
        _upView.delegate = self;
    }
    return _upView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return _bgView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.select_status = @"2";
    
    self.brandIdStr = @"";
    
    [self setNavBar];
    

    
}

- (void)setNavBar{
    
    [self setNavBarHeaderTitle:@"视频编辑"];
    
    UIBarButtonItem *right = [UIBarButtonItem itemWithImageName:@"icon_saomiao_normal" highImageName:@"my" target:self action:@selector(onPost)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    [self.view insertSubview:self.upView belowSubview:self.navigationController.navigationBar];
    
}

#pragma mark - 点击发布
- (void)onPost{
    
}

#pragma mark - UpViewDelegate
- (void)onGoBackBtn{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.upView.y = ScreenHeight;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        [self performSelector:@selector(goBackRootVC) withObject:nil afterDelay:0.5];
        
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}





#pragma mark - 点击品牌按钮
- (IBAction)onBrandBtn:(UIButton *)sender {
    
    
}

#pragma mark - 点击位置按钮
- (IBAction)onAddressBtn:(UIButton *)sender {
    
    
}

#pragma mark - 点击不公开按钮
- (IBAction)onPersonBtn:(UIButton *)sender {
    
    self.select_status = @"2";
    sender.selected = YES;
    self.publicBtn.selected = NO;
}

#pragma mark - 点击公开按钮
- (IBAction)onPublicBtn:(UIButton *)sender {
    
    self.select_status = @"1";
    sender.selected = YES;
    self.presonBtn.selected = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



- (void)goBackRootVC{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (UpLoadingView *)upLoadingView
{
    if (!_upLoadingView) {
        _upLoadingView = [[UpLoadingView alloc] initWithFrame:self.view.bounds];
    }
    return _upLoadingView;
}
#pragma mark - 加载loading
- (void)addupLoadingView:(CGFloat)y{
    
    self.upLoadingView.y = y;
    self.upLoadingView.height = ScreenHeight-y-49;
    self.upLoadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.upLoadingView];
}

@end
