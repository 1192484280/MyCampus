//
//  HeadHeaderView.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "HeadHeaderView.h"
#import "SDCycleScrollView.h"
#import "YANScrollMenu.h"
#import "DataSource.h"

#define IMG(name) [UIImage imageNamed:name]

@interface HeadHeaderView ()<SDCycleScrollViewDelegate,YANScrollMenuProtocol>
{
    
    NSInteger row;
    NSInteger item;
}

@property (strong, nonatomic) SDCycleScrollView *sdView;
@property (strong, nonatomic) UIView *horView;
@property (strong, nonatomic) SDCycleScrollView *hoSDView;
@property (strong, nonatomic) UILabel *titleLa;
@property (strong, nonatomic) YANScrollMenu *menu;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *recommendView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (copy, nonatomic) NSArray *titlesGroup;
@end

@implementation HeadHeaderView

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ADHeight + 0.5, ScreenWidth, 0.5)];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    
    return _lineView;
}
- (void)createData{
    
    self.dataSource = [NSMutableArray array];
    
    NSArray *images = @[
                        IMG(@"icon_fitment"),
                        IMG(@"icon_fitment"),
                        IMG(@"icon_fitment"),
                        IMG(@"icon_fitment"),
                        IMG(@"icon_study"),
                        IMG(@"icon_study"),
                        IMG(@"icon_study")
                        ];
    NSArray *titles = @[@"社团",
                        @"学习",
                        @"旅游",
                        @"商业街",
                        @"跳蚤市场",
                        @"合租",
                        @"兼职"
                        ];
    
    for (NSUInteger idx = 0; idx< images.count; idx ++) {
        
        DataSource *object = [[DataSource alloc] init];
        object.text = titles[idx];
        object.image = images[idx];
        object.placeholderImage = IMG(@"placeholder");
        
        [self.dataSource addObject:object];
        
    }
    
    
}

#pragma mark - 分类
- (YANScrollMenu *)menu{
    
    if (!_menu) {
        
        _menu = [[YANScrollMenu alloc] initWithFrame:CGRectMake(0, ADHeight, ScreenWidth,CATHeight)];
        _menu.delegate = self;
        
    }
    return _menu;
}

#pragma mark - 左右滑动广告视图
- (SDCycleScrollView *)sdView{
    
    if (!_sdView) {
        
        _sdView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ADHeight) delegate:self placeholderImage:[UIImage imageNamed:@"bg_banner_placeholder"]];
        
        _sdView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        //_sdView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _sdView.autoScrollTimeInterval = 4.0f;
    }
    
    return _sdView;
}


#pragma mark - 上下滚动View
- (UIView *)horView{
    
    if (!_horView) {
        
        _horView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menu.frame), ScreenWidth, HORADHEIGHT)];
        _horView.backgroundColor = [UIColor whiteColor];
        [_horView addSubview:self.titleLa];
        [_horView addSubview:self.hoSDView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(HORADWIDTH - 0.5, 5, 0.5, HORADHEIGHT - 10)];
        view.backgroundColor = LINECOLOR;
        [_horView addSubview:view];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        view2.backgroundColor = LINECOLOR;
        [_horView addSubview:view2];
    }
    return _horView;
}

- (NSArray *)titlesGroup{
    
    if (!_titlesGroup) {
        
        _titlesGroup = @[@"星期一，大盘鸡特价！",@"星期二，iphoneX免费送！",@"星期三，徒步招伙伴！",@"星期天，球场演唱会，欢迎来战！"];
    }
    
    return _titlesGroup;
}
- (UILabel *)titleLa{
    
    if (!_titleLa) {
        
        _titleLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HORADWIDTH, HORADHEIGHT)];
        _titleLa.text = @"今日头条";
        _titleLa.font = [UIFont fontWithName:@"MFLiHei_Noncommercial-Regular" size:15];
        _titleLa.textColor = [UIColor redColor];
        _titleLa.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _titleLa;
}
- (SDCycleScrollView *)hoSDView{
    
    if (!_hoSDView) {
        
        _hoSDView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(HORADWIDTH, 0, ScreenWidth - HORADWIDTH, HORADHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"bg_banner_placeholder"]];
        _hoSDView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _hoSDView.titlesGroup = self.titlesGroup;
        _hoSDView.tintAdjustmentMode = 
        _hoSDView.onlyDisplayText = YES;
        _hoSDView.autoScrollTimeInterval = 4.0f;
        _hoSDView.backgroundColor = [UIColor whiteColor];
    }
    
    return _hoSDView;
}

#pragma mark - 推荐图
- (UIView *)recommendView{
    
    if (!_recommendView) {
        
        _recommendView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.horView.frame), ScreenWidth, RECOMMENDHEIGHT)];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:_recommendView.bounds];
        image.image = [UIImage imageNamed:@"recommend_img"];
        [_recommendView addSubview:image];
    }
    return _recommendView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self setUI];
    }
    
    return self;
}

- (void)setUI{
    
    [self addSubview:self.sdView];
    [self addSubview:self.lineView];
    [self addSubview:self.menu];
    [self addSubview:self.horView];
    [self addSubview:self.recommendView];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self createData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.menu reloadData];
            
        });
    });
}

- (void)setADArray:(NSArray *)ADArray{
    
    //self.sdView.imageURLStringsGroup = ADArray;
    self.sdView.localizationImageNamesGroup = ADArray;
    self.hoSDView.localizationImageNamesGroup = ADArray;
}

- (NSUInteger)numberOfItemsForEachRowInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return 4;
}

- (NSUInteger)numberOfRowsForEachPageInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return 2;
}

- (NSUInteger)numberOfMenusInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return self.dataSource.count;
}
- (id<YANMenuObject>)scrollMenu:(YANScrollMenu *)scrollMenu objectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger idx = indexPath.section * 4 + indexPath.row;
    
    return self.dataSource[idx];
}

- (YANEdgeInsets)edgeInsetsOfItemInScrollMenu:(YANScrollMenu *)scrollMenu{
    
    return YANEdgeInsetsMake(kScale(10), 0, kScale(5), 0, kScale(5));
}

- (void)scrollMenu:(YANScrollMenu *)scrollMenu didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger idx = indexPath.section * 4 + indexPath.row;
    
    DataSource *date = self.dataSource[idx];
    
    NSLog(@"%@",date.text);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCatBtnWithIndex:)]) {
        
        [self.delegate onCatBtnWithIndex:idx];
    }
    
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"点击第%ld张图片",(long)index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDidScrollViewToIndexforUrl:)]) {
        [self.delegate cycleScrollViewDidScrollViewToIndexforUrl:self.sdView.localizationImageNamesGroup[index]];
    }
}

@end
