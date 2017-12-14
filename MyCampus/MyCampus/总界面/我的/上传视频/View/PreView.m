//
//  PreView.m
//  Take goods
//
//  Created by zhangming on 17/5/23.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PreView.h"

@implementation PreView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUI:frame];
    }
    return self;
}

- (void)setUI:(CGRect)frame{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, 20)];
    title.text = @"选择操作";
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, frame.size.width - 30, 45)];
    [preBtn setTitle:@"预览" forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setBackgroundColor:REDCOLOR];
    preBtn.layer.cornerRadius = 22;
    [preBtn addTarget:self action:@selector(onPreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:preBtn];
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 20, 20)];
    im.image = [UIImage imageNamed:@"preImg"];
    [preBtn addSubview:im];
    
    UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 110,frame.size.width - 30, 45)];
    [upBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upBtn setBackgroundColor:REDCOLOR];
    upBtn.layer.cornerRadius = 22;
    [upBtn addTarget:self action:@selector(onUpBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:upBtn];
    
    UIImageView *im2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 20, 20)];
    im2.image = [UIImage imageNamed:@"preImg"];
    [upBtn addSubview:im2];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 170, self.size.width - 30, 45)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
   
    [cancelBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = REDCOLOR.CGColor;
    cancelBtn.layer.cornerRadius = 22;
    cancelBtn.layer.borderWidth = 1;
    [cancelBtn addTarget:self action:@selector(onCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
}

#pragma mark - 预览
- (void)onPreBtn:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPreBtn)]) {
        
        [self.delegate onPreBtn];
    }
}

#pragma mark - 上传
- (void)onUpBtn:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onUpBtn)]) {
        
        [self.delegate onUpBtn];
    }
}

#pragma mark - 取消
- (void)onCancleBtn:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCancleBtn)]) {
        
        [self.delegate onCancleBtn];
    }
}
@end
