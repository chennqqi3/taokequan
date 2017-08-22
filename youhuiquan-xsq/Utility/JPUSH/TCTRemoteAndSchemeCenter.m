//
//  TCTRemoteAndSchemeCenter.m
//  TCTravel_IPhone
//
//  Created by AF on 18/1/17.
//  Copyright © 2017年 www.ly.com. All rights reserved.
//

#import "TCTRemoteAndSchemeCenter.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
@implementation TCTRemoteAndSchemeCenter
#pragma mark - local and remote notification
#pragma mark -

#pragma mark Tools
//清除角标
+ (void)clearAppBudgeNumber{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - scheme 处理
#pragma mark -
/**
 *  iOS 9.0 及以上走
 */
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options currentNav:(UINavigationController *)currentNav{
    
    NSString *sourceApplication = [options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey];
    id annotation = [options objectForKey:UIApplicationOpenURLOptionsAnnotationKey];
    return [TCTRemoteAndSchemeCenter application:app scheme:url sourceApplication:sourceApplication annotation:annotation currentNav:currentNav];
}


/**
 *  iOS 9.0 以下走
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation currentNav:(UINavigationController *)currentNav{
   
    return [TCTRemoteAndSchemeCenter application:application scheme:url sourceApplication:sourceApplication annotation:annotation currentNav:currentNav];
}


+ (BOOL)application:(UIApplication *)application scheme:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation currentNav:(UINavigationController *)currentNav{
    
#ifdef TC_HTTP_DEBUG_REQUEST
    NSLog(@"schemeURL---:%@",url);
#endif
    if ([[url scheme] isEqualToString:@"tbopen24574208"])
    {
        return [[AlibcTradeSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }else{
        
    }
    return YES;
}


@end
