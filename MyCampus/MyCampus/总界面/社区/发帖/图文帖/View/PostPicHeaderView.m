//
//  PostPicHeaderView.m
//  MyCampus
//
//  Created by zhangming on 2017/12/14.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PostPicHeaderView.h"

@interface PostPicHeaderView()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *bgIm;

@property (strong, nonatomic) UITextField *titleText;

@property (strong, nonatomic) UIButton *leftBtn;

@property (strong, nonatomic) UIButton *rightBtn;

@end

@implementation PostPicHeaderView

- (UIImageView *)bgIm{
    
    if (!_bgIm) {
        
        _bgIm = [[UIImageView alloc] init];
        _bgIm.image = [UIImage imageNamed:@"lunhua07"];
        
    }
    return _bgIm;
}

-(UITextField *)titleText{

    if (!_titleText) {
        
        _titleText = [[UITextField alloc] init];
        _titleText.delegate = self;
        _titleText.textAlignment = NSTextAlignmentCenter;
        _titleText.textColor = [UIColor whiteColor];
        _titleText.text = @"设置标题";
    }
    return _titleText;
    
}

- (UIButton *)leftBtn{
    
    if (!_leftBtn) {
        
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setImage:[UIImage imageNamed:@"add_face"] forState:UIControlStateNormal];
        
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    
    if (!_rightBtn) {
        
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:[UIImage imageNamed:@"add_music"] forState:UIControlStateNormal];
        
    }
    return _rightBtn;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
        [self setLayout];
    }
    
    return self;
}

- (void)setUI{
   
    [self addSubview:self.bgIm];
    
    [self addSubview:self.titleText];
    
    [self addSubview:self.leftBtn];
    
    [self addSubview:self.rightBtn];
    
}

- (void)setLayout{
    
    [self.bgIm mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        
    }];
    
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.offset(50);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.offset(100);
        make.height.offset(30);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.offset(100);
        make.height.offset(30);
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.titleText.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (!(textField.text.length > 0)) {
        
        self.titleText.text = @"设置标题";
    }
}
@end
