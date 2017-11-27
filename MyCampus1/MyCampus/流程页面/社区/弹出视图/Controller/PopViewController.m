//
//  PopViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/21.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()

@end

@implementation PopViewController

- (IBAction)onTextBtn:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTextBtn)]) {
        
        [self.delegate onTextBtn];
    }
}

- (IBAction)onPicBtn:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPicBtn)]) {
        
        [self.delegate onPicBtn];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
