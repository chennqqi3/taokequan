//
//  TCTNotificationManager.h
//  TCTravel_IPhone
//
//  Created by zhangyoukai on 16/9/29.
//  Copyright © 2016年 www.ly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface TCTNotificationManager : NSObject

//推送标题iOS8.2及以上才用到
- (TCTNotificationManager *(^)(NSString *))title;

//推送内容
- (TCTNotificationManager *(^)(NSString *))content;

//推送详细数据
- (TCTNotificationManager *(^)(NSDictionary *))userInfo;

//推送触发时间
- (TCTNotificationManager *(^)(NSDate *))fireDate;

//推送循环时间 只支持 NSCalendarUnitDay NSCalendarUnitWeekday
//需要新增请联系zyk3451
- (TCTNotificationManager *(^)(NSCalendarUnit))calendarUnit;

//添加本地推送
- (void(^)())addLocalNotification;

//移除本地推送
//+(void)removePendingNotification:(id)notif;

//通知注册
+(void)registerUserNotificationSettings:(UIApplication*)_application responder:(id)respond;


//前台推送数据处理
+ (void)receiveActiveNotification:(NSDictionary *)userInfo;

//后台推送数据处理
+ (void)receiveRemoteNotification:(NSDictionary *)userInfo;

//处理本地推送逻辑
+ (void)receiveLocalNotification:(NSDictionary *)userInfo message:(NSString*)message;


@end
