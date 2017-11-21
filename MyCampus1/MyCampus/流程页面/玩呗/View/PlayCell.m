//
//  PlayCell.m
//  MyCampus
//
//  Created by zhangming on 17/7/28.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PlayCell.h"

@implementation PlayCell

+ (instancetype)tempWithTableView:(UITableView *)tableView{
    
    PlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    CLASSNAME
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getHeight{
    
    UITableViewCell *cell = [PlayCell Cell];
    return cell.frame.size.height;
}

+ (instancetype)Cell{
    
    CLASSNAME
    return [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
}

- (void)reciveInfo:(NSString *)img{
    
    
    [self.btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)onSelectedBtn:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectedBtnWithIndex:)]) {
        
        [self.delegate onSelectedBtnWithIndex:self.rowOfCell];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
