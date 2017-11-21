//
//  HeaderCell.m
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

+ (instancetype)tempWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identity = @"";
    NSInteger index = 0;
    
    switch (indexPath.section) {
            
        case 0:
            identity = @"CELL";
            index = 0;
            break;
            
        case 1:
            identity = @"CELL2";
            index = 1;
            break;
        default:
            break;
    }
    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    CLASSNAME
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:index];
    }
    return cell;
}

+ (CGFloat)getHeightWithIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [HeaderCell CellWithIndex:indexPath];
    return cell.frame.size.height;
}

+ (instancetype)CellWithIndex:(NSIndexPath *)indexPath{
    
    CLASSNAME
    return [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:indexPath.section];
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
