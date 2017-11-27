//
//  picView.m
//  Family
//
//  Created by zhangming on 16/6/7.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import "picView.h"
#import "VideoPathList.h"
@implementation picView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
    CircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    
    CGRect _videoContentRect;
    
    UIImage *_image;
}

- (CGRect)getVideoContentRect
{
    return _videoContentRect;
}
- (CGRect)getInnerFrame
{
    return [_imageView.superview convertRect:_imageView.frame toView:_imageView.superview.superview];
}

- (UIImage *)getImage
{
    return _image;
}

- (void)setScale:(CGFloat)scale
{
    [self setScale:scale andScaleY:scale];
}

- (id)initWithImage:(UIImage *)image
{
    int gap = 32;
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+gap, image.size.height+gap)];
    
    if(self)
    {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor redColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"turnoff_icon"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.6;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor redColor];
        _circleView.borderWidth = 2;
        [self addSubview:_circleView];
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}
- (id)initWithLabel:(NSString *)word
{
    int gap = 32;
    self = [super initWithFrame:CGRectMake(0, 0, 30*word.length+gap, 30+gap)];
    
    if(self)
    {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30*word.length, 30)];
        _imageView.layer.borderColor = [[UIColor redColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_imageView.bounds];
        label.text = word;
        label.textColor = [UIColor redColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [_imageView addSubview:label];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"turnoff_icon"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.6;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor redColor];
        _circleView.borderWidth = 2;
        [self addSubview:_circleView];
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}
- (void)pushedDeleteBtn:(id)sender
{
    
    
    picView *nextTarget = nil;
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i = index+1; i < self.superview.subviews.count; ++i)
    {
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[picView class]])
        {
            nextTarget = (picView*)view;
            break;
        }
    }
    
    if(!nextTarget)
    {
        for(NSInteger i = index-1; i >= 0; --i)
        {
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[picView class]])
            {
                nextTarget = (picView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
    [[VideoPathList sharedInstance].picArr removeObject:self];
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    
    [[self class] setActiveStickerView:self];
}

+ (void)setActiveStickerView:(picView*)view
{
    static picView *activeView = nil;
    if(view != activeView)
    {
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        //[activeView.superview bringSubviewToFront:activeView];
    }
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    
    _imageView.layer.borderColor = [UIColor redColor].CGColor;
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
    
    //NSLog(@"中心**%f,%f,坐标%f,%f,%f,%f",_initialPoint.x + p.x,_initialPoint.y + p.y,self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height)
    ;
}

//旋转和缩放
- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    
    
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
    
    
}

- (void)setScale:(CGFloat)scaleX andScaleY:(CGFloat)scaleY
{
    
    _scale = MIN(scaleX, scaleY);
    self.transform = CGAffineTransformIdentity;
    _imageView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 50)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 50)) / 2;
    rct.size.width  = _imageView.width + 50;
    rct.size.height = _imageView.height + 50
    ;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    NSLog(@"%f",_arg);
    self.transform = CGAffineTransformMakeRotation(_arg);
    NSLog(@"旋转缩放后坐标：%f,%f,%f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height),
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}


@end
