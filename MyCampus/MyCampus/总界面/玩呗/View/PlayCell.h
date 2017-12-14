//
//  PlayCell.h
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayCellDelegate <NSObject>

- (void)onSelectedBtnWithIndex:(NSInteger)index;

@end

@interface PlayCell : UITableViewCell

- (void)reciveInfo:(NSString *)img;

@property (strong, nonatomic) IBOutlet UIButton *btn;

/** 协议*/
@property (nonatomic,strong) id<PlayCellDelegate> delegate;

@property (assign, nonatomic) NSInteger rowOfCell;

+ (instancetype)tempWithTableView:(UITableView *)tableView;

+ (CGFloat)getHeight;

+ (instancetype)Cell;

@end
