//
//  UpLoadingView.m
//  Take goods
//
//  Created by zhangming on 17/5/23.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "UpLoadingView.h"

@implementation UpLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIView *centerView = [[UIView alloc] init];
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 5;
    centerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    centerView.width = 150;
    centerView.height = 50;
    [self addSubview:centerView];
    self.centerView = centerView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    //设置正在刷新状态的动画图片
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < 29; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%lu",(unsigned long)i]];
        [array addObject:image];
    }
    
    imageView.animationImages = array;
    imageView.animationDuration = 2;
    imageView.width = 40;
    imageView.height = 40;
    [centerView addSubview:imageView];
    [imageView startAnimating];
    self.imageView = imageView;
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"准备中..";
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:15];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.y = 0;
    titleLb.width = 80;
    titleLb.height = 50;
    [centerView addSubview:titleLb];
    self.titleLb = titleLb;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.centerView.centerX = self.width / 2;
    self.centerView.centerY = self.height / 2;
    self.imageView.x = 15;
    self.imageView.centerY = self.centerView.height / 2;
    self.titleLb.x = CGRectGetMaxX(self.imageView.frame) + 5;
}

@end
