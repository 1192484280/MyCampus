//
//  VideoPathList.h
//  Family
//
//  Created by zhangming on 16/5/24.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VideoPathList : NSObject
@property (assign , nonatomic) CGFloat speedFlag;

@property (strong, nonatomic) NSMutableArray *picArr;
@property (strong, nonatomic) NSMutableArray *wordArr;
@property (strong, nonatomic) NSMutableArray *selectedBrandArr;

+ (instancetype)sharedInstance;
@end
