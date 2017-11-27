//
//  ExportEffects
//  VideoTheme
//
//  Created by Johnny Xu(徐景周) on 5/30/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define TrackIDCustom 1

typedef NSString *(^JZOutputFilenameBlock)();
typedef void (^JZFinishVideoBlock)(BOOL success, id result);
typedef void (^JZExportProgressBlock)(NSNumber *percentage);

@interface ExportEffects : NSObject

@property (copy, nonatomic) JZFinishVideoBlock finishVideoBlock;
@property (copy, nonatomic) JZExportProgressBlock exportProgressBlock;
@property (copy, nonatomic) JZOutputFilenameBlock filenameBlock;

@property (nonatomic, strong) NSMutableArray *gifArray;

@property (nonatomic, strong) NSMutableArray *pngArray;

@property (nonatomic,strong) UIImage *image;
@property (nonatomic, copy) NSString *musicFlag;
@property (nonatomic, copy) NSString *flag;//标记上传还是保存到相册
+ (ExportEffects *)sharedInstance;

- (void)addEffectToVideo:(NSString *)videoFilePath withAudioFilePath:(NSString *)audioFilePath withAniBeginTime:(CFTimeInterval)beginTime;
- (void)writeExportedVideoToAssetsLibrary:(NSString *)outputPath;

@end
