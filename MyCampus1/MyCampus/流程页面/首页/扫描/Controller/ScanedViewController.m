//
//  ScanedViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/15.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "ScanedViewController.h"

@interface ScanedViewController ()
{
    
    
    IBOutlet UILabel *la;
}
@end

@implementation ScanedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarHeaderTitle:@"扫描结果"];
    
    la.text = self.dic;
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
