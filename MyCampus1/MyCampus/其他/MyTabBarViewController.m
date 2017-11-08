//
//  MyTabBarViewController.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "HeaderViewController.h"
#import "PlayViewController.h"
#import "FamilyViewController.h"
#import "MineViewController.h"

@interface MyTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic,assign) NSInteger  indexFlag;

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[HeaderViewController alloc] init]];
    nav1.tabBarItem.title = @"推荐";
    nav1.tabBarItem.image = [[UIImage imageNamed:@"icon_tab1_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab1_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[PlayViewController alloc] init]];
    nav2.tabBarItem.title = @"玩呗";
    nav2.tabBarItem.image = [[UIImage imageNamed:@"icon_tab2_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab2_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:[[FamilyViewController alloc] init]];
    nav3.tabBarItem.title = @"社区";
    nav3.tabBarItem.image = [[UIImage imageNamed:@"icon_tab3_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab3_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:[[MineViewController alloc] init]];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [[UIImage imageNamed:@"icon_tab4_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab4_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[nav1,nav2,nav3,nav4];
    
}

#pragma mark - 实现点击动画效果
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
        //添加动画
        //---将下面的代码块直接拷贝到此即可---
        [self animationWithIndex:index];
        self.indexFlag = index;
    }
}

// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:0.7];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.3];     //结束伸缩倍数
    
    //z轴旋转
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    //速度控制函数，控制动画运行的节奏
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.duration = 0.2;       //执行时间
//    animation.repeatCount = 1;      //执行次数
//    animation.removedOnCompletion = YES;
//    animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
//    animation.toValue = [NSNumber numberWithFloat:M_PI];     //结束伸缩倍数
    
    //向上移动
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//    //速度控制函数，控制动画运行的节奏
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.duration = 0.2;       //执行时间
//    animation.repeatCount = 1;      //执行次数
//    animation.removedOnCompletion = YES;
//    animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
//    animation.toValue = [NSNumber numberWithFloat:-10];     //结束伸缩倍数
    
    [[tabbarbuttonArray[index] layer]
     addAnimation:animation forKey:nil];
    
    self.indexFlag = index;
    
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
