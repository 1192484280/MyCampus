//
//  UpView.m
//  Take goods
//
//  Created by zhangming on 17/5/24.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "UpView.h"


@interface UpView ()

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation UpView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUI:frame];
        //[self addTimer];
    }
    return self;
}

- (void)setUI:(CGRect)frame{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, 20)];
    title.text = @"上传进度";
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    HWWaveView *waveView = [[HWWaveView alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
    waveView.x = (ScreenWidth - 100)/2;
    waveView.layer.borderWidth = 1;
    waveView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    waveView.layer.cornerRadius = 50;
    [self addSubview:waveView];
    self.waveView = waveView;
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
    la.x = (ScreenWidth - 100)/2;
    la.text = @"准备上传";
    la.textAlignment = NSTextAlignmentCenter;
    self.la = la;
    [self addSubview:la];
    
    UIButton *backUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 165, frame.size.width - 30, 40)];
    [backUpBtn setTitle:@"后台上传" forState:UIControlStateNormal];
    backUpBtn.layer.cornerRadius = 2;
    backUpBtn.layer.borderWidth = 0.5;
    backUpBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    backUpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backUpBtn setBackgroundColor:[UIColor colorWithHexString:@"#33ccff"]];
    [backUpBtn addTarget:self action:@selector(onBackUpBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backUpBtn];
    
}

#pragma mark - 后台上传
- (void)onBackUpBtn:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGoBackBtn)]) {
        
        [self.delegate onGoBackBtn];
    }
}



@end
