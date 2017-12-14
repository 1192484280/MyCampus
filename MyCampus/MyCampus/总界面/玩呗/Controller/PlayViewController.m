//
//  PlayViewController.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayCell.h"
#import "TourViewController.h"

@interface PlayViewController ()<UITableViewDelegate,UITableViewDataSource,PlayCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *imgArr;

@end


@implementation PlayViewController

- (NSArray *)imgArr{
    
    if (!_imgArr) {
        
        _imgArr = @[@"icon_wanBtn_1",@"icon_wanBtn_2",@"icon_wanBtn_3",@"icon_wanBtn_4",@"icon_wanBtn_5"];
    }
    
    return _imgArr;
}
-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"玩呗";
    
    [self.view addSubview:self.tableView];
    
    [self setNavBar];
}

- (void)setNavBar{
    
    self.title = @"玩呗";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.imgArr.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [PlayCell getHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayCell *cell = [PlayCell tempWithTableView:tableView];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.rowOfCell = indexPath.row;
    cell.delegate = self;
    [cell reciveInfo:self.imgArr[indexPath.row]];
    return cell;
}



- (void)onSelectedBtnWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            [self goTour];
            break;
            
        default:
            break;
    }
}

- (void)goTour{
    
    TourViewController *VC = [[TourViewController alloc] init];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
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
