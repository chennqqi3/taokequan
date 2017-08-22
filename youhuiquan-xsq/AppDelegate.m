//
//  AppDelegate.m
//  youhuiquan-xsq
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 zyktom. All rights reserved.
//

#import "AppDelegate.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "UMMobClick/MobClick.h"
#import "TKQMainViewController.h"

#import "TKQWebViewController.h"
#import "TCTRemoteAndSchemeCenter.h"
#import "WXApi.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic,assign) BOOL bRegisterThirdSDK;
@property (nonatomic,retain) UINavigationController* nav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
    __weak __typeof(self) weakSelf = self;
    
    AFNetworkReachabilityManager *afnet = [AFNetworkReachabilityManager manager];
    [afnet setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [weakSelf registerThirdSDK:status];
    }];
    [afnet startMonitoring];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    TKQMainViewController *mainVC = [[TKQMainViewController alloc] initWithNibName:@"TKQMainViewController" bundle:nil];
    self.nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    //fajwflejwe
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"33356ea519f30256d058c0a2"
                          channel:@"appstore"
                 apsForProduction:YES];
    [TCTRemoteAndSchemeCenter clearAppBudgeNumber];
    //#      如果为开发状态,为 NO;  生产状态,应改为 YES.
    
    return YES;
}


- (void)networkChanged:(NSNotification *)noti
{
    AFNetworkReachabilityStatus status;
    status = [noti.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    [self registerThirdSDK:status];
}


#pragma mark - UIApplicationDelegate
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    ///asfwefwefwef
    [application cancelAllLocalNotifications];
}

#pragma mark - local notification,remote notification,scheme
#pragma mark -
#pragma mark local notification,remote notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark scheme
//iOS 9.0 以下走
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TCTRemoteAndSchemeCenter application:application
                                         openURL:url
                               sourceApplication:sourceApplication annotation:annotation
                                      currentNav:self.nav];
}

////iOS 9.0 及以上走
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    return [TCTRemoteAndSchemeCenter application:app openURL:url options:options currentNav:self.nav];
}

-(BOOL)application:(UIApplication *)application scheme:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TCTRemoteAndSchemeCenter application:application  scheme:url
                               sourceApplication:sourceApplication
                                      annotation:annotation
                                      currentNav:self.nav];
}

#pragma mark- JPUSHRegisterDelegate
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
        NSString *activityId = userInfo[@"activityId"];
        NSString *title = userInfo[@"title"];
        NSString *itemId = userInfo[@"itemId"];
        
        [self didGotoBuyByActivityid:activityId itemId:itemId title:title];
        
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


// iOS 10 Support 前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// iOS 10 Support  后台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSString *title = userInfo[@"title"];
        
        NSString *itemId = userInfo[@"itemId"];
        NSString *activityId = userInfo[@"activityId"];
        
        [self didGotoBuyByActivityid:activityId itemId:itemId title:title];
    }
    //// 系统要求执 这个 法
    completionHandler();
}



- (void)didGotoBuyByActivityid:(NSString*)activityId itemId:(NSString*)itemId title:(NSString*)title{
    
    if (activityId.length>0 && itemId.length>0) {
        NSString *url = [NSString stringWithFormat:@"https://uland.taobao.com/coupon/edetail?activityId=%@&pid=%@&itemId=%@",activityId,taokePID,itemId];
        
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
        showParams.isNeedPush = YES;//需要push
        id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
        id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
        
        
        TKQWebViewController *webView = [[TKQWebViewController alloc] init];
        webView.title = title;
        NSInteger res = [service show:webView
                              webView:webView.webView page:page
                           showParams:showParams
                          taoKeParams:nil
                           trackParam:nil tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
        if (res==1) {
            [self.nav pushViewController:webView animated:YES];
        }
    }
}


//注册第三方SDK
- (void)registerThirdSDK:(AFNetworkReachabilityStatus)status{
    static BOOL isRegisterApp = NO;
    if (status!=AFNetworkReachabilityStatusNotReachable&&!isRegisterApp) {
        isRegisterApp = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [WXApi registerApp:wexinappid];
            
            //初始sdk
            [[AlibcTradeSDK sharedInstance] setIsForceH5:YES];
            // 打开debug日志
            //    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
            [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
                
            } failure:^(NSError *error) {
                
            }];
            // 配置全局的淘客参数
            AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
            taokeParams.unionId = nil;
            taokeParams.subPid = nil;
            taokeParams.pid = @"mm_24574208";
            [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
            
            UMConfigInstance.appKey = @"598476fab27b0a750c0011b3";
            UMConfigInstance.channelId = @"App Store";
            [MobClick startWithConfigure:UMConfigInstance];
        });
    }
}

@end
