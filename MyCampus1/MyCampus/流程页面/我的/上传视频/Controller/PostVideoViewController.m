//
//  ViewController.m
//  VideoTheme
//
//  Created by Johnny Xu(徐景周) on 6/29/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <StoreKit/StoreKit.h>

#import "PostVideoViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "VideEditViewController.h"
#import "PreView.h"

#define MaxVideoLength MAX_VIDEO_DUR

@interface PostVideoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PBJVideoPlayerControllerDelegate, SKStoreProductViewControllerDelegate, SAVideoRangeSliderDelegate, BTSimpleSideMenuDelegate,PreViewDelegate>
{
    CMPopTipView *_popTipView;
    UIPopoverController* _activePopover;
    NSURL *editedUrl;
    NSString *IFUP_FLAG;//标记上传还是保存到相册
}

@property (strong , nonatomic) AVAudioPlayer *Player2;
@property (copy , nonatomic) NSString *musicFlag;

@property (nonatomic, strong) PBJVideoPlayerController *demoVideoPlayerController;
@property (nonatomic, strong) UIView *demoVideoContentView;
@property (nonatomic, strong) UIImageView *demoPlayButton;

@property (nonatomic, strong) UIScrollView *captureContentView;
@property (nonatomic, strong) UIButton *videoView;

@property (nonatomic, strong) UIScrollView *videoContentView;
@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController;
@property (nonatomic, strong) UIImageView *playButton;
@property (nonatomic, strong) UIButton *closeVideoPlayerButton;

@property (nonatomic, copy) NSURL *videoPickURL;
@property (nonatomic, copy) NSString *audioPickFile;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIButton *demoButton;

@property (nonatomic, strong) SAVideoRangeSlider *videoRangeSlider;
@property (nonatomic, strong) UILabel *videoRangeLabel;
@property (nonatomic) CFTimeInterval startTime;

//动态图
@property (nonatomic, strong) NSMutableArray *gifArray;



@property(nonatomic, strong) BTSimpleSideMenu *sideMenu;


//------------------------------------------------------
@property (nonatomic,strong)YcKeyBoardView *keyboard;
@property (nonatomic, strong) CLTextView *selectedTextView;
@property (nonatomic, assign) BOOL isNewFont;

@property (nonatomic, strong) UIColor *color;

//------------------------------------------------------
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) PreView *preView;
@end

@implementation PostVideoViewController

#pragma mark - 弹出允许权限帮助页
- (void)popupAlertView
{
    DBPrivateHelperController *privateHelper = [DBPrivateHelperController helperForType:DBPrivacyTypeAudio];
    privateHelper.snapshot = [self snapshot];
    privateHelper.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:privateHelper animated:YES completion:nil];
}

- (void)popupAuthorizationHelper:(id)type
{
    DBPrivateHelperController *privateHelper = [DBPrivateHelperController helperForType:[type longValue]];
    privateHelper.snapshot = [self snapshot];
    privateHelper.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:privateHelper animated:YES completion:nil];
}

- (UIImage *)snapshot
{
    id <UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    UIGraphicsBeginImageContextWithOptions(appDelegate.window.bounds.size, NO, appDelegate.window.screen.scale);
    [appDelegate.window drawViewHierarchyInRect:appDelegate.window.bounds afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

#pragma mark - File Helper
- (AVURLAsset *)getURLAsset:(NSString *)filePath
{
    NSURL *videoURL = getFileURL(filePath);
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    return asset;
}

#pragma mark - Delete Temp Files
- (void)deleteTempDirectory
{
    NSString *dir = NSTemporaryDirectory();
    deleteFilesAt(dir, @"mov");
}

#pragma mark - 底部弹出选择相册或拍摄alert
- (void)showCustomActionSheetByView:(UIView *)anchor
{
    UIView *locationAnchor = anchor;
    
    NSString *videoTitle = [NSString stringWithFormat:@"%@", @"选择视频"];
    JGActionSheetSection *sectionVideo = [JGActionSheetSection sectionWithTitle:videoTitle
                                                                        message:nil
                                                                   buttonTitles:@[
                                                                                  GBLocalizedString(@"拍摄"),
                                                                                  GBLocalizedString(@"相册")
                                                                                  ]
                                                                    buttonStyle:JGActionSheetButtonStyleDefault];
    [sectionVideo setButtonStyle:JGActionSheetButtonStyleOrange forButtonAtIndex:0];
    [sectionVideo setButtonStyle:JGActionSheetButtonStyleOrange forButtonAtIndex:1];
    
    NSArray *sections = (iPad ? @[sectionVideo] : @[sectionVideo, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[GBLocalizedString(@"取消")] buttonStyle:JGActionSheetButtonStyleCancel]]);
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath)
     {
         NSLog(@"indexPath: %ld; section: %ld", (long)indexPath.row, (long)indexPath.section);
         
         if (indexPath.section == 0)
         {
             if (indexPath.row == 0)
             {
                 // Check permission for Video & Audio
                 [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted)
                  {
                      if (!granted)
                      {
                          [self performSelectorOnMainThread:@selector(popupAlertView) withObject:nil waitUntilDone:YES];
                          return;
                      }
                      else
                      {
                          [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
                           {
                               if (!granted)
                               {
                                   [self performSelectorOnMainThread:@selector(popupAuthorizationHelper:) withObject:[NSNumber numberWithLong:DBPrivacyTypeCamera] waitUntilDone:YES];
                                   return;
                               }
                               else
                               {
                                   // Has permisstion
                                   [self performSelectorOnMainThread:@selector(pickBackgroundVideoFromCamera) withObject:nil waitUntilDone:NO];
                               }
                           }];
                      }
                  }];
             }
             else if (indexPath.row == 1)
             {
                 // Check permisstion for photo album
                 ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
                 if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
                 {
                     [self performSelectorOnMainThread:@selector(popupAuthorizationHelper:) withObject:[NSNumber numberWithLong:DBPrivacyTypePhoto] waitUntilDone:YES];
                     return;
                 }
                 else
                 {
                     // Has permisstion to execute
                     [self performSelector:@selector(pickBackgroundVideoFromPhotosAlbum) withObject:nil afterDelay:0.1];
                 }
             }
         }
         
         [sheet dismissAnimated:YES];
     }];
    
    if (iPad)
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        CGPoint point = (CGPoint){ CGRectGetMidX(locationAnchor.bounds), CGRectGetMaxY(locationAnchor.bounds) };
        point = [self.navigationController.view convertPoint:point fromView:locationAnchor];
        
        [sheet showFromPoint:point inView:self.navigationController.view arrowDirection:JGActionSheetArrowDirectionTop animated:YES];
    }
    else
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        [sheet showInView:self.navigationController.view animated:YES];
    }
}

- (void)showCustomActionSheetByNav:(UIBarButtonItem *)barButtonItem withEvent:(UIEvent *)event
{
    UIView *anchor = [event.allTouches.anyObject view];
    [self showCustomActionSheetByView:anchor];
}

#pragma mark - SAVideoRangeSliderDelegate
- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    self.startTime = leftPosition;
    if (self.startTime < 0.5)
    {
        self.startTime = 0.5f;
    }
}

#pragma mark - PBJVideoPlayerControllerDelegate
- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    //NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
    if (videoPlayer == _videoPlayerController)
    {
        _playButton.alpha = 1.0f;
        _playButton.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _playButton.alpha = 0.0f;
        } completion:^(BOOL finished)
         {
             _playButton.hidden = YES;
         }];
    }
    else if (videoPlayer == _demoVideoPlayerController)
    {
        _demoPlayButton.alpha = 1.0f;
        _demoPlayButton.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _demoPlayButton.alpha = 0.0f;
        } completion:^(BOOL finished)
         {
             _demoPlayButton.hidden = YES;
         }];
    }
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
    if (videoPlayer == _videoPlayerController)
    {
        _playButton.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _playButton.alpha = 1.0f;
        } completion:^(BOOL finished)
         {
             
         }];
    }
    else if (videoPlayer == _demoVideoPlayerController)
    {
        _demoPlayButton.hidden = NO;
        
        [UIView animateWithDuration:0.1f animations:^{
            _demoPlayButton.alpha = 1.0f;
        } completion:^(BOOL finished)
         {
             
         }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"info = %@",info);
    
    // 2.
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        [self setPickedVideo:url];
    }
    else
    {
        NSLog(@"Error media type");
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)setPickedVideo:(NSURL *)url
{
    [self setPickedVideo:url checkVideoLength:YES];
}


#pragma mark - pickBackgroundVideoFromPhotosAlbum
- (void)pickBackgroundVideoFromPhotosAlbum
{
    [self pickVideoFromPhotoAlbum];
}

- (void)pickVideoFromPhotoAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // Only movie
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 拍摄
- (void)pickBackgroundVideoFromCamera
{
    [self pickVideoFromCamera];
}

- (void)pickVideoFromCamera
{
    CaptureViewController *captureVC = [[CaptureViewController alloc] init];
    [captureVC setCallback:^(BOOL success, id result)
     {
         if (success)
         {
             NSURL *fileURL = result;
             [self setPickedVideo:fileURL checkVideoLength:NO];
         }
         else
         {
             NSLog(@"Video Picker Failed: %@", result);
         }
     }];
    
    [self presentViewController:captureVC animated:YES completion:^{
        NSLog(@"PickVideo present");
    }];
}

- (void)setPickedVideo:(NSURL *)url checkVideoLength:(BOOL)checkVideoLength
{
    if (!url || (url && ![url isFileURL]))
    {
        NSLog(@"Input video url is invalid.");
        return;
    }
    
    if (checkVideoLength)
    {
        if (getVideoDuration(url) > MaxVideoLength)
        {
            NSString *ok = GBLocalizedString(@"知道了");
            //NSString *error = GBLocalizedString(@"错误");
            NSString *fileLenHint = GBLocalizedString(@"视频超出");
            NSString *seconds = @"秒";
            NSString *hint = [fileLenHint stringByAppendingFormat:@" %.0f ", MaxVideoLength];
            hint = [hint stringByAppendingString:seconds];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"选择视频长度应在15秒以内"
                                                           delegate:nil
                                                  cancelButtonTitle:ok
                                                  otherButtonTitles: nil];
            [alert show];
            
            return;
        }
    }
    
    _videoPickURL = url;
    NSLog(@"Pick background video is success: %@", _videoPickURL);
    
    [self reCalcVideoSize:[url relativePath]];
    
    // Setting
    [self defaultVideoSetting:url];
    
    
}

#pragma mark - Default Setting
- (void)defaultVideoSetting:(NSURL *)url
{
    [self showVideoPlayView:YES];
    _bottomView.alpha = 1;
    editedUrl = url;
    [self playDemoVideo:[url absoluteString] withinVideoPlayerController:_videoPlayerController];
    [self initResource];
}

#pragma mark - playDemoVideo
- (void)playDemoVideo:(NSString*)inputVideoPath withinVideoPlayerController:(PBJVideoPlayerController*)videoPlayerController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        videoPlayerController.videoPath = inputVideoPath;
        [videoPlayerController playFromBeginning];
    });
}

#pragma mark - StopAllVideo
- (void)stopAllVideo
{
    if (_videoPlayerController.playbackState == PBJVideoPlayerPlaybackStatePlaying)
    {
        [_videoPlayerController stop];
    }
}

#pragma mark - BTSimpleSideMenuDelegate动态图
-(void)BTSimpleSideMenu:(BTSimpleSideMenu *)menu didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Item Cliecked : %ld", (long)index);
    
    NSInteger styleIndex = index+1;
    [self initEmbededGifView:styleIndex];
    
    if (styleIndex != NSNotFound)
    {
        //NSString *musicFile = [NSString stringWithFormat:@"Theme_%lu.m4a", (long)styleIndex];
        _audioPickFile = nil;
    }
    else
    {
        _audioPickFile = nil;
    }
    
    
}

- (void)initEmbededGifView:(NSInteger)styleIndex
{
    // Only 1 embeds gif is supported now
    //[self clearEmbeddedGifArray];
    
    NSString *imageName = [NSString stringWithFormat:@"Theme_%lu.gif", (long)styleIndex];
    StickerView *view = [[StickerView alloc] initWithFilePath:getFilePath(imageName)];
    CGFloat ratio = MIN( self.videoContentView.width / view.width, self.videoContentView.height / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.videoContentView.width/2, self.videoContentView.height/2);
    [_videoContentView addSubview:view];
    
    [StickerView setActiveStickerView:view];
    
    if (!_gifArray)
    {
        _gifArray = [NSMutableArray arrayWithCapacity:1];
    }
    [_gifArray addObject:view];
    
    [view setDeleteFinishBlock:^(BOOL success, id result) {
        if (success)
        {
            if (_gifArray && [_gifArray count] > 0)
            {
                if ([_gifArray containsObject:result])
                {
                    [_gifArray removeObject:result];
                }
            }
        }
    }];
    
    [[ExportEffects sharedInstance] setGifArray:_gifArray];
}

-(void)BTSimpleSideMenu:(BTSimpleSideMenu *)menu selectedItemTitle:(NSString *)title
{
    NSLog(@"Menu Clicked, Item Title : %@", title);
}

- (void)hidSliderMenu{
    
    [self hiddenStoryboardAndPoster];
}
#pragma mark - getNextStepCondition
- (BOOL)getNextStepRunCondition
{
    BOOL result = TRUE;
    if (!_videoPickURL)
    {
        result = FALSE;
    }
    
    return result;
}


#pragma mark - Show/Hide
- (void)showVideoPlayView:(BOOL)show
{
    if (show)
    {
        _videoContentView.hidden = NO;
        _closeVideoPlayerButton.hidden = NO;
        
        _videoView.hidden = YES;
    }
    else
    {
        [self stopAllVideo];
        
        _videoView.hidden = NO;
        
        _videoContentView.hidden = YES;
        _closeVideoPlayerButton.hidden = YES;
    }
}

#pragma mark - reCalc on the basis of video size & view size
- (void)adjustVideoRangeSlider:(BOOL)referVideoContentView
{
    CGFloat gap = 5;
    CGRect referRect = _videoContentView.frame;
    if (!referVideoContentView)
    {
        referRect = _captureContentView.frame;
    }
    _videoRangeLabel.frame = CGRectMake(CGRectGetMinX(_videoRangeLabel.frame), CGRectGetMinY(referRect) - gap - CGRectGetHeight(_videoRangeLabel.frame), CGRectGetWidth(_videoRangeLabel.frame), CGRectGetHeight(_videoRangeLabel.frame));
    _videoRangeSlider.frame = CGRectMake(CGRectGetMaxX(_videoRangeLabel.frame) + gap, CGRectGetMinY(_videoRangeLabel.frame), CGRectGetWidth(_videoRangeSlider.frame), CGRectGetHeight(_videoRangeSlider.frame));
}

- (void)reCalcVideoSize:(NSString *)videoPath
{
    CGFloat statusBarHeight = iOS7AddStatusHeight;
    CGFloat navHeight = 0; //CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGSize sizeVideo = [self reCalcVideoViewSize:videoPath];
    _videoContentView.frame =  CGRectMake(CGRectGetMidX(self.view.frame) - sizeVideo.width/2, CGRectGetMidY(self.view.frame) - sizeVideo.height/2 + statusBarHeight + navHeight, sizeVideo.width, sizeVideo.height);
    _videoPlayerController.view.frame = _videoContentView.bounds;
    _playButton.center = _videoPlayerController.view.center;
    _closeVideoPlayerButton.center = _videoContentView.frame.origin;
    
    if (_videoPickURL)
    {
        [self createVideoRangeSlider:_videoPickURL];
        //[self adjustVideoRangeSlider:YES];
        
        //        [self.view bringSubviewToFront:_sideMenu];
        //        [_sideMenu show];
    }
}

- (CGSize)reCalcVideoViewSize:(NSString *)videoPath
{
    CGSize resultSize = CGSizeZero;
    if (isStringEmpty(videoPath))
    {
        return resultSize;
    }
    
    UIImage *videoFrame = getImageFromVideoFrame(getFileURL(videoPath), kCMTimeZero);
    if (!videoFrame || videoFrame.size.height < 1 || videoFrame.size.width < 1)
    {
        return resultSize;
    }
    
    NSLog(@"reCalcVideoViewSize: %@, width: %f, height: %f", videoPath, videoFrame.size.width, videoFrame.size.height);
    
    CGFloat statusBarHeight = 0; //iOS7AddStatusHeight;
    CGFloat navHeight = 0; //CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGFloat gap = 15;
    CGFloat height = CGRectGetHeight(self.view.frame) - navHeight - statusBarHeight - 2*gap;
    CGFloat width = CGRectGetWidth(self.view.frame) - 2*gap;
    if (height < width)
    {
        width = height;
    }
    else if (height > width)
    {
        height = width;
    }
    CGFloat videoHeight = videoFrame.size.height, videoWidth = videoFrame.size.width;
    CGFloat scaleRatio = videoHeight/videoWidth;
    CGFloat resultHeight = 0, resultWidth = 0;
    if (videoHeight <= height && videoWidth <= width)
    {
        resultHeight = videoHeight;
        resultWidth = videoWidth;
    }
    else if (videoHeight <= height && videoWidth > width)
    {
        resultWidth = width;
        resultHeight = height*scaleRatio;
    }
    else if (videoHeight > height && videoWidth <= width)
    {
        resultHeight = height;
        resultWidth = width/scaleRatio;
    }
    else
    {
        if (videoHeight < videoWidth)
        {
            resultWidth = width;
            resultHeight = height*scaleRatio;
        }
        else if (videoHeight == videoWidth)
        {
            resultWidth = width;
            resultHeight = height;
        }
        else
        {
            resultHeight = height;
            resultWidth = width/scaleRatio;
        }
    }
    
    resultSize = CGSizeMake(resultWidth, resultHeight);
    return resultSize;
}

#pragma mark - getOutputFilePath
- (NSString*)getOutputFilePath
{
    NSString* mp4OutputFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"outputMovie.mov"];
    return mp4OutputFile;
}

#pragma mark - Progress callback
- (void)retrievingProgress:(id)progress title:(NSString *)text
{
    if (progress && [progress isKindOfClass:[NSNumber class]])
    {
        NSString *title = text ?text :@"处理中";
        NSString *currentPrecentage = [NSString stringWithFormat:@"%d%%", (int)([progress floatValue] * 100)];
        ProgressBarUpdateLoading(title, currentPrecentage);
    }
}


#pragma mark - SKStoreProductViewControllerDelegate
// Dismiss contorller
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - NSUserDefaults
//#pragma mark - AppRunCount
//- (void)addAppRunCount
//{
//    NSUInteger appRunCount = [self getAppRunCount];
//    NSInteger limitCount = 6;
//    if (appRunCount < limitCount)
//    {
//        ++appRunCount;
//        NSString *appRunCountKey = @"AppRunCount";
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        [userDefaultes setInteger:appRunCount forKey:appRunCountKey];
//        [userDefaultes synchronize];
//    }
//}

//- (NSUInteger)getAppRunCount
//{
//    NSUInteger appRunCount = 0;
//    NSString *appRunCountKey = @"AppRunCount";
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    if ([userDefaultes integerForKey:appRunCountKey])
//    {
//        appRunCount = [userDefaultes integerForKey:appRunCountKey];
//    }
//    
//    NSLog(@"getAppRunCount: %lu", (unsigned long)appRunCount);
//    return appRunCount;
//}

#pragma mark - 创建播放View
- (void)createVideoView
{
    _parentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _parentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_parentView];
    
    [self createContentView:_parentView];
    [self createVideoPlayView:_parentView];
}

#pragma mark - 添加视频btn
- (void)createContentView:(UIView *)parentView
{
    CGFloat statusBarHeight = 0; //iOS7AddStatusHeight;
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGFloat gap = 15, len = MIN((CGRectGetHeight(self.view.frame) - navHeight - statusBarHeight - 2*gap), (CGRectGetWidth(self.view.frame) - navHeight - statusBarHeight - 2*gap));
    _captureContentView =  [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - len/2, CGRectGetMidY(self.view.frame) - len/2, len, len)];
    [_captureContentView setBackgroundColor:[UIColor clearColor]];
    [parentView addSubview:_captureContentView];
    
    _videoView = [[UIButton alloc] initWithFrame:_captureContentView.frame];
    [_videoView setBackgroundColor:[UIColor clearColor]];
    
    _videoView.layer.cornerRadius = 5;
    _videoView.layer.masksToBounds = YES;
    _videoView.layer.borderWidth = 1.0;
    _videoView.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIImage *addFileImage = [UIImage imageNamed:@"icon_videoAdd"];
    [_videoView setImage:addFileImage forState:UIControlStateNormal];
    [_videoView addTarget:self action:@selector(showCustomActionSheetByView:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:_videoView];
}

#pragma mark - 创建播放图层
- (void)createVideoPlayView:(UIView *)parentView
{
    _videoContentView =  [[UIScrollView alloc] initWithFrame:_captureContentView.frame];
    [_videoContentView setBackgroundColor:[UIColor clearColor]];
    [parentView addSubview:_videoContentView];
    
    // Video player
    _videoPlayerController = [[PBJVideoPlayerController alloc] init];
    _videoPlayerController.delegate = self;
    _videoPlayerController.view.frame = _videoView.bounds;
    _videoPlayerController.view.clipsToBounds = YES;
    
    [self addChildViewController:_videoPlayerController];
    [_videoContentView addSubview:_videoPlayerController.view];
    
    _playButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_button"]];
    _playButton.center = _videoPlayerController.view.center;
    [_videoPlayerController.view addSubview:_playButton];
    
    // Close video player
    UIImage *imageClose = [UIImage imageNamed:@"close"];
    CGFloat width = 60;
    _closeVideoPlayerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_videoContentView.frame) - width/2, CGRectGetMinY(_videoContentView.frame) - width/2, width, width)];
    _closeVideoPlayerButton.center = _captureContentView.frame.origin;
    [_closeVideoPlayerButton setImage:imageClose forState:(UIControlStateNormal)];
    [_closeVideoPlayerButton addTarget:self action:@selector(handleCloseVideo:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:_closeVideoPlayerButton];
    
    _closeVideoPlayerButton.hidden = YES;
}

#pragma mark - 创建帧率view
- (void)createVideoRangeSlider:(NSURL *)videoUrl
{
    [self clearVideoRangeSlider];
    
    _videoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50) videoUrl:videoUrl];
    _videoRangeSlider.delegate = self;
    _videoRangeSlider.bubleText.font = [UIFont systemFontOfSize:12];
    [_videoRangeSlider setPopoverBubbleSize:120 height:60];
    _videoRangeSlider.minGap = 4;
    _videoRangeSlider.maxGap = 4;
    // Purple
    _videoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.768 green: 0.665 blue: 0.853 alpha: 1];
    _videoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.535 green: 0.329 blue: 0.707 alpha: 1];
    [self.view addSubview:_videoRangeSlider];
}

#pragma mark - 创建动态图slider
- (void)createSideMenu
{
    _sideMenu = [[BTSimpleSideMenu alloc]initWithItemTitles:nil
                                              andItemImages:@[
                                                              [UIImage imageNamed:@"Theme_1.gif"],
                                                              [UIImage imageNamed:@"Theme_2.gif"],
                                                              [UIImage imageNamed:@"Theme_3.gif"],
                                                              [UIImage imageNamed:@"Theme_4.gif"],
                                                              [UIImage imageNamed:@"Theme_5.gif"],
                                                              [UIImage imageNamed:@"Theme_6.gif"],
                                                              [UIImage imageNamed:@"Theme_7.gif"],
                                                              [UIImage imageNamed:@"Theme_8.gif"],
                                                              ]
                                        addToViewController:self];
    _sideMenu.delegate = self;
}





- (void)createPopTipView
{
    NSArray *colorSchemes = [NSArray arrayWithObjects:
                             [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:1.0], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkTextColor], nil],
                             nil];
    NSArray *colorScheme = [colorSchemes objectAtIndex:foo4random()*[colorSchemes count]];
    UIColor *backgroundColor = [colorScheme objectAtIndex:0];
    UIColor *textColor = [colorScheme objectAtIndex:1];
    
    NSString *hint = GBLocalizedString(@"点这里开始");
    _popTipView = [[CMPopTipView alloc] initWithMessage:hint];
    if (backgroundColor && ![backgroundColor isEqual:[NSNull null]])
    {
        _popTipView.backgroundColor = backgroundColor;
    }
    if (textColor && ![textColor isEqual:[NSNull null]])
    {
        _popTipView.textColor = textColor;
    }
    
    _popTipView.animation = arc4random() % 2;
    _popTipView.has3DStyle = NO;
    _popTipView.dismissTapAnywhere = YES;
    [_popTipView autoDismissAnimated:YES atTimeInterval:5.0];
    [_popTipView presentPointingAtView:_playButton inView:_parentView animated:YES];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
    
    [self clearEmbeddedGifArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    CATransition * animation = [CATransition animation];
    //    animation.type = @"oglFlip";
    //    animation.subtype = kCATransitionFromLeft;
    //    animation.duration = 0.45;
    //    animation.removedOnCompletion = YES;
    //    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    if (_isFirst)
    {
        //        [self showWaitView];
        //
        //        [self contentResetSizeWithCalc:YES];
        //        [self initData];
        _isFirst = NO;
        
        // Popup default scroll view
        if ([self.assets count] == 1)
        {
            [_borderButton setSelected:YES];
            _selectControlButton = _borderButton;
            
            [self bottomViewControlAction:_borderButton];
        }
        else if ([self.assets count] > 1)
        {
            [_puzzleButton setSelected:YES];
            _selectControlButton = _puzzleButton;
            
            [self bottomViewControlAction:_puzzleButton];
        }
    }
    
    //[D_Main_Appdelegate hiddenPreView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _Player2 = nil;
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _videoPickURL = nil;
    _gifArray = nil;
    _startTime = 1.0f;
    
    
    [self createVideoView];
    
    //底部设置视图
    [self initToolbarView];
    
    
    //创建gif slider
    [self createSideMenu];
    
    // Hint
//    NSInteger appRunCount = [self getAppRunCount], maxRunCount = 6;
//    if (appRunCount < maxRunCount)
//    {
//        [self createPopTipView];
//    }
    //操作提示
    [self createPopTipView];
    
    //[self addAppRunCount];
    
    [self showVideoPlayView:NO];
    
    // Delete temp files
    [self deleteTempDirectory];
    
    
    self.selectStoryBoardStyleIndex = 1;
    _isFirst = YES;
    
    [self setNaviBar];
    

//    [self.view addSubview:self.bgView];
//    
    //[self.view addSubview:self.preView];
}

- (UIView *)preView{
    
    if (!_preView) {
        
        _preView = [[PreView alloc] initWithFrame:CGRectMake(15, 64 - 230, ScreenWidth -30, 230)];
        _preView.delegate = self;
        _preView.layer.cornerRadius = 5;
    }
    
    return _preView;
    
}


- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCancleBtn)]];
    }
    return _bgView;
}



- (void)setNaviBar
{
    [self setNavBarHeaderTitle:@"主题视频"];
    
    UIBarButtonItem *right = [UIBarButtonItem itemWithImageName:@"icon_next_normal" highImageName:@"my" target:self action:@selector(handleConvert)];
    
    self.navigationItem.rightBarButtonItem = right;
    

    [self.view insertSubview:self.preView belowSubview:self.navigationController.navigationBar];
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touchs
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // Deselect
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    [self hiddenStoryboardAndPoster];
    [_sideMenu hide];
}



- (void)handleVideoThemeButton:(UIBarButtonItem *)sender
{
    if (![self getNextStepRunCondition])
    {
        NSString *message = nil;
        message = @"未发现视频";
        showAlertMessage(message, nil);
        return;
    }
    
    [self.view bringSubviewToFront:_sideMenu];
    [_sideMenu toggleMenu];
}

#pragma mark - PreViewDelegate
- (void)onPreBtn{
    
    [self onCancleBtn];
    _Player2 = nil;
    IFUP_FLAG = @"保存到相册";
    [self exput];
}

- (void)onUpBtn{
    
    [self onCancleBtn];
    
    _Player2 = nil;
    IFUP_FLAG = @"上传";
    [self exput];
}

- (void)onCancleBtn{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.preView.y = 64-230;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}
#pragma mark - 导出
- (void)handleConvert
{
    
    if (![self getNextStepRunCondition])
    {
        NSString *message = nil;
        message = @"未发现视频";
        showAlertMessage(message, nil);
        return;
    }
    
    [_sideMenu hide];
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    
    [self.view insertSubview:self.bgView belowSubview:self.preView];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.preView.centerY = self.view.centerY ;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];

    
    
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        
//        _Player2 = nil;
//        IFUP_FLAG = @"保存到相册";
//        [self exput];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"上传视频" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        
//        _Player2 = nil;
//        IFUP_FLAG = @"上传";
//        [self exput];
//        
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//    }]];
//    [self presentViewController:alert animated:YES completion:^{
//        
//    }];
    
}

#pragma mark - 直接导出
- (void)exput{
    
    
    if (_gifArray && [_gifArray count] > 0)
    {
        for (StickerView *view in _gifArray)
        {
            [view setVideoContentRect:_videoContentView.frame];
        }
    }
    
    
    
    ProgressBarShowLoading(@"开始处理");
    
    [[ExportEffects sharedInstance] setExportProgressBlock: ^(NSNumber *percentage) {
        
        // Export progress
        [self retrievingProgress:percentage title:@"处理中"];
    }];
    
    [[ExportEffects sharedInstance] setFinishVideoBlock: ^(BOOL success, id result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (success)
            {
                ProgressBarDismissLoading(GBLocalizedString(@"成功"));
            }
            else
            {
                ProgressBarDismissLoading(GBLocalizedString(@"失败"));
            }
            
            
            NSLog(@"Alert Cancelled");
            
            [NSThread sleepForTimeInterval:1];
            
            // Demo result video
            if (!isStringEmpty([ExportEffects sharedInstance].filenameBlock()))
            {
                NSString *outputPath = [ExportEffects sharedInstance].filenameBlock();
                
                if ([IFUP_FLAG isEqualToString:@"上传"]) {
                    [self goUpVC:outputPath];
                }
                else{
                    
                    [self showDemoVideo:outputPath];
                }
                
                
            }
            
            
            [self showVideoPlayView:TRUE];
        });
    }];
    
    [self contentResetSizeWithCalc:YES];
    [ExportEffects sharedInstance].image = [self captureScrollView:_contentView];
    [ExportEffects sharedInstance].musicFlag = _musicFlag;
    [ExportEffects sharedInstance].flag = IFUP_FLAG;
    [[ExportEffects sharedInstance] addEffectToVideo:[_videoPickURL relativePath] withAudioFilePath:getFilePath(_audioPickFile) withAniBeginTime:_startTime];
}

- (void)contentResetSizeWithCalc:(BOOL)calc
{
    if (calc)
    {
        _contentView.frame = _videoContentView.bounds;
        _contentView.contentSize = self.contentView.frame.size;
    }
    else
    {
        self.contentView.frame = _videoContentView.bounds;
    }
}


- (void)handleCloseVideo:(UIView *)anchor
{
    _Player2 = nil;
    
    _bottomView.alpha = 0;
    [self hiddenStoryboardAndPoster];
    
    [self showVideoPlayView:NO];
    
    [self clearEmbeddedGifArray];
    [self clearVideoRangeSlider];
    
    [_videoPlayerController clearView];
    _videoPickURL = nil;
    
    [self adjustVideoRangeSlider:NO];
    [_contentView removeFromSuperview];
}

#pragma mark - Clear
- (void)clearEmbeddedGifArray
{
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    if (_gifArray && [_gifArray count] > 0)
    {
        for (StickerView *view in _gifArray)
        {
            [view removeFromSuperview];
        }
        
        [_gifArray removeAllObjects];
        _gifArray = nil;
    }
}

- (void)clearVideoRangeSlider
{
    if (_videoRangeLabel)
    {
        [_videoRangeLabel removeFromSuperview];
        _videoRangeLabel = nil;
    }
    
    if (_videoRangeSlider)
    {
        [_videoRangeSlider removeFromSuperview];
        _videoRangeSlider = nil;
    }
}

#pragma mark - showDemoVideo
- (void)showDemoVideo:(NSString *)videoPath
{
    CGFloat statusBarHeight = iOS7AddStatusHeight;
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGSize size = [self reCalcVideoViewSize:videoPath];
    _demoVideoContentView =  [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - size.width/2, CGRectGetMidY(self.view.frame) - size.height/2 - navHeight - statusBarHeight, size.width, size.height)];
    [self.view addSubview:_demoVideoContentView];
    
    // Video player of destination
    _demoVideoPlayerController = [[PBJVideoPlayerController alloc] init];
    _demoVideoPlayerController.view.frame = _demoVideoContentView.bounds;
    _demoVideoPlayerController.view.clipsToBounds = YES;
    _demoVideoPlayerController.videoView.videoFillMode = AVLayerVideoGravityResizeAspect;
    _demoVideoPlayerController.delegate = self;
    //    _demoVideoPlayerController.playbackLoops = YES;
    [_demoVideoContentView addSubview:_demoVideoPlayerController.view];
    
    _demoPlayButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_button"]];
    _demoPlayButton.center = _demoVideoPlayerController.view.center;
    [_demoVideoPlayerController.view addSubview:_demoPlayButton];
    
    // Popup modal view
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeLeft];
    [[KGModal sharedInstance] showWithContentView:_demoVideoContentView andAnimated:YES];
    
    [self playDemoVideo:videoPath withinVideoPlayerController:_demoVideoPlayerController];
}


//-----------------------------------------------------------

- (void)initResource
{
    self.contentView =  [[UIScrollView alloc] initWithFrame:_videoContentView.bounds];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [_videoContentView addSubview:_contentView];
    
    self.freeBgView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    [_freeBgView setBackgroundColor:[UIColor clearColor]];
    
    [_contentView addSubview:_freeBgView];
    
    // Border
    self.bringPosterView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    [_bringPosterView setBackgroundColor:[UIColor clearColor]];
    [_contentView addSubview:_bringPosterView];
    
    
    //[_contentView setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [_contentView addGestureRecognizer:singleTap];
    
    
    self.isNewFont = TRUE;
    self.selectedTextView = nil;
    self.color = kGradientStartColor;
    
    [self initNotify];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap{
    
    [_videoPlayerController clicked];
}


- (void)initToolbarView
{
    
    
    self.bottomControlView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40 - 50, ScreenWidth, 50)];
    
    
    [self initStoryboardView];
    [self initBorderView];
    [self initStickerView];
    [self initFaceView];
    [self initFilterView];
    
    [self.view addSubview:_bottomControlView];
    [self.bottomControlView setContentSize:CGSizeMake(self.bottomControlView.frame.size.width *2, _bottomControlView.frame.size.height)];
    [self.bottomControlView setPagingEnabled:YES];
    [self.bottomControlView setScrollEnabled:NO];
    [_bottomControlView setHidden:YES];
    
    self.bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    
    _bottomView.backgroundColor = NAVBARCOLOR;
    _bottomView.alpha = 0;
    
    _puzzleButton = [[UIButton alloc] init];
    [_puzzleButton setTitle:@"动图"
                   forState:UIControlStateNormal];
    
    _borderButton = [[UIButton alloc] init];
    [_borderButton setTitle:@"边框"
                   forState:UIControlStateNormal];
    
    _stickerButton = [[UIButton alloc] init];
    [_stickerButton setTitle:@"图片"
                    forState:UIControlStateNormal];
    
    _faceButton = [[UIButton alloc] init];
    [_faceButton setTitle:@"化妆"
                 forState:UIControlStateNormal];
    
    _filterButton = [[UIButton alloc] init];
    [_filterButton setTitle:@"音乐"
                   forState:UIControlStateNormal];
    
    _textButton = [[UIButton alloc] init];
    [_textButton setTitle:@"水印"
                   forState:UIControlStateNormal];
    
    [_puzzleButton setTag:1];
    [_borderButton setTag:2];
    [_stickerButton setTag:3];
    [_faceButton setTag:4];
    [_filterButton setTag:5];
    [_textButton setTag:6];
    
    [self controlButtonStyleSettingWithButton:_puzzleButton];
    [self controlButtonStyleSettingWithButton:_borderButton];
    [self controlButtonStyleSettingWithButton:_stickerButton];
    [self controlButtonStyleSettingWithButton:_faceButton];
    [self controlButtonStyleSettingWithButton:_filterButton];
    [self controlButtonStyleSettingWithButton:_textButton];
    
    [_bottomView addSubview:_puzzleButton];
    [_bottomView addSubview:_borderButton];
    [_bottomView addSubview:_stickerButton];
    [_bottomView addSubview:_faceButton];
    [_bottomView addSubview:_filterButton];
    [_bottomView addSubview:_textButton];
    
    [self.view addSubview:_bottomView];
    
    [self.bottomView setContentSize:CGSizeMake( 70 * 6, self.bottomView.frame.size.height)];
    self.bottomView.showsHorizontalScrollIndicator = NO;
//    [self.bottomView setScrollEnabled:NO];
}

- (void)controlButtonStyleSettingWithButton:(UIButton *)sender
{
    sender.frame =  CGRectMake(70*(sender.tag-1), 0, 50, _bottomView.frame.size.height);
    CGFloat fontSize = 18;
    [sender.titleLabel setFont:[UIFont fontWithName:MINIJIANQITI size:fontSize]];
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [sender addTarget:self action:@selector(bottomViewControlAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 选中当前修饰工具
- (void)bottomViewControlAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [_selectControlButton setSelected:NO];
    
    switch (button.tag)
    {
        case 1:
        {
            
            
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _borderButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor clearColor];
                [self.bringPosterView setHidden:NO];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            
            [self hiddenStoryboardAndPoster];
            
            [self.view bringSubviewToFront:_sideMenu];
            [_sideMenu toggleMenu];
            
            break;
        }
        case 2:
        {
            
            [self showScrollView:kBorderScrollView];
            [_sideMenu hide];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _borderButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor clearColor];
                [self.bringPosterView setHidden:NO];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 3:
        {
            
            [self showScrollView:kStickerScrollView];
            [_sideMenu hide];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _stickerButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor clearColor];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 4:
        {
            
            [self showScrollView:kFaceScrollView];
            [_sideMenu hide];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _stickerButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor clearColor];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 5:
        {
            
            [self showScrollView:kFilterScrollView];
            [_sideMenu hide];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _filterButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor clearColor];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 6:
        {
            [_sideMenu hide];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _textButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor clearColor];
            }
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self hiddenStoryboardAndPoster];
            [self initKeyboard];
            self.isNewFont = TRUE;
            
            break;
        }
        default:
            break;
    }
    
    _selectControlButton = button;
    [button setSelected:YES];
    
}

- (CGSize)calcContentSize
{
    CGSize retSize = CGSizeZero;
    //CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 2*D_ToolbarWidth-iOS7AddStatusHeight);
    CGFloat size_width = self.view.frame.size.width;
    CGFloat size_height = size_width * 4 /3.0f;
    if (size_height >= (self.view.frame.size.height-34))
    {
        size_height = self.view.frame.size.height- 34;
        size_width = size_height * 3/4.0f;
    }
    
    retSize.width = size_width;
    retSize.height = size_height;
    return  retSize;
}





- (void)initNotify
{
    // Keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Text edit notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidChange:) name:CLTextViewActiveViewDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidTap:) name:CLTextViewActiveViewDidTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidDoubleTap:) name:CLTextViewActiveViewDidDoubleTapNotification object:nil];
}
#pragma mark - 初始化底部ScrollView
- (void)initStoryboardView
{
    _storyboardView = [[GLStoryboardSelectView alloc] initWithFrameFromPuzzle:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height) picCount:[self.assetsImage count]];
    [_storyboardView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _storyboardView.delegateSelect = self;
    [_bottomControlView addSubview:_storyboardView];
}

- (void)initBorderView
{
    _borderView = [[GLStoryboardSelectView alloc] initWithFrameFromBorder:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_borderView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _borderView.delegateSelect = self;
    [_bottomControlView addSubview:_borderView];
}

- (void)initStickerView
{
    // Sticker view
    _stickerView = [[GLStoryboardSelectView alloc] initWithFrameFromSticker:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_stickerView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _stickerView.delegateSelect = self;
    [_bottomControlView addSubview:_stickerView];
}

- (void)initFaceView
{
    // Face
    _faceView = [[GLStoryboardSelectView alloc] initWithFrameFromFace:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_faceView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _faceView.delegateSelect = self;
    [_bottomControlView addSubview:_faceView];
}

- (void)initFilterView
{
    _filterView = [[GLStoryboardSelectView alloc] initWithFrameFromFilter:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_filterView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _filterView.delegateSelect = self;
    [_bottomControlView addSubview:_filterView];
}


// Puzzle
- (void)didSelectedStoryboardPicCount:(NSInteger)picCount styleIndex:(NSInteger)styleIndex
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[LoadingViewManager sharedInstance] showLoadingViewInView:self.view withText:D_LocalizedCardString(@"Video_Processing")];
        [self contentRemoveView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetViewByStyleIndex:styleIndex imageCount:self.assetsImage.count];
        });
        
    });
}

// Border
- (void)didSelectedBorderIndex:(NSInteger)styleIndex
{
    if (styleIndex == 0)
    {
        self.bringPosterView.image = nil;
        self.freeBgView.backgroundColor = [UIColor clearColor];
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"border_%lu", (long)styleIndex];
    UIImage *posterImage = [UIImage imageNamed:imageName];
    posterImage = [self originImage:posterImage scaleToSize:self.videoContentView.frame.size];
    self.bringPosterView.image = [posterImage stretchableImageWithLeftCapWidth:posterImage.size.width/4.0f topCapHeight:160];
    self.bringPosterView.frame = self.bringPosterView.frame;
    
    self.freeBgView.image = nil;
    self.freeBgView.backgroundColor = [UIColor clearColor];
    self.selectedBoardColor = [UIColor colorWithPatternImage:posterImage];
}

// Sticker
- (void)didSelectedStickerIndex:(NSInteger)styleIndex
{
    NSLog(@"didSelectedStickerIndex: %ld", (long)styleIndex);
    
    NSString *imageName = [NSString stringWithFormat:@"sticker_%lu", (long)styleIndex];
    StickerView *view = [[StickerView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGFloat ratio = MIN( (0.3 * self.videoContentView.width) / view.width, (0.3 * self.videoContentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.videoContentView.width/2, self.videoContentView.height/2);
    
    [_contentView addSubview:view];
    [StickerView setActiveStickerView:view];
    
    int aniTime = 0.5;
    view.alpha = 0.2;
    [UIView animateWithDuration:aniTime
                     animations:^{
                         view.alpha = 1;
                     }
     ];
}

// Face
- (void)didSelectedFaceIndex:(NSInteger)styleIndex
{
    NSLog(@"didSelectedFaceIndex: %ld", (long)styleIndex);
    
    NSString *imageName = [NSString stringWithFormat:@"face_%lu", (long)styleIndex];
    UIImage *imageFace = [UIImage imageNamed:imageName];
    StickerView *view = [[StickerView alloc] initWithImage:imageFace];
    
    CGFloat ratio = MIN( (0.3 * self.videoContentView.width) / view.width, (0.3 * self.videoContentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.videoContentView.width/2, self.videoContentView.height/2);
    
    [self.contentView addSubview:view];
    [StickerView setActiveStickerView:view];
}

// Filter
- (void)didSelectedFilterIndex:(NSInteger)styleIndex
{
    NSString *string = [NSString string];
    switch (styleIndex) {
        case 0:
            string = @"";
            break;
        case 1:
            string = [[NSBundle mainBundle] pathForResource:@"memory" ofType:@"mp4"];
            break;
        case 2:
            string = [[NSBundle mainBundle] pathForResource:@"dream" ofType:@"mp4"];
            break;
        case 3:
            string = [[NSBundle mainBundle] pathForResource:@"rain" ofType:@"mp4"];
            break;
        case 4:
            string = [[NSBundle mainBundle] pathForResource:@"sun" ofType:@"mp4"];
            break;
        default:
            break;
    }
    
    _musicFlag = string;
    NSData *data = [NSData dataWithContentsOfFile:string];
    //初始化音频类 并且添加播放文件
    _Player2 = [[AVAudioPlayer alloc] initWithData:data error:nil];
    
    [_Player2 setNumberOfLoops:1000000];
    [_Player2 prepareToPlay];
    [_Player2 play];
    
    
}

#pragma mark Filters

// lomo,黑白,怀旧,哥特,锐化,淡雅,酒红,清宁,浪漫,光晕,蓝调,梦幻,夜色
-(UIImage *)effectImage:(long)filter withImage:(UIImage*)image
{
    UIImage *imageResult = nil;
    switch (filter)
    {
        case 1:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_lomo];
            break;
        }
        case 2:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_heibai];
            break;
        }
        case 3:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_huaijiu];
            break;
        }
        case 4:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_gete];
            break;
        }
        case 5:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_danya];
            break;
        }
        case 6:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_jiuhong];
            break;
        }
        case 7:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_qingning];
            break;
        }
        case 8:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_langman];
            break;
        }
        case 9:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_guangyun];
            break;
        }
        case 10:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_landiao];
            break;
        }
        case 11:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_menghuan];
            break;
        }
        case 12:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_yese];
            break;
        }
        default:
        {
            // Return original
            imageResult = image;
            break;
        }
    }
    
    return imageResult;
}


- (void)showScrollView:(ScrollViewStatus)status
{
    switch (status)
    {
        case kPuzzleScrollView:
        {
            _storyboardView.hidden = NO;
            _borderView.hidden = YES;
            _filterView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kBorderScrollView:
        {
            _borderView.hidden = NO;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kStickerScrollView:
        {
            _stickerView.hidden = NO;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kFaceScrollView:
        {
            _faceView.hidden = NO;
            _stickerView.hidden = YES;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            
            break;
        }
        case kFilterScrollView:
        {
            _filterView.hidden = NO;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        default:
            break;
    }
}




#pragma mark Puzzle Style

- (void)resetViewByStyleIndex:(NSInteger)index imageCount:(NSInteger)count
{
    @synchronized(self)
    {
        self.selectStoryBoardStyleIndex = index;
        NSString *picCountFlag = @"";
        NSString *styleIndex = @"";
        
        if ([self.assetsImage count] == 1)
        {
            UIImage *image = [self.assetsImage objectAtIndex:0];
            
            CGRect rect = CGRectZero;
            rect.origin.x = 0;
            rect.origin.y = 0;
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            if (width > _contentView.frame.size.width)
            {
                rect.size.width = _contentView.frame.size.width;
                rect.size.height = height*(_contentView.frame.size.width /width);
            }
            else
            {
                rect.size.width = width;
                rect.size.height = height;
            }
            
            rect.origin.x = (_contentView.frame.size.width - rect.size.width)/2.0f;
            if (rect.size.height < self.contentView.frame.size.height)
            {
                rect.origin.y = (_contentView.frame.size.height - rect.size.height)/2.0f;
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            [imageView setClipsToBounds:YES];
            [imageView setBackgroundColor:[UIColor grayColor]];
            [imageView setImage:image];
            
            imageView.userInteractionEnabled = YES;
            UIGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView)];
            [imageView addGestureRecognizer:singleTap];
            
            [_contentView addSubview:imageView];
            imageView = nil;
        }
        else
        {
            switch (count)
            {
                case 2:
                    picCountFlag = @"two";
                    break;
                case 3:
                    picCountFlag = @"three";
                    break;
                case 4:
                    picCountFlag = @"four";
                    break;
                case 5:
                    picCountFlag = @"five";
                    break;
                default:
                    break;
            }
            
            switch (index)
            {
                case 1:
                    styleIndex = @"1";
                    break;
                case 2:
                    styleIndex = @"2";
                    break;
                case 3:
                    styleIndex = @"3";
                    break;
                case 4:
                    styleIndex = @"4";
                    break;
                case 5:
                    styleIndex = @"5";
                    break;
                case 6:
                    styleIndex = @"6";
                    break;
                default:
                    break;
            }
            
            NSString *styleName = [NSString stringWithFormat:@"number_%@_style_%@.plist",picCountFlag,styleIndex];
            NSDictionary *styleDict = [NSDictionary dictionaryWithContentsOfFile:
                                       [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:styleName]];
            if (styleDict)
            {
                CGSize superSize = CGSizeFromString([[styleDict objectForKey:@"SuperViewInfo"] objectForKey:@"size"]);
                superSize = [self sizeScaleWithSize:superSize scale:2.0f];
                
                NSArray *subViewArray = [styleDict objectForKey:@"SubViewArray"];
                for(int j = 0; j < [subViewArray count]; j++)
                {
                    CGRect rect = CGRectZero;
                    UIBezierPath *path = nil;
                    //                ALAsset *asset = [self.assets objectAtIndex:j];
                    UIImage *image = [self.assetsImage objectAtIndex:j]; //[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    
                    NSDictionary *subDict = [subViewArray objectAtIndex:j];
                    if([subDict objectForKey:@"frame"])
                    {
                        rect = CGRectFromString([subDict objectForKey:@"frame"]);
                        rect = [self rectScaleWithRect:rect scale:2.0f];
                        rect.origin.x = rect.origin.x * _contentView.frame.size.width/superSize.width;
                        rect.origin.y = rect.origin.y * _contentView.frame.size.height/superSize.height;
                        rect.size.width = rect.size.width * _contentView.frame.size.width/superSize.width;
                        rect.size.height = rect.size.height * _contentView.frame.size.height/superSize.height;
                    }
                    
                    rect = [self rectWithArray:[subDict objectForKey:@"pointArray"] andSuperSize:superSize];
                    if ([subDict objectForKey:@"pointArray"])
                    {
                        NSArray *pointArray = [subDict objectForKey:@"pointArray"];
                        path = [UIBezierPath bezierPath];
                        if (pointArray.count > 2)
                        {
                            // 当点的数量大于2个的时候
                            for(int i = 0; i < [pointArray count]; i++)
                            {
                                NSString *pointString = [pointArray objectAtIndex:i];
                                if (pointString)
                                {
                                    CGPoint point = CGPointFromString(pointString);
                                    point = [self pointScaleWithPoint:point scale:2.0f];
                                    point.x = (point.x)*_contentView.frame.size.width/superSize.width -rect.origin.x;
                                    point.y = (point.y)*_contentView.frame.size.height/superSize.height -rect.origin.y;
                                    if (i == 0)
                                    {
                                        [path moveToPoint:point];
                                    }
                                    else
                                    {
                                        [path addLineToPoint:point];
                                    }
                                }
                                
                            }
                        }
                        else
                        {
                            [path moveToPoint:CGPointMake(0, 0)];
                            [path addLineToPoint:CGPointMake(rect.size.width, 0)];
                            [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
                            [path addLineToPoint:CGPointMake(0, rect.size.height)];
                        }
                        
                        [path closePath];
                    }
                    
                    
                    MeituImageEditView *imageView = [[MeituImageEditView alloc] initWithFrame:rect];
                    [imageView setClipsToBounds:YES];
                    [imageView setBackgroundColor:[UIColor grayColor]];
                    imageView.tag = j;
                    imageView.realCellArea = path;
                    imageView.tapDelegate = self;
                    [imageView setImageViewData:image];
                    
                    [_contentView addSubview:imageView];
                    imageView = nil;
                }
            }
        }
        
        [_contentView bringSubviewToFront:self.bringPosterView];
        _contentView.contentSize = _contentView.frame.size;
        self.bringPosterView.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentView.contentSize.height);
        
        // Show selectable view
        [self bringSelectableViewToFront];
    }
    
    [self performSelector:@selector(hiddenWaitView) withObject:nil afterDelay:0.5];
}

#pragma mark - 底部图片选择viewShow/Hide
- (void)showStoryboardAndPoster
{
    self.bottomControlView.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomControlView.frame =  CGRectMake(0, self.view.frame.size.height  - 40 - 50, self.view.frame.size.width, 50);
                         _boardAndEditView.frame =  CGRectMake(0, self.view.frame.size.height  - 40 - 50 - 30 - 10, self.view.frame.size.width, 30);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hiddenStoryboardAndPoster
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomControlView.frame =  CGRectMake(0, self.view.frame.size.height  - 40, self.view.frame.size.width, 1);
                         _boardAndEditView.frame =  CGRectMake(0, self.view.frame.size.height - 40- 30- 25, self.view.frame.size.width, 30);
                     } completion:^(BOOL finished) {
                         [self.bottomControlView setHidden:YES];
                     }];
    
    
}


#pragma mark - Keyboard
- (void)initKeyboard
{
    int texViewtHeight = 150;
    if(self.keyboard == nil)
    {
        self.keyboard = [[YcKeyBoardView alloc] initWithFrame:CGRectMake(0, ScreenHeight - texViewtHeight, ScreenWidth, texViewtHeight)];
    }
    self.keyboard.delegate = self;
    
    [self.keyboard.textView becomeFirstResponder];
    self.keyboard.textView.returnKeyType = UIReturnKeyDefault; //UIReturnKeyDone;
    
    [self.view addSubview:self.keyboard];
}

- (void)keyboardShow:(NSNotification *)notify
{
    CGRect keyBoardRect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.keyboard.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        self.keyboard.textView.text = @"";
        [self.keyboard removeFromSuperview];
    }];
}

#pragma mark - YcKeyBoardViewDelegate
- (void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    NSLog(@"Keyboard contentView text: %@", contentView.text);
    
    if (!isStringEmpty(contentView.text))
    {
        if (self.isNewFont)
        {
            [self addNewText];
            self.isNewFont = FALSE;
        }
        
        self.selectedTextView.text = contentView.text;
        [self.selectedTextView sizeToFitWithMaxWidth:0.8*self.videoContentView.width lineHeight:0.2*self.videoContentView.height];
    }
    
    [contentView resignFirstResponder];
}

- (CGSize)sizeScaleWithSize:(CGSize)size scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGSize retSize = CGSizeZero;
    retSize.width = size.width/scale;
    retSize.height = size.height/scale;
    return  retSize;
}

- (CGRect)rectScaleWithRect:(CGRect)rect scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGRect retRect = CGRectZero;
    retRect.origin.x = rect.origin.x/scale;
    retRect.origin.y = rect.origin.y/scale;
    retRect.size.width = rect.size.width/scale;
    retRect.size.height = rect.size.height/scale;
    return  retRect;
}
- (CGRect)rectWithArray:(NSArray *)array andSuperSize:(CGSize)superSize
{
    CGRect rect = CGRectZero;
    CGFloat minX = INT_MAX;
    CGFloat maxX = 0;
    CGFloat minY = INT_MAX;
    CGFloat maxY = 0;
    for (int i = 0; i < [array count]; i++)
    {
        NSString *pointString = [array objectAtIndex:i];
        CGPoint point = CGPointFromString(pointString);
        if (point.x <= minX)
        {
            minX = point.x;
        }
        
        if (point.x >= maxX)
        {
            maxX = point.x;
        }
        
        if (point.y <= minY)
        {
            minY = point.y;
        }
        
        if (point.y >= maxY)
        {
            maxY = point.y;
        }
        rect = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    }
    
    rect = [self rectScaleWithRect:rect scale:2.0f];
    rect.origin.x = rect.origin.x * _contentView.frame.size.width/superSize.width;
    rect.origin.y = rect.origin.y * _contentView.frame.size.height/superSize.height;
    rect.size.width = rect.size.width * _contentView.frame.size.width/superSize.width;
    rect.size.height = rect.size.height * _contentView.frame.size.height/superSize.height;
    
    return rect;
}

- (CGPoint)pointScaleWithPoint:(CGPoint)point scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGPoint retPointt = CGPointZero;
    retPointt.x = point.x/scale;
    retPointt.y = point.y/scale;
    return  retPointt;
}

- (void)bringSelectableViewToFront
{
    for (UIView *subView in _contentView.subviews)
    {
        if ([subView isKindOfClass:[StickerView class]] || [subView isKindOfClass:[CLTextView class]])
        {
            [_contentView bringSubviewToFront:subView];
        }
    }
}

#pragma mark - Keyboard Custom
- (void)addNewText
{
    CGFloat fontSize = 35;
    CLTextView *view = [[CLTextView alloc] init];
    if (isZHHansFromCurrentlyLanguage())
    {
        int random = arc4random() % ((unsigned)2);
        if (random == 0)
        {
            // 徐静蕾字体
            NSString *fontName = @"yolan-yolan";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 徐静蕾字体");
        }
        else
        {
            // 少女幼圆字体
            NSString *fontName = @"FrLt DFGirl";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 少女幼圆字体");
        }
    }
    else
    {
        int random = arc4random() % ((unsigned)5);
        if (random == 0)
        {
            NSString *fontName = @"Team Captain";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: AcademyEngravedLetPlain");
        }
        else if (random == 1)
        {
            NSString *fontName = @"SketchyComic";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: Noteworthy-Bold");
        }
        else if (random == 2)
        {
            // 少女幼圆字体
            NSString *fontName = @"FrLt DFGirl";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 少女幼圆字体");
        }
        else if (random == 3)
        {
            // 徐静蕾字体
            NSString *fontName = @"yolan-yolan";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 徐静蕾字体");
        }
        else
        {
            NSLog(@"FontWithName: Default font");
        }
    }
    
    CGFloat ratio = MIN( (0.8 * self.contentView.width) / view.width, (0.2 * self.contentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(_contentView.width/2, 80);
    
    NSLog(@"New text: x = %f, y = %f, width = %f, height = %f", view.frame.origin.x, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
    
    [_contentView addSubview:view];
    [CLTextView setActiveTextView:view];
}

- (void)editButtonAction:(id)sender
{
    //[D_Main_Appdelegate showPreView];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pauseTap:(UITapGestureRecognizer *)recognizer
{
    MarqueeLabel *continuousLabel = (MarqueeLabel *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (!continuousLabel.isPaused)
        {
            [continuousLabel pauseLabel];
        }
        else
        {
            [continuousLabel unpauseLabel];
        }
    }
}

- (void)activeTextViewDidChange:(NSNotification*)notification
{
    self.selectedTextView = notification.object;
}

- (void)activeTextViewDidTap:(NSNotification*)notification
{
    NSLog(@"Single tap invoked.");
    
    self.isNewFont = FALSE;
    
    // Start text edit
    [self initKeyboard];
}

- (void)activeTextViewDidDoubleTap:(NSNotification*)notification
{
    NSLog(@"Double tap invoked.");
    
    self.isNewFont = FALSE;
    // Show custom actionsheet
    [self showCustomActionSheet:notification.object];
}

#pragma mark - Custom ActionSheet
- (void)showCustomActionSheet:(UIView *)anchor
{
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:@"改变字体" message:@"修改字体属性" buttonTitles:@[@"字体", @"颜色", @"特效"] buttonStyle:JGActionSheetButtonStyleDefault];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:0];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:2];
    
    NSArray *sections = (iPad ? @[section] : @[section, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[D_LocalizedCardString(@"card_meitu_cancel")] buttonStyle:JGActionSheetButtonStyleCancel]]);
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
    sheet.delegate = self;
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath)
     {
         NSLog(@"indexPath: %ld; section: %ld", (long)indexPath.row, (long)indexPath.section);
         
         if (indexPath.section == 0)
         {
             if (indexPath.row == 0)
             {
                 // Change font
                 [self popoverFontVC];
             }
             else if(indexPath.row == 1)
             {
                 // Change font color
                 [self popoverColorPicker:anchor];
             }
             else if(indexPath.row == 2)
             {
                 // Change pattern
                 [self popoverMenu:anchor];
             }
         }
         
         [sheet dismissAnimated:YES];
     }];
    
    if (iPad)
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        CGPoint point = (CGPoint){ CGRectGetMidX(anchor.bounds), CGRectGetMaxY(anchor.bounds) };
        point = [self.navigationController.view convertPoint:point fromView:anchor];
        
        [sheet showFromPoint:point inView:self.navigationController.view arrowDirection:JGActionSheetArrowDirectionTop animated:YES];
    }
    else
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        [sheet showInView:self.navigationController.view animated:YES];
    }
}

#pragma mark - Fonts Init
- (void)popoverFontVC
{
    FontVC *fontVC = [[FontVC alloc] init];
    
    // Callback
    [fontVC setFontSuccessBlock:^(BOOL success, id result)
     {
         if (success)
         {
             NSLog(@"%@", result);
             
             // Change font
             CGFloat fontSize = 35;
             self.selectedTextView.font = [UIFont fontWithName:result size:fontSize];
             [self.selectedTextView sizeToFitWithMaxWidth:0.8*self.videoContentView.width lineHeight:0.2*self.videoContentView.height];
         }
     }];
    
    [self.navigationController pushViewController:fontVC animated:YES];
}

#pragma mark - Color Picker
- (void)popoverColorPicker: (id)sender
{
    NSLog(@"popoverColorPicker Invoked.");
    
    InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
    picker.sourceColor = self.color;
    picker.delegate = self;
    [picker presentModallyOverViewController: self];
}

#pragma mark - CustomMenu
- (void)popoverMenu:(UIView *)anchor
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"ChangePattern")
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleDefault")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleShadow")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleEmboss")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleGradientFill")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleRainbow")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleSynthesis")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = kBrightBlue; //[UIColor colorWithRed:59./255. green:89./255. blue:152./255. alpha:0.6f];
    
    [KxMenu showMenuInView:self.view
                  fromRect:anchor.frame
                 menuItems:menuItems];
}

- (BOOL)dismissActivePopover
{
    if (_activePopover)
    {
        [_activePopover dismissPopoverAnimated: YES];
        [self popoverControllerDidDismissPopover: _activePopover];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - UIPopoverControllerDelegate methods
- (void)popoverControllerDidDismissPopover: (UIPopoverController*) popoverController
{
    if ([popoverController.contentViewController isKindOfClass: [InfColorPickerController class]])
    {
        InfColorPickerController* picker = (InfColorPickerController*) popoverController.contentViewController;
        self.color = picker.resultColor;
        self.selectedTextView.fillColor = self.color;
    }
    
    if (popoverController == _activePopover)
    {
        _activePopover = nil;
    }
}

#pragma mark Show/Hide ScrollView

- (void)tapImageView
{
    // Deselect
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    // Hide scroll view
    [self hiddenStoryboardAndPoster];
}



- (void)pushMenuItem:(id)sender
{
    if ([sender isKindOfClass:[KxMenuItem class]])
    {
        NSLog(@"pushMenuItem: %@", sender);
        
        KxMenuItem *menuItem = sender;
        if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleShadow") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kShadow;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleEmboss") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kInnerShadow;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleGradientFill") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kGradientFill;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleRainbow") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kMultiPartGradient;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleSynthesis") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kSynthesis;
        }
        else
        {
            self.selectedTextView.labelStyle = kDefault;
        }
        
        [self.selectedTextView sizeToFitWithMaxWidth:0.8*self.videoContentView.width lineHeight:0.2*self.videoContentView.height];
    }
}

- (void)hiddenWaitView
{
    [[LoadingViewManager sharedInstance] removeLoadingView:self];
    
    NSLog(@"hiddenWaitView");
}

#pragma mark - CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
}

/*
 - (void)initPopView
 {
 NSArray *colorSchemes = [NSArray arrayWithObjects:
 [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil],
 [NSArray arrayWithObjects:[UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:1.0], [NSNull null], nil],
 [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil],
 [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkTextColor], nil],
 nil];
 NSArray *colorScheme = [colorSchemes objectAtIndex:foo4random()*[colorSchemes count]];
 UIColor *backgroundColor = [colorScheme objectAtIndex:0];
 UIColor *textColor = [colorScheme objectAtIndex:1];
 
 NSString *hint = D_LocalizedCardString(@"点这里开始");
 _popTipView = [[CMPopTipView alloc] initWithMessage:hint];
 _popTipView.delegate = self;
 if (backgroundColor && ![backgroundColor isEqual:[NSNull null]])
 {
 _popTipView.backgroundColor = backgroundColor;
 }
 if (textColor && ![textColor isEqual:[NSNull null]])
 {
 _popTipView.textColor = textColor;
 }
 
 if (IOS7)
 {
 _popTipView.preferredPointDirection = PointDirectionDown;
 }
 _popTipView.animation = arc4random() % 2;
 _popTipView.has3DStyle = FALSE;
 _popTipView.dismissTapAnywhere = YES;
 [_popTipView autoDismissAnimated:YES atTimeInterval:3.0];
 
 if ([self.assets count] == 1)
 {
 [_popTipView presentPointingAtView:_borderButton inView:self.view animated:YES];
 }
 else if ([self.assets count] > 1)
 {
 [_popTipView presentPointingAtView:_puzzleButton inView:self.view animated:YES];
 }
 }
 */
- (void)tapWithEditView:(MeituImageEditView *)sender
{
    // Deselect sticker
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    // Hide scroll view
    [self hiddenStoryboardAndPoster];
}


#pragma mark - InfColorPickerControllerDelegate
- (void)colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    self.color = picker.resultColor;
    self.selectedTextView.fillColor = self.color;
    NSLog(@"colorPickerControllerDidFinish invoked.");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerControllerDidChangeColor: (InfColorPickerController*) picker
{
    if (iPad)
    {
        self.color = picker.resultColor;
        self.selectedTextView.fillColor = self.color;
    }
}

#pragma mark GLMeitoPosterSelectViewControllerDelegate
-(UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (void)contentRemoveView
{
    for (UIView *subView in _contentView.subviews)
    {
        // Reserve sticker view
        if (![subView isKindOfClass:[StickerView class]] && ![subView isKindOfClass:[CLTextView class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    [_contentView addSubview:self.bringPosterView];
    [_contentView bringSubviewToFront:self.bringPosterView];
    
    [_contentView addSubview:self.freeBgView];
    [_contentView sendSubviewToBack:self.freeBgView];
}

#pragma mark Splice

- (void)spliceAction
{
    @synchronized(self)
    {
        [self contentRemoveView];
        
        CGRect rect = CGRectZero;
        rect.origin.x = 0;
        rect.origin.y = 10;
        for (int i = 0; i < [self.assetsImage count]; i++)
        {
            //            ALAsset *asset = [self.assets objectAtIndex:i];
            UIImage *image = [self.assetsImage objectAtIndex:i]; //[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            rect.size.width = _contentView.frame.size.width - 20;
            rect.size.height = height*((_contentView.frame.size.width - 20)/width);
            rect.origin.x = 10;//(_contentView.frame.size.width - rect.size.width)/2.0f + 10;
            //        rect.size.width = rect.size.width - 20;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            rect.origin.y += rect.size.height+5;
            imageView.image = image;
            //      [imageView.layer setBorderWidth:2.0f];
            //      [imageView.layer setBorderColor:[UIColor clearColor].CGColor];
            //      self.selectedBoardColor == nil ?[UIColor whiteColor].CGColor:self.selectedBoardColor.CGColor];
            [_contentView addSubview:imageView];
        }
        _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, rect.origin.y+5);
        
        self.freeBgView.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentView.contentSize.height);
    }
    
}

#pragma mark - 获取view上的图片
- (UIImage *)captureScrollView:(UIScrollView *)scrollView
{
    UIImage* image = nil;
    if(&UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 2.0);
    }
    
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    
    return nil;
}



- (void)goUpVC:(NSString *)videoPath{
    
    VideEditViewController *editVC = [[VideEditViewController alloc] init];
    editVC.videoPath = videoPath;
    [self.navigationController pushViewController:editVC animated:YES];
    
}


@end
