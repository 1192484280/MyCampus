//
//  OrgList.m
//  MyCampus
//
//  Created by zhangming on 17/10/11.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "OrgList.h"

@implementation OrgList

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.orgArr = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedInstance{
    
    static OrgList *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[OrgList alloc] init];
    });
    return sharedClient;
}

@end
