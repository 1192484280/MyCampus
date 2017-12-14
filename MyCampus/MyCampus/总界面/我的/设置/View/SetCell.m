//
//  SetCell.m
//  MyCampus
//
//  Created by zhangming on 2017/11/15.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

+ (instancetype)tempWithTableView:(UITableView *)tableView andIndex:(NSInteger)row{
    
    NSString *identity = @"";
    NSInteger index = 0;
    
    switch (row) {
        case 0:
            
            identity = @"CELL";
            index = 0;
            break;
        case 1:
            
            identity = @"CELL1";
            index = 1;
            break;
        default:
            
            identity = @"CELL2";
            index = 2;
            break;
    }
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    CLASSNAME
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:index];
    }
    return cell;
}

+ (CGFloat)getHeight{
    
    UITableViewCell *cell = [SetCell Cell];
    return cell.frame.size.height;
}

+ (instancetype)Cell{
    
    CLASSNAME
    return [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
}

- (void)reciveInfo:(NSString *)title andIndex:(NSInteger)index{
    
    if (index == 0) {
        
        self.titleLa1.text = title;
    }else if (index == 1){
        
        self.titleLa2.text = title;
        self.chacheLa.text = [NSString stringWithFormat:@"%.2fMB",[self readCacheSize]];
    }else {
        
        self.titleLa3.text = title;
    }
}



-( float )readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}


// 遍历文件夹获得文件夹大小，返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
    
}

// 计算 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
