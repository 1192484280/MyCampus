//
//  HeaderCell.h
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCell : UITableViewCell

+ (instancetype)tempWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getHeightWithIndexPath:(NSIndexPath *)indexPath;

+ (instancetype)CellWithIndex:(NSIndexPath *)indexPath;

@property (weak, nonatomic) IBOutlet UIScrollView *sView;

@end
