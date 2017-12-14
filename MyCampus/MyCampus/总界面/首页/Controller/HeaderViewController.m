//
//  HeaderViewController.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "HeaderViewController.h"
#import "HeadHeaderView.h"
#import "HeaderCell.h"
#import "HeaderModel.h"
#import "OrgViewController.h"
#import "JFCityViewController.h"
#import "SearchViewController.h"
#import "ScaningViewController.h"
#import <AVFoundation/AVFoundation.h>

#define IMG(name) [UIImage imageNamed:name]
@interface HeaderViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HeadHeaderViewDelegate,JFCityViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HeadHeaderView *headerView;
@property (copy, nonatomic) NSArray *adArray;
@property (weak, nonatomic) UIButton *searchBtn;
@property (assign, nonatomic) float oldY;
@property (weak, nonatomic) UIImageView *bgImg;
@property (weak, nonatomic) UIVisualEffectView *effectView;
@property (weak, nonatomic) UIBarButtonItem *leftBtn;
@property (copy, nonatomic) NSArray *recomArr;

@end

@implementation HeaderViewController

- (NSArray *)recomArr{
    
    if (!_recomArr) {
        
        _recomArr = @[@"http://static.damai.cn/mapi/2017/07/10/8d357780-4397-47ae-8e35-c0a864087f01.jpg",@"http://static.damai.cn/mapi/2017-07-04/23fff54f-72c1-4af7-9260-c0a2750e8f8e.jpg",@"http://static.damai.cn/mapi/2017-06-26/17cf714a-df89-42f9-a31c-f1d51418eec8.jpg",@"http://static.damai.cn/mapi/2017-05-12/c182ffb9-3af8-4182-b1bf-018b7fc9e8b6.jpg",@"http://static.damai.cn/mapi/2017-06-26/19b67a4b-2483-4fc0-8221-04c07aa685c0.jpg",@"http://static.damai.cn/mapi/2017-07-03/a2534e9e-b108-40b3-a5ab-754870c30233.jpg"];
    }
    
    return _recomArr;
}

-(NSArray *)adArray{
    
    if(!_adArray){
        
        _adArray = @[@"icon_img1",@"icon_img2",@"icon_img3",@"icon_img4",@"icon_img5",@"icon_img6"];
//        _adArray = @[@"http://static.damai.cn/mapi/2017/07/10/8d357780-4397-47ae-8e35-c0a864087f01.jpg",@"http://static.damai.cn/mapi/2017-07-04/23fff54f-72c1-4af7-9260-c0a2750e8f8e.jpg",@"http://static.damai.cn/mapi/2017-06-26/17cf714a-df89-42f9-a31c-f1d51418eec8.jpg",@"http://static.damai.cn/mapi/2017-05-12/c182ffb9-3af8-4182-b1bf-018b7fc9e8b6.jpg",@"http://static.damai.cn/mapi/2017-06-26/19b67a4b-2483-4fc0-8221-04c07aa685c0.jpg",@"http://static.damai.cn/mapi/2017-07-03/a2534e9e-b108-40b3-a5ab-754870c30233.jpg"];
    }
    return _adArray;
}


-(HeadHeaderView *)headerView{
    
    if (!_headerView) {
        
        _headerView = [[HeadHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ADHeight + CATHeight + HORADHEIGHT + RECOMMENDHEIGHT)];
        _headerView.ADArray = self.adArray;
        _headerView.delegate = self;
    }
    return _headerView;
}
-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, iPhoneX_Top, ScreenWidth, ScreenHeight- (iPhoneX_Top) - (TABBAR_HEIGHT)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    //self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self setupNavBar];
    
}



- (void)setupNavBar
{
    //取消导航栏最下面的那一条线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"大连" style:UIBarButtonItemStylePlain target:self action:@selector(messageClick)];
    left.tintColor = [UIColor whiteColor];
    self.leftBtn = left;
    
    UIBarButtonItem *right = [UIBarButtonItem itemWithImageName:@"icon_saomiao_normal" highImageName:@"my" target:self action:@selector(QrCodeClick)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn = searchBtn;
    [searchBtn setTitle:@"搜索趣事、场馆、校花" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#f9f9f9"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"index_search"] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    searchBtn.width = ScreenWidth * 0.6;
    searchBtn.height = 30;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 4;
    [searchBtn addTarget:self action:@selector(onSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchBtn;
    
}

- (void)messageClick{
    
    NSLog(@"消息");
    JFCityViewController *VC = [[JFCityViewController alloc] init];
    VC.delegate = self;
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}

- (void)cityName:(NSString *)name{
    
    NSLog(@"%@",name);
    self.leftBtn.title = name;
    
}

- (void)QrCodeClick{
    
    ScaningViewController *VC = [[ScaningViewController alloc] init];
    [VC setHidesBottomBarWhenPushed:YES];
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.navigationController pushViewController:VC animated:YES];
                    });
                    
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            
            
            [self.navigationController pushViewController:VC animated:YES];
            
        } else if (status == AVAuthorizationStatusDenied) { //
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"摄像头未开启" message:@"开启摄像头，才可以进行扫描" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString * urlStr = @"App-Prefs:root=com.youjiesi.SecurityManager";
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) { if (iOS10) {
                    
                    //iOS10.0以上 使用的操作
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                } else {
                    //iOS10.0以下 使用的操作
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
                }
            }]];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)onSearchBtn{
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [searchVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)setUI{
    
    [self.view addSubview:self.tableView];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, ScreenWidth + 10, ADHeight + 10)];
    bgImg.centerX = ScreenWidth / 2;
    bgImg.image = [UIImage imageNamed:self.adArray[0]];
    bgImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:bgImg atIndex:0];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = bgImg.bounds;
    [bgImg addSubview:effectView];
    self.effectView = effectView;
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, iPhoneX_Top)];
    maskView.backgroundColor = [[UIColor colorWithHexString:@"#e2f9444"] colorWithAlphaComponent:0];
    [self.view insertSubview:maskView atIndex:1];
    self.bgImg = bgImg;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else{
        
        return 5;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}



- (void)cycleScrollViewDidScrollViewToIndexforUrl:(NSString *)url
{
    //[self.bgImg sd_cancelCurrentAnimationImagesLoad];
    self.bgImg.image = [UIImage imageNamed:url];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [HeaderCell getHeightWithIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HeaderCell *cell = [HeaderCell tempWithTableView:tableView andIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    //CGFloat alpha = offsetY / 100;

    //self.navigationController.navigationBar.alpha = alpha;
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[BASECOLOR colorWithAlphaComponent:alpha] size:CGSizeMake(ScreenWidth, NAVBAR_HEIGHT)] forBarMetrics:UIBarMetricsCompact];

    CGFloat H = ADHeight + 10 - offsetY;

    if (offsetY > 0) {
        H = ADHeight + 10;
    }
    self.bgImg.frame = CGRectMake(-5, -5, ScreenWidth + 10, H);
    self.effectView.frame = self.bgImg.bounds;
    
    //tableView sectionheader随cell上移
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 50;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    self.oldY = self.tableView.contentOffset.y;
}

- (void)onCatBtnWithIndex:(NSUInteger)index{
    
    switch (index) {
        case 0:
            
            [self goOrgVC];
            break;
            
        default:
            break;
    }
}

- (void)goOrgVC{
    
    OrgViewController *VC = [[OrgViewController alloc] init];
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
