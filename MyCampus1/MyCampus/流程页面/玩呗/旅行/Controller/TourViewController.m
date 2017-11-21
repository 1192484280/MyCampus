//
//  TourViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/10.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "TourViewController.h"
#import "TourCell.h"
#import "TourDetailViewController.h"
#import "XRWaterfallLayout.h"
#import "TourCollectionCell.h"
#import "TourShowViewController.h"

@interface TourViewController ()<UITableViewDelegate,UITableViewDataSource,XRWaterfallLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *leftArr;

@property (strong, nonatomic) NSMutableArray *rightArr;

@property (copy, nonatomic) NSArray *listArr;

@property (strong, nonatomic) XRWaterfallLayout *xrLayout;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation TourViewController

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        XRWaterfallLayout *layout = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:8 rowSpacing:8 sectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, ScreenWidth, ScreenHeight - (NAVBAR_HEIGHT)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TourCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    return _collectionView;
}
- (NSMutableArray *)leftArr{
    
    if (!_leftArr) {
        
        _leftArr = [NSMutableArray array];
        
        TourModel *model = [[TourModel alloc] init];
        TourImgModel *imgModel = [[TourImgModel alloc] init];
        imgModel.name = @"lufei";
        imgModel.imageH = 480;
        imgModel.imageW = 320 ;
        model.img = imgModel;
        model.title = @"周末约泰山";
        model.nice = @"张启迪";
        model.time = @"2017/12/05";
        model.intro = @"我们组织周末泰山一日游";
        model.comment = @"22";
        model.like = @"12";
        
        TourModel *model1 = [[TourModel alloc] init];
        TourImgModel *imgModel1 = [[TourImgModel alloc] init];
        imgModel1.name = @"suolong";
        imgModel1.imageH = 888;
        imgModel1.imageW = 500;
        model1.img = imgModel1;
        model1.title = @"周末约泰山";
        model1.nice = @"张启迪";
        model1.time = @"2017/12/05";
        model1.intro = @"我们组织周末泰山一日游";
        model1.comment = @"22";
        model1.like = @"12";
        
        TourModel *model2 = [[TourModel alloc] init];
        TourImgModel *imgModel2 = [[TourImgModel alloc] init];
        imgModel2.name = @"shanzhi";
        imgModel2.imageH = 1036;
        imgModel2.imageW = 700;
        model2.img = imgModel2;
        model2.title = @"周末约泰山";
        model2.nice = @"张启迪";
        model2.time = @"2017/12/05";
        model2.intro = @"我们组织周末泰山一日游";
        model2.comment = @"22";
        model2.like = @"12";
        
        TourModel *model3 = [[TourModel alloc] init];
        TourImgModel *imgModel3 = [[TourImgModel alloc] init];
        imgModel3.name = @"suolong";
        imgModel3.imageH = 888;
        imgModel3.imageW = 500;
        model3.img = imgModel3;
        model3.title = @"周末约泰山";
        model3.nice = @"张启迪";
        model3.time = @"2017/12/05";
        model3.intro = @"我们组织周末泰山一日游";
        model3.comment = @"22";
        model3.like = @"12";
        
        TourModel *model4 = [[TourModel alloc] init];
        TourImgModel *imgModel4 = [[TourImgModel alloc] init];
        imgModel4.name = @"luobin";
        imgModel4.imageH = 647;
        imgModel4.imageW = 500;
        model4.img = imgModel4;
        model4.title = @"周末约泰山";
        model4.nice = @"张启迪";
        model4.time = @"2017/12/05";
        model4.intro = @"我们组织周末泰山一日游";
        model4.comment = @"22";
        model4.like = @"12";
        
        [_leftArr addObject:model];
        [_leftArr addObject:model2];
        [_leftArr addObject:model3];
        [_leftArr addObject:model4];
       
        
    }
    return _leftArr;
}

- (NSMutableArray *)rightArr{
    
    if (!_rightArr) {
        
        _rightArr = [NSMutableArray array];
        
        TourModel *model = [[TourModel alloc] init];
        TourImgModel *imgModel = [[TourImgModel alloc] init];
        imgModel.name = @"fengjing_01";
        imgModel.imageH = 669;
        imgModel.imageW = 480;
        model.img = imgModel;
        model.title = @"周末约泰山";
        model.nice = @"张启迪";
        model.time = @"2017/12/05";
        model.intro = @"我们组织周末泰山一日游";
        model.comment = @"22";
        model.like = @"12";
        
        TourModel *model1 = [[TourModel alloc] init];
        TourImgModel *imgModel1 = [[TourImgModel alloc] init];
        imgModel1.name = @"fengjing_02";
        imgModel1.imageH = 1198;
        imgModel1.imageW = 1200;
        model1.img = imgModel1;
        model1.title = @"周末约泰山";
        model1.nice = @"张启迪";
        model1.time = @"2017/12/05";
        model1.intro = @"我们组织周末泰山一日游";
        model1.comment = @"22";
        model1.like = @"12";
        
        TourModel *model2 = [[TourModel alloc] init];
        TourImgModel *imgModel2 = [[TourImgModel alloc] init];
        imgModel2.name = @"fengjing_03";
        imgModel2.imageH = 500;
        imgModel2.imageW = 500;
        model2.img = imgModel2;
        model2.title = @"周末约泰山";
        model2.nice = @"张启迪";
        model2.time = @"2017/12/05";
        model2.intro = @"我们组织周末泰山一日游";
        model2.comment = @"22";
        model2.like = @"12";
        
        TourModel *model3 = [[TourModel alloc] init];
        TourImgModel *imgModel3 = [[TourImgModel alloc] init];
        imgModel3.name = @"fengjing_04";
        imgModel3.imageH = 500;
        imgModel3.imageW = 500;
        model3.img = imgModel3;
        model3.title = @"周末约泰山";
        model3.nice = @"张启迪";
        model3.time = @"2017/12/05";
        model3.intro = @"我们组织周末泰山一日游";
        model3.comment = @"22";
        model3.like = @"12";
        
        TourModel *model4 = [[TourModel alloc] init];
        TourImgModel *imgModel4 = [[TourImgModel alloc] init];
        imgModel4.name = @"fengjing_05";
        imgModel4.imageH = 2391;
        imgModel4.imageW = 2391;
        model4.img = imgModel4;
        model4.title = @"周末约泰山";
        model4.nice = @"张启迪";
        model4.time = @"2017/12/05";
        model4.intro = @"我们组织周末泰山一日游";
        model4.comment = @"22";
        model4.like = @"12";
        
        TourModel *model5 = [[TourModel alloc] init];
        TourImgModel *imgModel5 = [[TourImgModel alloc] init];
        imgModel5.name = @"fengjing_06";
        imgModel5.imageH = 595;
        imgModel5.imageW = 640;
        model5.img = imgModel5;
        model5.title = @"周末约泰山";
        model5.nice = @"张启迪";
        model5.time = @"2017/12/05";
        model5.intro = @"我们组织周末泰山一日游";
        model5.comment = @"22";
        model5.like = @"12";
        
        TourModel *model6 = [[TourModel alloc] init];
        TourImgModel *imgModel6 = [[TourImgModel alloc] init];
        imgModel6.name = @"fengjing_07";
        imgModel6.imageH = 707;
        imgModel6.imageW = 500;
        model6.img = imgModel6;
        model6.title = @"周末约泰山";
        model6.nice = @"张启迪";
        model6.time = @"2017/12/05";
        model6.intro = @"我们组织周末泰山一日游";
        model6.comment = @"22";
        model6.like = @"12";
        
        TourModel *model7 = [[TourModel alloc] init];
        TourImgModel *imgModel7 = [[TourImgModel alloc] init];
        imgModel7.name = @"fengjing_08";
        imgModel7.imageH = 1244;
        imgModel7.imageW = 700;
        model7.img = imgModel7;
        model7.title = @"周末约泰山";
        model7.nice = @"张启迪";
        model7.time = @"2017/12/05";
        model7.intro = @"我们组织周末泰山一日游";
        model7.comment = @"22";
        model7.like = @"12";
        
        TourModel *model8 = [[TourModel alloc] init];
        TourImgModel *imgModel8 = [[TourImgModel alloc] init];
        imgModel8.name = @"fengjing_09";
        imgModel8.imageH = 1024;
        imgModel8.imageW = 698;
        model8.img = imgModel8;
        model8.title = @"周末约泰山";
        model8.nice = @"张启迪";
        model8.time = @"2017/12/05";
        model8.intro = @"我们组织周末泰山一日游";
        model8.comment = @"22";
        model8.like = @"12";
        
        TourModel *model9 = [[TourModel alloc] init];
        TourImgModel *imgModel9 = [[TourImgModel alloc] init];
        imgModel9.name = @"fengjing_10";
        imgModel9.imageH = 312;
        imgModel9.imageW = 500;
        model9.img = imgModel9;
        model9.title = @"周末约泰山";
        model9.nice = @"张启迪";
        model9.time = @"2017/12/05";
        model9.intro = @"我们组织周末泰山一日游";
        model8.comment = @"22";
        model9.like = @"12";
        
        TourModel *model10 = [[TourModel alloc] init];
        TourImgModel *imgModel10 = [[TourImgModel alloc] init];
        imgModel10.name = @"fengjing_11";
        imgModel10.imageH = 700;
        imgModel10.imageW = 700;
        model10.img = imgModel10;
        model10.title = @"周末约泰山";
        model10.nice = @"张启迪";
        model10.time = @"2017/12/05";
        model10.intro = @"我们组织周末泰山一日游";
        model10.comment = @"22";
        model10.like = @"12";
        
        TourModel *model11 = [[TourModel alloc] init];
        TourImgModel *imgModel11 = [[TourImgModel alloc] init];
        imgModel11.name = @"fengjing_12";
        imgModel11.imageH = 1050;
        imgModel11.imageW = 700;
        model11.img = imgModel11;
        model11.title = @"周末约泰山";
        model11.nice = @"张启迪";
        model11.time = @"2017/12/05";
        model11.intro = @"我们组织周末泰山一日游";
        model11.comment = @"22";
        model11.like = @"12";
        
        TourModel *model12 = [[TourModel alloc] init];
        TourImgModel *imgModel12 = [[TourImgModel alloc] init];
        imgModel12.name = @"fengjing_13";
        imgModel12.imageH = 300;
        imgModel12.imageW = 500;
        model12.img = imgModel12;
        model12.title = @"周末约泰山";
        model12.nice = @"张启迪";
        model12.time = @"2017/12/05";
        model12.intro = @"我们组织周末泰山一日游";
        model12.comment = @"22";
        model12.like = @"12";
        
        [_rightArr addObject:model];
        [_rightArr addObject:model1];
        [_rightArr addObject:model2];
        [_rightArr addObject:model3];
        [_rightArr addObject:model4];
        [_rightArr addObject:model5];
        [_rightArr addObject:model6];
        [_rightArr addObject:model7];
        [_rightArr addObject:model8];
        [_rightArr addObject:model9];
        [_rightArr addObject:model10];
        [_rightArr addObject:model11];
        [_rightArr addObject:model12];
    }
    return _rightArr;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.5;
        _tableView.sectionFooterHeight = 9.5;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    }
    
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    
    [self.view addSubview:self.tableView];
    
    self.listArr = self.leftArr;
    [self.tableView reloadData];
}

- (void)setNavBar{
    
    [self setNavBarHeaderTitle:@""];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"筹备中",@"旅行完成",nil];
    
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    segmentedControl.width = ScreenWidth * 0.4;
    segmentedControl.height = 30;

    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
    
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];

}



- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index) {
            
        case 0:
            
            [self selectmyView1];
            
            break;
            
        case 1:
            
            [self selectmyView2];
            
            break;
        
        default:
            
            break;
            
    }
}

- (void)selectmyView1{
    
    NSLog(@"筹备中");
    [self.collectionView removeFromSuperview];
    [self.view addSubview:self.tableView];
}

- (void)selectmyView2{
    
    NSLog(@"已完成");
    
    
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TourCell *cell = [TourCell cellWithTableView:tableView];
    cell.model = self.listArr[indexPath.section];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TourDetailViewController *VC = [[TourDetailViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    
    TourModel *model = self.rightArr[indexPath.item];
    TourImgModel *img = model.img;
    return img.imageH / img.imageW * itemWidth + 40;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.rightArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TourCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.rightArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TourShowViewController *VC = [[TourShowViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end
