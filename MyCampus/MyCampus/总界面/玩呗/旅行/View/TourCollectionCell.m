//
//  TourCollectionCell.m
//  MyCampus
//
//  Created by zhangming on 2017/11/13.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "TourCollectionCell.h"

@implementation TourCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TourModel *)model{
    
    self.img.image = [UIImage imageNamed:model.img.name];
    self.comment.text = model.comment;
    self.like.text = model.like;
}
@end
