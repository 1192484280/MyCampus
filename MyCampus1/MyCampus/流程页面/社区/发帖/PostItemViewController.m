//
//  PostItemViewController.m
//  MyCampus
//
//  Created by zhangming on 2017/11/2.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PostItemViewController.h"
#import "PhotoView.h"

@interface PostItemViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerControllerSourceType sourceType;
    
    IBOutlet UITextView *noteText;
    IBOutlet UILabel *plasehoderLa;
    
    IBOutlet NSLayoutConstraint *topHeight;
    
    IBOutlet NSLayoutConstraint *viewHeight;

    IBOutlet UIView *bottonview;
}

@property (weak, nonatomic) UIButton *currentBtn;
@property (strong, nonatomic) NSMutableArray *photoArr;

@end

@implementation PostItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}

- (void)setUI{
    
    topHeight.constant = NAVBAR_HEIGHT;
    viewHeight.constant = ScreenHeight - (NAVBAR_HEIGHT);
    noteText.delegate = self;
    
    PhotoView *view = [[PhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noteText.frame) + 50, ScreenWidth, 116)];
    [view returnText:^(NSArray *photoArr) {
        
        NSLog(@"图片数量%lu",photoArr.count - 1);
    }];
    [bottonview addSubview:view];
    
    [noteText wzb_autoHeightWithMaxHeight:ScreenHeight - (NAVBAR_HEIGHT) - 200 textViewHeightDidChanged:^(CGFloat currentTextViewHeight){
        NSLog(@"");
        
        view.y = currentTextViewHeight + 50;
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length >0) {
        
        plasehoderLa.alpha = 0;
    }else{
        
        plasehoderLa.alpha = 1;
    }
}


- (IBAction)onBackBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
