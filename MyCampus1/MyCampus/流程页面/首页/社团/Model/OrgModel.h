//
//  OrgModel.h
//  MyCampus
//
//  Created by zhangming on 17/10/11.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrgModel : NSObject

//编号
@property (nonatomic, copy) NSString *uid;

//名称
@property (nonatomic, copy) NSString *name;

//logo
@property (nonatomic, copy) NSString *logo;

//介绍
@property (nonatomic, copy) NSString *introduce;

//创建日期
@property (nonatomic, copy) NSString *createDate;

//地址
@property (nonatomic, copy) NSString *address;

//喜欢数量
@property (nonatomic, copy) NSString *likeNum;

//评论数量
@property (nonatomic, copy) NSString *commentNum;

@end
