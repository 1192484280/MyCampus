//
//  MineViewController.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "MineViewController.h"

#import "MeHeaderView.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,MeHeaderViewDelegate>

@property (copy , nonatomic) NSArray *titles;
@property (copy , nonatomic) NSArray *images;
@property (weak, nonatomic) UITableView *tableView;
@property (weak , nonatomic) MeHeaderView *headerView;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSArray *)titles{
    
    if (!_titles) {
        _titles = @[@[@"我的资料",@"我的收藏"],@[@"分享有礼",@"系统设置"]];
    }
    return _titles;
}

- (NSArray *)images{
    
    if (!_images) {
        
        _images = @[@[@"mine_dianziqianbao",@"mine_shoucang"],@[@"my_subscribe",@"icon_myset"]];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setupNavBar];
    
    [self setup];
    
}


- (void)setup{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//    tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
//    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MeHeaderView *headerView = [[MeHeaderView alloc] init];
    headerView.delegate = self;
    headerView.height = 250;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
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
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.5;
    }else{
        return 9.5;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - 优惠券
- (void)onLeft{
    
}

#pragma mark - 我的积分
- (void)onRight{
    
}

- (void)onLogin{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
