//
//  OrgCell.m
//  MyCampus
//
//  Created by zhangming on 17/10/11.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "OrgCell.h"

@implementation OrgCell

+ (instancetype)tempWithTableView:(UITableView *)tableView{
    
    OrgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    CLASSNAME
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getHeight{
    
    UITableViewCell *cell = [OrgCell Cell];
    return cell.frame.size.height;
}

+ (instancetype)Cell{
    
    CLASSNAME
    return [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
}

- (void)setModel:(OrgModel *)model{
    
    NSString *introduce = [NSString stringWithFormat:@"%@",model.introduce];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:introduce attributes:@{NSKernAttributeName : @(4.5f)}];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, introduce.length)];
    self.text.attributedText = attributedString;
    
    self.img.image = [UIImage imageNamed:model.logo];
    self.title.text = model.name;
    self.location.text = model.address;
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
