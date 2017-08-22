//
//  TCTRemoteAndSchemeCenter.h
//  TCTravel_IPhone
//
//  Created by AF on 18/1/17.
//  Copyright © 2017年 www.ly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface TCTRemoteAndSchemeCenter : NSObject

#pragma mark - local and remote notification
#pragma mark -
+ (void)clearAppBudgeNumber;

#pragma mark - scheme 处理
#pragma mark -
/**
 *  iOS 9.0 及以上走
 */
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options currentNav:(UINavigationController *)currentNav;
/**
 *  iOS 9.0 以下走
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation currentNav:(UINavigationController *)currentNav;

+ (BOOL)application:(UIApplication *)application scheme:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation currentNav:(UINavigationController *)currentNav;

@end
