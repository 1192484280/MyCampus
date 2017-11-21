//
//  MeHeaderView.m
//  BeautyApp
//
//  Created by zhangming on 17/1/22.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "MeHeaderView.h"

@interface MeHeaderView()



@end

@implementation MeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASECOLOR;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.backgroundColor = BASECOLOR;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIButton *weatherBtn = [[UIButton alloc] init];
    [weatherBtn setImage:[UIImage imageNamed:@"icon_wind"] forState:UIControlStateNormal];
    [self addSubview:weatherBtn];
    [weatherBtn addTarget:self action:@selector(onWeatherBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.weatherBtn = weatherBtn;
    
    UIButton *settingBtn = [[UIButton alloc] init];
    [settingBtn setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(onSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingBtn];
    self.settingBtn = settingBtn;
    
    UIImageView *headIm = [[UIImageView alloc] init];
    headIm.image = [UIImage imageNamed:@"add_img"];
    headIm.layer.cornerRadius = 40;
    headIm.layer.masksToBounds = YES;
    headIm.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:headIm];
    self.headIm = headIm;
    
    UIButton *titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];

    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [titleBtn addTarget:self action:@selector(onLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleBtn];
    self.titleBtn = titleBtn;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponBtn setTitle:@"我的宿舍" forState:UIControlStateNormal];
    [couponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [couponBtn setImage:[UIImage imageNamed:@"icon_home"] forState:UIControlStateNormal];
    couponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    couponBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    couponBtn.width = ScreenWidth/2;
    couponBtn.height = 50;
    couponBtn.x = 0;
    couponBtn.y = 0;
    [couponBtn addTarget:self action:@selector(onLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:couponBtn];
    
    UIButton *interalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [interalBtn setTitle:@"我要巡逻" forState:UIControlStateNormal];
    [interalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [interalBtn setImage:[UIImage imageNamed:@"icon_xunluo"] forState:UIControlStateNormal];
    interalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    interalBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    interalBtn.width = ScreenWidth/2;
    interalBtn.height = 50;
    interalBtn.x = ScreenWidth/2;
    interalBtn.y = 0;
    [interalBtn addTarget:self action:@selector(onRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:interalBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-0.5, 10, 1, 30)];
    lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [bottomView addSubview:lineView];
}
#pragma mark - 点击登陆/注册
- (void)onLoginBtn:(UIButton *)btn{
    
    NSLog(@"点击登陆/注册");
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLogin)]) {
        
        [self.delegate onLogin];
    }
}

#pragma mark - 点击左按钮
- (void)onLeftBtn:(UIButton *)btn{
    
    NSLog(@"点击左按钮");
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLeft)]) {
        
        [self.delegate onLeft];
    }
}

#pragma mark - 点击右按钮
- (void)onRightBtn:(UIButton *)btn{
    
    NSLog(@"点击右按钮");
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRight)]) {
        
        [self.delegate onRight];
    }
}

#pragma mark - 天气
- (void)onWeatherBtn:(UIButton *)btn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onWeather)]) {
        
        [self.delegate onWeather];
    }
}

#pragma mark - 设置
- (void)onSettingBtn:(UIButton *)btn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSetting)]) {
        
        [self.delegate onSetting];
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.bgView.y -= ScreenHeight;
    self.bgView.height += ScreenHeight;
    
    self.weatherBtn.x = 20;
    self.weatherBtn.y = 20;
    self.weatherBtn.width = 50;
    self.weatherBtn.height = 50;
    
    self.settingBtn.x = ScreenWidth - 50;
    self.settingBtn.y = 20;
    self.settingBtn.width = 50;
    self.settingBtn.height = 35;
    self.headIm.x = (ScreenWidth - 70)/2;
    self.headIm.y = 60;
    self.headIm.width = 80;
    self.headIm.height = 80;
    self.titleBtn.x = (ScreenWidth - 150)/2;
    self.titleBtn.y = CGRectGetMaxY(self.headIm.frame) + 5;
    self.titleBtn.width = 150;
    self.titleBtn.height = 30;
    self.bottomView.x = 0;
    self.bottomView.y = self.height - 50;
    self.bottomView.width = ScreenWidth;
    self.bottomView.height = 50;
}
@end
