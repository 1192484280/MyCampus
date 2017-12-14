//
//  SelectBrandCell.m
//  Fashion
//
//  Created by zhangming on 16/7/20.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import "SelectBrandCell.h"

@implementation SelectBrandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_btn setBackgroundImage:nil forState:0];
    [_btn setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateSelected];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)tempTableViewCellWith:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    
    SelectBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectBrandCELLID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectBrandCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}


#pragma mark - 生成
+ (instancetype)cell
{
    NSString *className = NSStringFromClass([self class]);
    
    return [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    
}

- (void)receveInfo:(BrandSelectInfo *)brandInfo andSelectedBrandArr:(NSArray *)arr{
    
    _la.text = brandInfo.name;
    
    __block BOOL isExist = NO;
    
    
    for (BrandSelectInfo *info in arr) {
        
        if ([_la.text isEqualToString:info.name]) {
            
            isExist = YES;
            
        }
    }
    //重复则跳过
    if (!isExist) {
        
        self.btn.selected = NO;
    }else{
        self.btn.selected = YES;
    }
    
}


@end
