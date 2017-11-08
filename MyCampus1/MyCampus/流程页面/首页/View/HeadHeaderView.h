//
//  HeadHeaderView.h
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadHeaderViewDelegate <NSObject>

- (void)onCatBtnWithIndex:(NSUInteger)index;

- (void)cycleScrollViewDidScrollViewToIndexforUrl:(NSString *)url;

@end

@interface HeadHeaderView : UIView

@property (weak, nonatomic) id<HeadHeaderViewDelegate>delegate;

@property (copy, nonatomic) NSArray *ADArray;

@end
