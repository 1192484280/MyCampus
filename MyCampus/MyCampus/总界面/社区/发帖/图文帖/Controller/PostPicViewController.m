//
//  PostPicViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PostPicViewController.h"
#import "PostPicCell.h"
#import "PostPicHeaderView.h"

@interface PostPicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation PostPicViewController

- (UIView *)headerView{
    
    if (!_headerView) {
        
        _headerView = [[PostPicHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.2* ScreenHeight)];
        //_headerView = [[[NSBundle mainBundle]loadNibNamed:@"PostPicHeaderView" owner:self options:nil] objectAtIndex:0];
    }
    return _headerView;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#E9EAEE"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithHexString:@"#E9EAEE"];
    
    [self setNavBar];
    
    [self.view addSubview:self.tableView];
}

- (void)setNavBar{
    
    [self setNavBarHeaderTitle:@"编辑"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.picArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [PostPicCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostPicCell *cell = [PostPicCell tempWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reciveImg:self.picArr[indexPath.row]];
    return cell;
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
