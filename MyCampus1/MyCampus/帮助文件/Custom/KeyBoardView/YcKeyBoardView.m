
#import "YcKeyBoardView.h"

#define ButtonWidth 60

@interface YcKeyBoardView()<UITextViewDelegate>

@property (nonatomic,assign) CGFloat textViewWidth;
@property (nonatomic,assign) BOOL isChange;
@property (nonatomic,assign) BOOL reduce;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;

@end

@implementation YcKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        [self initTextView:frame];
        [self initFinishButton];
    }
    return self;
}

- (void)initTextView:(CGRect)frame
{
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    
    self.textView.frame = CGRectMake(10, 10, ScreenWidth - 20, frame.size.height - 60);
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#FDFDFD"];
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#E7E7E8"].CGColor;
    self.textView.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:self.textView];
}

- (void)initFinishButton
{
    UIButton *finishbutton  = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 50, 10 + self.textView.height+10, 50, 30)];
    finishbutton.backgroundColor = [UIColor colorWithHexString:@"#C4C4C4"];
    finishbutton.layer.cornerRadius = 5;
    [finishbutton setTitle:@"发表" forState:UIControlStateNormal];
    [finishbutton setClipsToBounds:YES];
    [self addSubview:finishbutton];
    
    [finishbutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [finishbutton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finishButtonAction
{
    if([self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)])
    {
        [self.delegate keyBoardViewHide:self textView:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([text isEqualToString:@"\n"])
//    {
//        if([self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)])
//        {
//            [self.delegate keyBoardViewHide:self textView:self.textView];
//        }
//        return NO;
//    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
//    NSString *content = textView.text;
//    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:20.0]];
//    if(contentSize.width > self.textViewWidth)
//    {
//      if(!self.isChange)
//      {
//          CGRect keyFrame = self.frame;
//          self.originalKey = keyFrame;
//          keyFrame.size.height += keyFrame.size.height;
//          keyFrame.origin.y -= keyFrame.size.height*0.25;
//          self.frame = keyFrame;
//          
//          CGRect textFrame = self.textView.frame;
//          self.originalText = textFrame;
//          textFrame.size.height += textFrame.size.height*0.5+kStartLocation*0.2;
//          self.textView.frame = textFrame;
//          self.isChange = YES;
//          self.reduce = YES;
//        }
//    }
//    
//    if(contentSize.width <= self.textViewWidth)
//    {
//        if(self.reduce)
//        {
//            self.frame = self.originalKey;
//            self.textView.frame = self.originalText;
//            self.isChange = NO;
//            self.reduce = NO;
//       }
//    }
}

@end
