//
//  TourShowViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/14.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "TourShowViewController.h"
#import "TourShowCell.h"

@interface TourShowViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation TourShowViewController

- (UIView *)headerView{

    if (!_headerView) {

        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TourShowHeaderView" owner:self options:nil] objectAtIndex:0];
        _headerView.size = CGSizeMake(ScreenWidth, 240);
    }
    return _headerView;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavBar];
    
    [self.view addSubview:self.tableView];
}



- (void)setNavBar{
    
    [self setNavBarHeaderTitle:@"旅行完成"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TourShowCell getHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TourShowCell *cell = [TourShowCell tempWithTableView:tableView];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
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
