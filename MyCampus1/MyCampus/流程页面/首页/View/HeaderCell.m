//
//  HeaderCell.m
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

+ (instancetype)tempWithTableView:(UITableView *)tableView{
    
    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    CLASSNAME
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getHeight{
    
    UITableViewCell *cell = [HeaderCell Cell];
    return cell.frame.size.height;
}

+ (instancetype)Cell{
    
    CLASSNAME
    return [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
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
