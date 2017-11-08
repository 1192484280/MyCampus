//
//  SortOrderView.h
//  ZENWork
//
//  Created by zhangming on 17/4/6.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortOrderViewDelegate <NSObject>

- (void)didSelectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface SortOrderView : UIView

- (instancetype)initWithFrame:(CGRect)frame andLeftArr:(NSArray *)leftArr andRightArr:(NSArray *)rightArr;

@property (strong, nonatomic) id<SortOrderViewDelegate>delegate;

@end

@interface WaitLeftCell : UITableViewCell
@property (assign, nonatomic) NSInteger index;
@end

@interface WaitRightCell : UITableViewCell

@end
