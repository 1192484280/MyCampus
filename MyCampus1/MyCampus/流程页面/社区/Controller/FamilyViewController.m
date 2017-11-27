//
//  FamilyViewController.m
//  MyCampus
//
//  Created by zhangming on 17/7/27.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "FamilyViewController.h"
#import "HeaderViewController.h"
#import "PostItemViewController.h"
#import "PopViewController.h"

#import "SMPagerTabView.h"
#import "TheNewsViewController.h"
#import "ArticleViewController.h"
#import "PhotographyViewController.h"
#import "TZImagePickerController.h"

@interface FamilyViewController ()<UIPopoverPresentationControllerDelegate,SMPagerTabViewDelegate,TZImagePickerControllerDelegate,PopViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *vcArr;
@property (nonatomic, strong) SMPagerTabView *segmentView;
@property (strong, nonatomic) UIButton *postBtn;

@end

@implementation FamilyViewController

- (UIButton *)postBtn{
    
    if (!_postBtn) {
        
        _postBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 100, ScreenHeight - (TABBAR_HEIGHT) - 100, 100, 48)];
        [_postBtn setImage:[UIImage imageNamed:@"icon_myPush"] forState:UIControlStateNormal];
        [_postBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"社区";
    
    [self setNavBar];
    
    [self setUI];
    
}

- (void)setNavBar{
    
    self.title = @"社区";
    
}


#pragma mark - 发布
- (void)onBtn:(UIButton *)btn{
    
    PopViewController* popVC = [PopViewController new];
    popVC.delegate = self;
    popVC.view.backgroundColor = [UIColor whiteColor];
    //设置跳转样式
    popVC.modalPresentationStyle = UIModalPresentationPopover;
//
    //获取popover对象
    UIPopoverPresentationController* popoverVC = popVC.popoverPresentationController;
    //从哪个控制器视图弹出来
    popoverVC.sourceView = self.view;
    //弹出位置
    popoverVC.sourceRect = btn.frame;
    //设置箭头方法
    popoverVC.permittedArrowDirections = UIPopoverArrowDirectionDown;
    //设置弹出控制器视图的大小
    popVC.preferredContentSize = CGSizeMake(300, 143);

    popoverVC.delegate = self;
    [self presentViewController:popVC animated:YES completion:nil];
}


#pragma mark UIPopoverPresentationControllerDelegate
//返回popover自适应的样式(该方法只对iPhone有效.在iPhone下popover的跳转默认为全屏,在该代理中返回UIModalPresentationNone表示取消全屏自适应)
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection
{
    //返回UIModalPresentationNone表示在iPhopne下取消全屏自适应
    return UIModalPresentationNone;
}


- (void)setUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _vcArr = [NSMutableArray array];
    
    TheNewsViewController *vc1 = [[TheNewsViewController alloc]initWithNibName:nil bundle:nil];
    vc1.title = @"新鲜事";
    
    ArticleViewController *vc2 = [[ArticleViewController alloc]initWithNibName:nil bundle:nil];
    vc2.title = @"文章";
    
    PhotographyViewController *vc3 = [[PhotographyViewController alloc]initWithNibName:nil bundle:nil];
    vc3.title = @"摄影";
    
    [_vcArr addObject:vc1];
    [_vcArr addObject:vc2];
    [_vcArr addObject:vc3];
    
    
    self.segmentView.delegate = self;
    //可自定义背景色和tab button的文字颜色等
    //开始构建UI
    [_segmentView buildUI];
    //起始选择一个tab
    [_segmentView selectTabWithIndex:1 animate:NO];
    //显示红点，点击消失
    [_segmentView showRedDotWithIndex:0];
    
    [self.view addSubview:self.postBtn];
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [_vcArr count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return _vcArr[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}

#pragma mark - setter/getter
- (SMPagerTabView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, ScreenWidth, ScreenHeight - (NAVBAR_HEIGHT))];
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

- (void)onTextBtn{
    
    MJWeakSelf
    [self dismissViewControllerAnimated:YES completion:^{
        
        PostItemViewController *VC = [[PostItemViewController alloc] init];
        [weakSelf presentViewController:VC animated:YES completion:^{
            
        }];
    }];
    
    
}

- (void)onPicBtn{
    
    MJWeakSelf
    [self dismissViewControllerAnimated:YES completion:^{
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:50 delegate:self];
        
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
        }];
        
        [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
