//
//  SortOrderView.m
//  ZENWork
//
//  Created by zhangming on 17/4/6.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "SortOrderView.h"

@interface SortOrderView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) UITableView *leftTableView;
@property (weak, nonatomic) UITableView *rightTableView;
@property (copy, nonatomic) NSArray *leftArr;
@property (copy, nonatomic) NSArray *rightArr;
@property (assign, nonatomic) NSInteger leftIndex;
@property (strong, nonatomic) NSMutableArray *selectIndexs;
@end

@implementation SortOrderView

- (NSMutableArray *)selectIndexs
{
    if (!_selectIndexs) {
        _selectIndexs = [NSMutableArray arrayWithObjects:@(0),@(0), nil];
    }
    return _selectIndexs;
}

- (instancetype)initWithFrame:(CGRect)frame andLeftArr:(NSArray *)leftArr andRightArr:(NSArray *)rightArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.leftArr = leftArr;
        self.rightArr  = rightArr;
        [self setup];
    }
    
    return self;
    
}

- (void)setup{
    
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.4, 50 * [self.rightArr count])];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    [leftTableView registerClass:[WaitLeftCell class] forCellReuseIdentifier:@"leftCell"];
    [self addSubview:leftTableView];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView = leftTableView;
    [leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth * 0.4, 0, ScreenWidth * 0.6, 50 * [self.rightArr count])];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    [rightTableView registerClass:[WaitRightCell class] forCellReuseIdentifier:@"rightCell"];
    [self addSubview:rightTableView];
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView = rightTableView;
    [rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        
        return [self.leftArr[1] count];
    }else{
        
        return [self.rightArr[self.leftIndex] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        WaitLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        cell.imageView.image = [UIImage imageNamed:self.leftArr[0][indexPath.row]];
        cell.textLabel.text = self.leftArr[1][indexPath.row];
        cell.index = indexPath.row;
        return cell;
        
    }else{
        
        WaitRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        cell.textLabel.text = self.rightArr[self.leftIndex][indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.leftTableView) {
        
        self.leftIndex = indexPath.row;
        [self.rightTableView reloadData];
        NSInteger row = [self.selectIndexs[indexPath.row] integerValue];
        [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        
        
    }else{
        
        [self.selectIndexs replaceObjectAtIndex:self.leftIndex withObject:@(indexPath.row)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedIndexPath:)]) {
            
            [self.delegate didSelectedIndexPath:indexPath];
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftTableView.height = self.height;
    self.rightTableView.height = self.height;
}

@end

@interface WaitLeftCell ()
@property (copy, nonatomic) NSArray *selectImg;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation WaitLeftCell

- (NSArray *)selectImg
{
    if (!_selectImg) {
        _selectImg = @[@[@"icon_filter_timeType_normal",@"icon_filter_timeType_normal"], @[@"icon_filter_timeType_selected",@"icon_filter_timeType_selected"]];
    }
    return _selectImg;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSString *imageName;
    if (selected) {
        imageName = self.selectImg[1][self.index];
    }else {
        imageName = self.selectImg[0][self.index];
    }
    self.imageView.image = [UIImage imageNamed:imageName];
    
    self.backgroundColor = selected ? [UIColor colorWithHexString:@"#f6f6f6"] : [UIColor whiteColor];
}

@end

@interface WaitRightCell ()

@property (weak, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation WaitRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duigou"]];
        icon.width = 15;
        icon.height = 10;
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.icon.hidden = !selected;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.icon.x = self.width - 15 - self.icon.width;
    self.icon.centerY = self.height / 2;
    self.lineView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

@end
