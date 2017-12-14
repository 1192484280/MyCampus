//
//  PostPicCell.m
//  MyCampus
//
//  Created by zhangming on 2017/11/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PostPicCell.h"

@implementation PostPicCell

+ (instancetype)tempWithTableView:(UITableView *)tableView{
    
    PostPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (!cell) {
        
        CLASSNAME
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    }
    
    return cell;
}

+ (CGFloat)getHeight{
    
    UITableViewCell *cell = [PostPicCell cell];
    
    return cell.frame.size.height;
}

+ (UITableViewCell *)cell{
    
    CLASSNAME
    return [[[NSBundle mainBundle]loadNibNamed:className owner:self options:nil] objectAtIndex:0];
}

- (void)reciveImg:(UIImage *)img{
    
    self.img.image = img;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
