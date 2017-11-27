//
//  AppDelegate.h
//  MyCampus
//
//  Created by zhangming on 17/7/26.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAddPreView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ImageAddPreView   *preview;

- (void)showPreView;
- (void)hiddenPreView;
@end

