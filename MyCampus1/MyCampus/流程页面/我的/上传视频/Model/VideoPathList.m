//
//  VideoPathList.m
//  Family
//
//  Created by zhangming on 16/5/24.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import "VideoPathList.h"

@implementation VideoPathList

- (instancetype)init{
    if (self = [super init]) {
        self.picArr = [NSMutableArray array];
        self.wordArr = [NSMutableArray array];
        self.selectedBrandArr = [NSMutableArray array];
    }
    return self;
}
+ (instancetype)sharedInstance{
    static VideoPathList *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[VideoPathList alloc] init];
    });
    return sharedClient;
}
@end
