//
//  PlayCell.h
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayCell : UITableViewCell

- (void)reciveInfo:(NSString *)img;

@property (strong, nonatomic) IBOutlet UIButton *btn;

+ (instancetype)tempWithTableView:(UITableView *)tableView;

+ (CGFloat)getHeight;

+ (instancetype)Cell;

@end
