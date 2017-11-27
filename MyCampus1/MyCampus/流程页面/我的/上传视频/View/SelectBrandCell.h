//
//  SelectBrandCell.h
//  Fashion
//
//  Created by zhangming on 16/7/20.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandSelectInfo.h"
@interface SelectBrandCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *la;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@property (copy , nonatomic) void(^onselectbtnBlock)(UITableViewCell *cell);

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath ;


#pragma mark - 生成
+ (instancetype)cell;

//获取信息
- (void)receveInfo:(BrandSelectInfo *)brandInfo andSelectedBrandArr:(NSArray *)arr;
@end
