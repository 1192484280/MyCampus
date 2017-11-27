//
//  picView.h
//  Family
//
//  Created by zhangming on 16/6/7.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"
#import "UIView+Frame.h"


@interface picView : UIView

@property (strong , nonatomic) UIImage *image;
@property (copy , nonatomic) NSString *title;
+ (void)setActiveStickerView:(picView*)view;
- (id)initWithImage:(UIImage *)image;
- (id)initWithLabel:(NSString *)word;
- (CGRect)getVideoContentRect;
- (CGRect)getInnerFrame;
- (UIImage *)getImage;
- (void)setScale:(CGFloat)scale;
@end
