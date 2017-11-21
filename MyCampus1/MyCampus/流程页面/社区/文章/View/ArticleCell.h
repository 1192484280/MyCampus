//
//  ArticleCell.h
//  MyCampus
//
//  Created by zhangming on 2017/11/17.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell

+ (instancetype)tempWithTableView:(UITableView *)tableView;

+ (CGFloat)getHeight;

+ (instancetype)Cell;

@end
