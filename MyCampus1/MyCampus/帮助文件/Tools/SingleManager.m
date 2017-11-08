//
//  SingleManager.m
//  聚汇万家
//
//  Created by zhangming on 17/7/17.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "SingleManager.h"

@implementation SingleManager

+ (instancetype)sharedInstance{
    
    static SingleManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[SingleManager alloc] init];
    });
    return sharedClient;
}
@end
