//
//  HMView.h
//  练习---小画板
//
//  Created by 远洋 on 15/11/17.
//  Copyright © 2015年 itcast. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface HMView : UIView
//开放一个属性用于接收从控制器传过来的线宽
@property(nonatomic,assign)CGFloat lineWidth;

//开放一个属性接收控制器传过来的颜色
@property(nonatomic,strong) UIColor * lineColor;

@property(nonatomic,copy)CGFloat(^lineWidthBlock)();

-(void)clear;
-(void)back;
-(void)erase;
-(void)save;

@end
