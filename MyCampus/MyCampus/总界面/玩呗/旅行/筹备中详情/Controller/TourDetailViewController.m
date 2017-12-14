//
//  TourDetailViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/10.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "TourDetailViewController.h"
#import "TourDetailModel.h"


@interface TourDetailViewController ()
{
    
    IBOutlet UILabel *nameLa;
}

@property (strong, nonatomic) TourDetailModel *model;

@end

@implementation TourDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [[TourDetailModel alloc] init];
    [self.model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"name"] && object == self.model) {
        
        nameLa.text = [NSString stringWithFormat:@"%@",[change valueForKey:@"new"]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.model removeObserver:self forKeyPath:@"name"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtn:(UIButton *)sender {
    
    int x = arc4random()%100;
    self.model.name = [NSString stringWithFormat:@"%d",x];
}


@end
