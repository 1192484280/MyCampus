//
//  FamilyViewController.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "FamilyViewController.h"
#import "HeaderViewController.h"
#import "SortOrderView.h"
#import "FamilyCell.h"
#import "PostItemViewController.h"

#define SortTypeViewHeight 250
@interface FamilyViewController ()<UIPopoverPresentationControllerDelegate,SortOrderViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong , nonatomic) SortOrderView *sortView;
@property (copy, nonatomic) NSArray *leftArr;
@property (copy, nonatomic) NSArray *rightArr;
@property (weak, nonatomic) UIButton *rightBtn;
@property (strong , nonatomic) UIView *bgView;

@end

@implementation FamilyViewController

- (UIView *)bgView{
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight- 64)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewClick)]];
    }
    return _bgView;
}

- (SortOrderView *)sortView{
    
    if (!_sortView) {
        
        _sortView = [[SortOrderView alloc] initWithFrame:CGRectMake(0, 64 - SortTypeViewHeight, ScreenWidth, SortTypeViewHeight) andLeftArr:self.leftArr andRightArr:self.rightArr];
        _sortView.delegate = self;
    }
    return _sortView;
}


- (void)didBgViewClick
{
    [self onRightBtn:self.rightBtn];
}


- (NSArray *)leftArr{
    
    if (!_leftArr) {
        
        _leftArr = @[@[@"icon_filter_timeType_normal"],@[@"时间范围"]];
    }
    return _leftArr;
}

- (NSArray *)rightArr{
    
    if (!_rightArr) {
        
        _rightArr = @[@[@"全部时间",@"今天",@"明天",@"一周内",@"一个月内"]];
    }
    return _rightArr;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0.5;
        _tableView.sectionFooterHeight = 5.5;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"社区";
    
    [self setNavBar];
    
    [self setUI];
    
}

- (void)setUI{
    
    [self.view addSubview:self.tableView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 100, ScreenHeight - (NAVBAR_HEIGHT) - (TABBAR_HEIGHT) , 100, 48)];
    [btn setImage:[UIImage imageNamed:@"icon_myPush"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)setNavBar{
    
    self.title = @"社区";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = BASECOLOR;
    
    //取消导航栏最下面的那一条线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[[UIImage imageNamed:@"typeSelect"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    rightBtn.size = rightBtn.currentImage.size;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [rightBtn addTarget:self action:@selector(onRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.rightBtn = rightBtn;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [FamilyCell getHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FamilyCell *cell = [FamilyCell tempWithTableView:tableView];
    return cell;
    
}

- (void)onBtn:(UIButton *)btn{
    
    PostItemViewController *VC = [[PostItemViewController alloc] init];
    [self presentViewController:VC animated:YES completion:^{
        
    }];
//    HeaderViewController* mapTypeVC = [HeaderViewController new];
//    mapTypeVC.view.backgroundColor = [UIColor whiteColor];
//    //设置跳转样式
//    mapTypeVC.modalPresentationStyle = UIModalPresentationPopover;
//
//    //获取popover对象
//    UIPopoverPresentationController* popoverVC = mapTypeVC.popoverPresentationController;
//    //从哪个控制器视图弹出来
//    popoverVC.sourceView = self.view;
//    //弹出位置
//    popoverVC.sourceRect = btn.frame;
//    //设置箭头方法
//    popoverVC.permittedArrowDirections = UIPopoverArrowDirectionDown;
//    //设置弹出控制器视图的大小
//    mapTypeVC.preferredContentSize = CGSizeMake(320, 120);
//
//    popoverVC.delegate = self;
//    [self presentViewController:mapTypeVC animated:YES completion:nil];
}

#pragma mark UIPopoverPresentationControllerDelegate
//返回popover自适应的样式(该方法只对iPhone有效.在iPhone下popover的跳转默认为全屏,在该代理中返回UIModalPresentationNone表示取消全屏自适应)
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection
{
    //返回UIModalPresentationNone表示在iPhopne下取消全屏自适应
    return UIModalPresentationNone;
}

- (void)onRightBtn:(UIButton *)button{
    
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.view insertSubview:self.bgView belowSubview:self.sortView];
        [UIView animateWithDuration:0.25 animations:^{
            button.transform = CGAffineTransformMakeRotation(M_PI);
            self.sortView.y = 64;
            self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            button.transform = CGAffineTransformIdentity;
            self.sortView.y = 64-SortTypeViewHeight;
            self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
        }];
    }
}

#pragma mark - 选择排序方式
- (void)didSelectedIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *a = [NSString stringWithFormat:@"%@",self.rightArr[indexPath.section][indexPath.row]];
    NSLog(@"%@",a);
    [self onRightBtn:self.rightBtn];
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
