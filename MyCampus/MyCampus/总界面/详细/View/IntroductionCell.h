//
//  IntroductionCell.h
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroductionCell : UITableViewCell

@property (copy, nonatomic) NSString *imgName;

@property (strong, nonatomic) IBOutlet UIImageView *im;

+ (instancetype)tempWithTableView:(UITableView *)tableView;

+ (CGFloat)getHeight;

+ (instancetype)Cell;

@end
