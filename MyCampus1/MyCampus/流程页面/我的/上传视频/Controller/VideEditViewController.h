//
//  VideEditViewController.h
//  Take goods
//
//  Created by zhangming on 17/5/2.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "BaseViewController.h"

@interface VideEditViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *brandLa;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextView *descripTextView;
@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;
@property (weak, nonatomic) IBOutlet UIButton *presonBtn;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;

@property (copy, nonatomic) NSString *videoPath;


@end
