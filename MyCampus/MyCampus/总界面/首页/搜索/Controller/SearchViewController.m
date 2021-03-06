//
//  SearchViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/10/31.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "SearchViewController.h"
#import "LLSearchNaviBarView.h"
#import "LLSearchVCConst.h"
#import "HistoryAndCategorySearchVC.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatSearchNaviBar];
    
}

- (void)creatSearchNaviBar{
    
    LLSearchNaviBarView *searchNaviBarView = [LLSearchNaviBarView new];
    searchNaviBarView.searbarPlaceHolder = @"请输入搜索关键词";
    
    @LLWeakObj(self);
    [searchNaviBarView showbackBtnWith:[UIImage imageNamed:@"navi_back_w"] onClick:^(UIButton *btn) {
        @LLStrongObj(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [searchNaviBarView setSearchBarBeignOnClickBlock:^{
        @LLStrongObj(self);
        
        HistoryAndCategorySearchVC *searShopVC = [HistoryAndCategorySearchVC new];
        
        //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
        [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
            //            @LLStrongObj(self);
            
            NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
            
        }];
        //执行即时搜索匹配
        NSArray *tempArray =  @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
        
        
        @LLWeakObj(searShopVC);
        [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {
            @LLStrongObj(searShopVC);
            
            //FIXME:这里模拟网络请求数据!!!
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                searShopVC.resultListArray = tempArray;
            });
        }];
        
        //点击了即时匹配选项
        [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
            //            @LLStrongObj(self);
            NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,tempArray[index]);
        }];
        
        [self.navigationController presentViewController:searShopVC animated:NO completion:nil];
        
    }];
    
    [self.view addSubview:searchNaviBarView];
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
