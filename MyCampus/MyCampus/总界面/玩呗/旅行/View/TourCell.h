//
//  TourCell.h
//  MyCampus
//
//  Created by zhangming on 2017/11/10.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourModel.h"

@interface TourCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) TourModel *model;

@end
