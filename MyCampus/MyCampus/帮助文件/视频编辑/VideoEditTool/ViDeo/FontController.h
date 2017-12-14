//
//  FontController.h
//  Fashion
//
//  Created by zhangming on 16/8/16.
//  Copyright © 2016年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FontCallback)(BOOL success, id result);

@interface FontController : UITableViewController

@property (copy, nonatomic) FontCallback fontSuccessBlock;

@end
