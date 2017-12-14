//
//  NSString+Extension.h
//  PianKe
//
//  Created by 胡明昊 on 16/3/1.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  判断是否为邮箱格式
 */
- (BOOL)isEmail;

/**
 * md5加密
 */
- (NSString *) md5HexDigest;

@end
