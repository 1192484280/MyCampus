//
//  MineViewController.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MeHeaderView.h"
#import "SetViewController.h"
#import "PostVideoViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,MeHeaderViewDelegate>

@property (copy , nonatomic) NSArray *titles;
@property (copy , nonatomic) NSArray *images;
@property (strong, nonatomic) UITableView *tableView;
@property (weak , nonatomic) MeHeaderView *headerView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *shareView;

@end

@implementation MineViewController

- (UIView *)shareView{
    
    if (!_shareView) {
        
        _shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] objectAtIndex:0];
        _shareView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 386);
    }
    
    return _shareView;
}

- (UIView *)bgView{
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewClick)]];
    }
    return _bgView;
}

- (void)didBgViewClick
{
    [self onCloseShareViewBtn];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.5;
        _tableView.sectionHeaderHeight = 9.5;
        
        MeHeaderView *headerView = [[MeHeaderView alloc] init];
        headerView.delegate = self;
        headerView.height = 250;
        _tableView.tableHeaderView = headerView;
        self.headerView = headerView;
    }
    
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSArray *)titles{
    
    if (!_titles) {
        _titles = @[@[@"我的消息",@"我的关注"],@[@"我的上传",@"分享有礼"],@[@"问题反馈"]];
    }
    return _titles;
}

- (NSArray *)images{
    
    if (!_images) {
        
        _images = @[@[@"icon_news",@"icon_mylike"],@[@"icon_postUp",@"icon_share"],@[@"icon_problem"]];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}


- (void)setup{
    
    [self.view addSubview:self.tableView];
    
    UIApplication *ap = [UIApplication sharedApplication];
    
    [ap.keyWindow addSubview:self.shareView];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MeViewCellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeViewCellId];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeViewCellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        
    }
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.section][indexPath.row]];
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    
                    [self myInfo];
                    break;
                case 1:
                    
                    [self myCare];
                    break;
                default:
                    break;
            }
            break;
        
        case 1:
            switch (indexPath.row) {
                case 0:
                    
                    [self myUp];
                    break;
                
                case 1:
                    
                    [self myShare];
                    break;
                default:
                    break;
            }
            break;
            
         case 2:
            switch (indexPath.row) {
                case 0:
                    
                    [self myProblem];
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
}

#pragma mark - 上传视频
- (void)onLeft{
    
    PostVideoViewController *VC = [[PostVideoViewController alloc] init];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 巡逻
- (void)onRight{
    
}

#pragma mark - 登陆
- (void)onLogin{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - 天气
- (void)onWeather{
    
    NSLog(@"天气");
}

#pragma mark - 设置
- (void)onSetting{
    
    NSLog(@"设置");
    SetViewController *VC = [[SetViewController alloc] init];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 我的消息
- (void)myInfo{
    
    
}

#pragma mark - 我的关注
- (void)myCare{
    
}

#pragma mark - 我的上传
- (void)myUp{
    
}

#pragma mark - 分享有礼
- (void)myShare{
    
    [self.view insertSubview:self.bgView belowSubview:self.shareView];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.shareView.y = ScreenHeight - 270 - (iPhoneX_Bottom);
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
    } completion:nil];
}

#pragma mark - 问题反馈
- (void)myProblem{
    
}
- (IBAction)onCloseShareViewBtn{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.shareView.y = ScreenHeight;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
