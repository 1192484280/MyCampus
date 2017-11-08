//
//  FamilyCell.m
//  MyCampus
//
//  Created by zhangming on 2017/11/2.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "FamilyCell.h"

@implementation FamilyCell

+ (instancetype)tempWithTableView:(UITableView *)tableView{
    
    FamilyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    CLASSNAME
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getHeight{
    
    UITableViewCell *cell = [FamilyCell Cell];
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
