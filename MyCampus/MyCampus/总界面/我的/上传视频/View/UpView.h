//
//  UpView.h
//  Take goods
//
//  Created by zhangming on 17/5/24.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWWaveView.h"

@protocol UpViewDelegate <NSObject>

- (void)onGoBackBtn;

@end

@interface UpView : UIView

@property (strong, nonatomic) id<UpViewDelegate>delegate;

@property (nonatomic, weak) HWWaveView *waveView;

@property (strong, nonatomic) UILabel *la;

@end
