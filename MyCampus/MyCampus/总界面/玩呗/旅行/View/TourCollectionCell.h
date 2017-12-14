//
//  TourCollectionCell.h
//  MyCampus
//
//  Created by zhangming on 2017/11/13.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourModel.h"

@interface TourCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UILabel *like;

@property (strong, nonatomic) TourModel *model;

@end
