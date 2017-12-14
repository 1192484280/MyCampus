//
//  PopViewController.h
//  MyCampus
//
//  Created by zhangming on 2017/11/21.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "BaseViewController.h"

@protocol PopViewControllerDelegate<NSObject>

- (void)onTextBtn;
- (void)onPicBtn;

@end

@interface PopViewController : BaseViewController

@property (strong, nonatomic) id<PopViewControllerDelegate>delegate;

@end
