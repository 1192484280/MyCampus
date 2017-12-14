//
//  PostPicCell.h
//  MyCampus
//
//  Created by zhangming on 2017/11/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostPicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;

+ (instancetype)tempWithTableView:(UITableView *)tableView;

+ (CGFloat)getHeight;

+ (UITableViewCell *)cell;

- (void)reciveImg:(UIImage *)img;

@end
