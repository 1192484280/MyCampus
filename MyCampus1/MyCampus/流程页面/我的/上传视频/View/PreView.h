//
//  PreView.h
//  Take goods
//
//  Created by zhangming on 17/5/23.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreViewDelegate <NSObject>

- (void)onPreBtn;
- (void)onUpBtn;
- (void)onCancleBtn;

@end

@interface PreView : UIView

@property (strong, nonatomic) id<PreViewDelegate>delegate;

@end
