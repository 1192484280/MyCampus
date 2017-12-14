//
//  FontController.m
//  Fashion
//
//  Created by zhangming on 16/8/16.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import "FontController.h"

#define CELL @"cellID"
@interface FontController ()
{
    NSArray *fontArr;
}
@end

@implementation FontController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"字体选择";
    
    fontArr = @[ @"AmericanTypewriter", @"Baskerville", @"Copperplate", @"Didot", @"EuphemiaUCAS", @"Futura-Medium", @"GillSans", @"Helvetica", @"Marion-Regular", @"Optima-Regular", @"Palatino-Roman", @"TimesNewRoman", @"Verdana",@"Helvetica",@"HeiTi TC"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return fontArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
    
    cell.textLabel.text = fontArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.fontSuccessBlock)
    {
        NSString *fontName = nil;
        fontName = [fontArr objectAtIndex:indexPath.row];
        
        if (!isStringEmpty(fontName))
        {
            // Dismiss view controller
            [self backButtonAction:nil];
            
            // Call back
            self.fontSuccessBlock(TRUE, fontName);
        }
    }
}

- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//治疗tableviewcell分割线定不到边
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


@end
