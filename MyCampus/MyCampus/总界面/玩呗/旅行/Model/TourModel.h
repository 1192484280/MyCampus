//
//  TourModel.h
//  MyCampus
//
//  Created by zhangming on 2017/11/10.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TourImgModel.h"

@interface TourModel : NSObject

@property (nonatomic, strong) TourImgModel *img;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *nice;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *like;

@end
