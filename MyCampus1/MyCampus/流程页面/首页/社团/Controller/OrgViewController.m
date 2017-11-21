//
//  OrgViewController.m
//  MyCampus
//
//  Created by zhangming on 17/10/11.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "OrgViewController.h"
#import "IntroductionViewController.h"
#import "OrgList.h"
#import "OrgModel.h"
#import "OrgCell.h"

@interface OrgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *introArray;

@end

@implementation OrgViewController

- (NSArray *)introArray{
    
    if (!_introArray) {
        
        _introArray = @[@[@"img_1",@"img_2",@"img_3",@"img_4",@"img_5",@"img_6",@"img_7",@"img_8",@"img_9"],@[@"lunhua01",@"lunhua02",@"lunhua03",@"lunhua04",@"lunhua05",@"lunhua06",@"lunhua07",@"lunhua08",@"lunhua09"]];
    }
    
    return _introArray;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarHeaderTitle:@"社团"];
    
    [self initData];
    
    [self.view addSubview:self.tableView];
}


- (void)initData{
    
    OrgModel *model = [[OrgModel alloc] init];
    model.uid = @"0";
    model.name = @"鬼步舞社团";
    model.logo = @"guibulogo";
    model.introduce = @"【Heavy Rhythm 鬼步舞社团招收萌新啦！！】团徽代表了我们整个舞团的意志，同时它也被印在了我们的团服上，时刻陪伴我们左右。";
    model.createDate = @"2014/10/10";
    model.likeNum = @"12";
    model.commentNum = @"38";
    model.address = @"留学生公寓";
    [[OrgList sharedInstance].orgArr addObject:model];
    
    OrgModel *model1 = [[OrgModel alloc] init];
    model1.uid = @"1";
    model1.name = @"轮滑社团";
    model1.logo = @"lunhuaLogo";
    model1.introduce = @"这里有训练时留下的汗水 有受伤时留下的泪水 但这里更有八个轮子撑起的梦想轮滑社给予我们的青春不仅仅是玩耍 还有更多的感动 不仅仅给予我们欢笑， 更给了我们一个团体、一个家 ";
    model1.createDate = @"2014/8/10";
    model1.likeNum = @"25";
    model1.commentNum = @"58";
    model1.address = @"泰山广场";
    [[OrgList sharedInstance].orgArr addObject:model1];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [OrgList sharedInstance].orgArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 2.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [OrgCell getHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrgCell *cell = [OrgCell tempWithTableView:tableView];
    
    cell.model = [OrgList sharedInstance].orgArr[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IntroductionViewController *introVC = [[IntroductionViewController alloc] init];
    introVC.listArr = self.introArray[indexPath.section];
    [introVC setHidesBottomBarWhenPushed:YES];
    
    CATransition *animation = [CATransition animation];
    //    rippleEffect
    animation.type = @"rippleEffect";
    animation.subtype = @"fromBottom";
    animation.duration=  1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController pushViewController:introVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
