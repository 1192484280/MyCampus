//
//  SetCell.h
//  MyCampus
//
//  Created by zhangming on 2017/11/15.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLa1;
@property (weak, nonatomic) IBOutlet UILabel *titleLa2;
@property (weak, nonatomic) IBOutlet UILabel *titleLa3;

+ (instancetype)tempWithTableView:(UITableView *)tableView andIndex:(NSInteger)row;
@property (weak, nonatomic) IBOutlet UILabel *chacheLa;

+ (CGFloat)getHeight;

+ (instancetype)Cell;

- (void)reciveInfo:(NSString *)title andIndex:(NSInteger)index;

@end
