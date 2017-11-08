//
//  OrgList.h
//  MyCampus
//
//  Created by zhangming on 17/10/11.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrgList : NSObject

@property (strong, nonatomic) NSMutableArray *orgArr;

+ (instancetype)sharedInstance;

@end
