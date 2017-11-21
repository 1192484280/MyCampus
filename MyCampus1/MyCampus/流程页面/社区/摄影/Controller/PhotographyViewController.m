//
//  PhotographyViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/17.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PhotographyViewController.h"
#import "PhotographyCell.h"

@interface PhotographyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerview;

@end

@implementation PhotographyViewController

- (UIView *)headerview{
    
    if (!_headerview) {
        
        _headerview = [[[NSBundle mainBundle]loadNibNamed:@"PhotographyHeaderView" owner:self options:nil] objectAtIndex:0];
    }
    return _headerview;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (NAVBAR_HEIGHT)- (TABBAR_HEIGHT) - 21) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0.5;
        _tableView.sectionFooterHeight = 9.5;
        _tableView.tableHeaderView = self.headerview;
        
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
    
    return [PhotographyCell getHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotographyCell *cell = [PhotographyCell tempWithTableView:tableView];
    
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
