//
//  AppDelegate.m
//  MyCampus
//
//  Created by zhangming on 17/7/26.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "ZKADView.h"

@interface AppDelegate ()<JPUSHRegisterDelegate,ZKADViewDelegate>

@end

@implementation AppDelegate
//配置 key
static NSString *appKey = @"aaf316825533dcea1469e72e";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:2];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    MyTabBarViewController *tabbar = [[MyTabBarViewController alloc] init];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    [self setup_APNs];
    [self setup_JpushdidFinishLaunchingWithOptions:launchOptions];
    
    /** 添加广告页 */
    [self addADView];
    
    /** 获取广告图URL */
    [self getADImageURL];
    
    return YES;
}

//添加初始化APNs代码
- (void)setup_APNs{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}


//添加初始化JPush代码
- (void)setup_JpushdidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:nil
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
    
    /*
     1.appKey填写管理Portal上创建应用后自动生成的AppKey值。请确保应用内配置的AppKey 与Portal 上创建应用后生成的AppKey一致。
     2.channel指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
     3.apsForProduction1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。
     0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
     
     作者：anyurchao
     链接：http://www.jianshu.com/p/96375d2c3704
     來源：简书
     著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
     */
    
}


- (void)addADView
{
    ZKADView *adView = [[ZKADView alloc] init];
    adView.tag = 100;
    adView.duration = 5;
    adView.waitTime = 5;
    adView.skipType = SkipButtonTypeTimeAndText;
    adView.options = ZKWebImageOptionDefault;
    adView.delegate = self;
    
    // 必须先将adView添加到父视图上才能调用 reloadDataWithURL: 方法加载广告图
    [self.window addSubview:adView];
}

- (void)getADImageURL
{
    // 此处推荐使用tag来获取adView，勿使用全局变量。因为在AppDelegate中将其设为全局变量时，不会被释放
    ZKADView *adView = (ZKADView *)[self.window viewWithTag:100];
    
    // 模拟从服务器上获取广告图URL
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *urlString = @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg";
        
        
        [adView reloadDataWithURL:[NSURL URLWithString:urlString]]; // 加载广告图
    });
}

#pragma mark -- ZKADView Delegate
- (void)adImageLoadFinish:(ZKADView *)adView image:(UIImage *)image
{
    NSLog(@"%@", image);
}

- (void)adImageDidClick:(ZKADView *)adView
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://baidu.com"]
                                       options:@{}
                             completionHandler:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


#pragma mark - 实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - 添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)showPreView
{
    if (_preview == nil)
    {
        _preview = [[ImageAddPreView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height - 135, self.window.frame.size.width, 135)];
        [_window addSubview:_preview];
    }
    
    [_preview setAlpha:0];
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_preview setAlpha:1];
                     } completion:^(BOOL finished) {
                         
                     }];
    [_preview setHidden:NO];
}


- (void)hiddenPreView
{
    [_preview setHidden:YES];
    [_preview setAlpha:0];
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_preview setAlpha:0];
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

@end
