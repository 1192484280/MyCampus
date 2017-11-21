//
//  HeaderModel.h
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderModel : NSObject

/**
 * 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 * 图片
 */
@property (nonatomic, copy) NSString *img;

/**
 * 喜欢
 */
@property (nonatomic, copy) NSString *like;

/**
 * 评论
 */
@property (nonatomic, copy) NSString *comment;

@end
