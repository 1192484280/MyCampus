//
//  ArticleViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/16.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleCell.h"

@interface ArticleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ArticleViewController

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (iPhoneX_Top)- (TABBAR_HEIGHT) - 21) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0.5;
        _tableView.sectionFooterHeight = 9.5;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [ArticleCell getHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArticleCell *cell = [ArticleCell tempWithTableView:tableView];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
