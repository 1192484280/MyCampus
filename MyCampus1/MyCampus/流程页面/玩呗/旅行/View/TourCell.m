//
//  TourCell.m
//  MyCampus
//
//  Created by zhangming on 2017/11/10.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "TourCell.h"

@interface TourCell()

@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *nice;
@property (strong, nonatomic) UILabel *note;
@property (strong, nonatomic) UILabel *comment;
@property (strong, nonatomic) UILabel *like;
@property (strong, nonatomic) UIButton *commentbBtn;
@property (strong, nonatomic) UIButton *likeBtn;
@end

@implementation TourCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identity = @"status";
    TourCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        
        cell = [[TourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *img = [[UIImageView alloc] init];
        img.layer.cornerRadius = 1;
        img.layer.masksToBounds = YES;
        [self.contentView addSubview:img];
        self.img = img;
        
        UILabel *time = [[UILabel alloc] init];
        time.font = [UIFont fontWithName:@"FrLt DFGirl" size:10];
        [self.contentView addSubview:time];
        self.time = time;
        
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont fontWithName:@"FrLt DFGirl" size:17];
        [self.contentView addSubview:title];
        self.title = title;
        
        UILabel *nice = [[UILabel alloc] init];
        nice.font = [UIFont fontWithName:@"FrLt DFGirl" size:10];
        [self.contentView addSubview:nice];
        self.nice = nice;
        
        UILabel *note = [[UILabel alloc] init];
        note.font = [UIFont fontWithName:@"FrLt DFGirl" size:17];
        note.numberOfLines = 2;
        [self.contentView addSubview:note];
        self.note = note;
        
        UILabel *comment = [[UILabel alloc] init];
        comment.font = [UIFont fontWithName:@"FrLt DFGirl" size:10];
        [self.contentView addSubview:comment];
        self.comment = comment;
        
        UILabel *like = [[UILabel alloc] init];
        like.font = [UIFont fontWithName:@"FrLt DFGirl" size:10];
        [self.contentView addSubview:like];
        self.like = like;
        
        UIButton *commentBtn = [[UIButton alloc] init];
        [commentBtn setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [commentBtn addTarget:self action:@selector(onCommentBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:commentBtn];
        self.commentbBtn = commentBtn;
        
        UIButton *likeBtn = [[UIButton alloc] init];
        [likeBtn setImage:[UIImage imageNamed:@"icon_heart"] forState:UIControlStateNormal];
        [likeBtn addTarget:self action:@selector(onLikeBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:likeBtn];
        self.likeBtn = likeBtn;
    }
    
    return self;
    
}

- (void)setModel:(TourModel *)model{
    
    self.img.image = [UIImage imageNamed:model.img.name];
    self.time.text = model.time;
    self.title.text = model.title;
    self.nice.text = model.nice;
    self.note.text = model.intro;
    self.comment.text = model.comment;
    self.like.text = model.like;
    [self setFrame];
}

- (void)setFrame{
    
    __weak typeof(self)vc = self;
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.mas_top).offset(15);
        make.left.equalTo(vc.mas_left).offset(15);
        make.bottom.equalTo(vc.mas_bottom).offset(-15);
        make.width.mas_equalTo(130);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.mas_top).offset(15);
        make.right.right.equalTo(vc.mas_right).offset(-8);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(20);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.mas_top).offset(15);
        make.left.equalTo(self.img.mas_right).offset(8);
        make.right.equalTo(self.time.mas_right).offset(-8);
        make.height.mas_equalTo(20);
    }];
    
    [self.nice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(5);
        make.left.equalTo(self.img.mas_right).offset(8);
        make.right.equalTo(vc.mas_right).offset(-8);
        make.height.mas_equalTo(10);
    }];
    
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(vc.mas_bottom).offset(-15);
        make.right.equalTo(vc.mas_right).offset(-8);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(vc.mas_bottom).offset(-10);
        make.right.equalTo(self.like.mas_left);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(vc.mas_bottom).offset(-15);
        make.right.equalTo(self.likeBtn.mas_left).offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    [self.commentbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(vc.mas_bottom).offset(-10);
        make.right.equalTo(self.comment.mas_left);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nice.mas_bottom).offset(8);
        make.left.equalTo(self.img.mas_right).offset(8);
        make.right.equalTo(vc.mas_right).offset(-8);
        make.bottom.equalTo(self.likeBtn.mas_top).offset(-8);
    }];
}

- (void)onCommentBtn{
    
    
}

- (void)onLikeBtn{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
