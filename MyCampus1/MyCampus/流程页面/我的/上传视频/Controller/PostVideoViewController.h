//
//  PostVideoViewController.h
//  Take goods
//
//  Created by zhangming on 17/4/25.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "BaseViewController.h"

#import "GLStoryboardSelectView.h"
#import "MeituImageEditView.h"

#import "PBJVideoPlayerController.h"
#import "CaptureViewController.h"
#import "JGActionSheet.h"
#import "DBPrivateHelperController.h"
#import "KGModal.h"

#import "UIAlertView+Blocks.h"
#import "ExportEffects.h"
#import "SAVideoRangeSlider.h"
#import "NSString+Height.h"
#import "StickerView.h"
#import "BTSimpleSideMenu.h"
#import "CMPopTipView.h"
//------------------------------------------------------
#import "CLTextView.h"
#import "YcKeyBoardView.h"
#import "MarqueeLabel.h"
#import "AppDelegate.h"
#import "FontVC.h"
#import "InfColorPicker.h"
#import "KxMenu.h"

//------------------------------------------------------

typedef NS_ENUM(NSUInteger, ScrollViewStatus)
{
    kPuzzleScrollView = 0,
    kBorderScrollView,
    kStickerScrollView,
    kFaceScrollView,
    kFilterScrollView,
};

@class PostVideoViewController;

@protocol PostVideoViewControllerDelegate <NSObject>

- (void)clickedContentView;


@end

@interface PostVideoViewController : BaseViewController<MeituImageEditViewDelegate, CMPopTipViewDelegate, YcKeyBoardViewDelegate, UIGestureRecognizerDelegate, InfColorPickerControllerDelegate, UIPopoverControllerDelegate, JGActionSheetDelegate,GLStoryboardSelectViewDelegate>

@property (nonatomic,strong) id<PostVideoViewControllerDelegate> delegate;
//-------------------------------------------
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) NSArray *effectImages;

@property (nonatomic, strong) NSMutableArray    *assetsImage;
@property (nonatomic, strong) NSArray           *assets;
@property (nonatomic, strong) UIScrollView      *contentView;
@property (nonatomic, assign) BOOL              *isCallBack;


@property (nonatomic, strong) UIImageView       *bringPosterView;
@property (nonatomic, strong) UIImageView       *freeBgView;

// 添加／删除按钮
@property (nonatomic, strong) UIView              *boardAndEditView;

@property (nonatomic, strong) UIButton            *editbutton;


@property (nonatomic, strong) UIScrollView            *bottomView;
//

@property (nonatomic, strong) UIButton          *puzzleButton;
@property (nonatomic, strong) UIButton          *borderButton;
@property (nonatomic, strong) UIButton          *stickerButton;
@property (nonatomic, strong) UIButton          *faceButton;
@property (nonatomic, strong) UIButton          *filterButton;
@property (nonatomic, strong) UIButton          *textButton;


@property (nonatomic, strong) UIButton          *selectControlButton;


@property (nonatomic, strong) GLStoryboardSelectView      *storyboardView;

@property (nonatomic, strong) UIScrollView                *bottomControlView;

@property (nonatomic, strong) GLStoryboardSelectView      *borderView;

@property (nonatomic, strong) GLStoryboardSelectView      *stickerView;

@property (nonatomic, strong) GLStoryboardSelectView      *faceView;

@property (nonatomic, strong) GLStoryboardSelectView      *filterView;


@property (nonatomic, strong) UIButton          *selectedStoryboardBtn;

@property (nonatomic, strong) UIButton          *selectedPosterBtn;

@property (nonatomic, strong) UIColor           *selectedBoardColor;

@property (nonatomic, assign) NSInteger         selectStoryBoardStyleIndex;
@property (nonatomic, assign) BOOL              isFirst;

@end
