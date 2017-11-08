//
//  HttpTool.h
//  ZENWork
//
//  Created by zhangming on 17/4/13.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

+ (void)getUrlWithString:(NSString *)url parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

+ (NSError *)inspectError:(NSDictionary *)responseObject;

+ (NSString *)handleError:(NSError *)error;

//存入本地数据
+ (void)saveInfoToUserDefaultsWithInfo:(NSString *)value andKey:(NSString *)key;

//获取本地数据
+ (NSString *)getInfoFromDefaultsWithKey:(NSString*)key;

//移除本地数据
+ (void)removeInfoFromDefaultWithKey:(NSString *)key;
@end
