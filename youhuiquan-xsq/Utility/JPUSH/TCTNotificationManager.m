//
//  TCTNotificationManager.m
//  TCTravel_IPhone
//
//  Created by zhangyoukai on 16/9/29.
//  Copyright © 2016年 www.ly.com. All rights reserved.
//

#import "TCTNotificationManager.h"
#import "TCTNotificationView.h"

@interface TCTNotificationManager (){
    
    NSString *_title;
    NSString *_content;
    NSDictionary *_userInfo;
    NSDate *_fireDate;
    NSCalendarUnit _calendarUnit;
}
@end
@implementation TCTNotificationManager
- (TCTNotificationManager *(^)(NSString *))title
{
    return ^id (NSString *title) {
        _title = title;
        return self;
    };
}


- (TCTNotificationManager *(^)(NSString *))content
{
    return ^id (NSString *content) {
        _content = content;
        return self;
    };
}

- (TCTNotificationManager *(^)(NSDictionary *))userInfo
{
    return ^id (NSDictionary *userInfo) {
        _userInfo = userInfo;
        return self;
    };
}

- (TCTNotificationManager *(^)(NSDate *))fireDate
{
    return ^id (NSDate *fireDate) {
        _fireDate = fireDate;
        return self;
    };
}

- (TCTNotificationManager *(^)(NSCalendarUnit))calendarUnit{
    return ^id (NSCalendarUnit calendarUnit) {
        _calendarUnit = calendarUnit;
        return self;
    };
}


- (void(^)())addLocalNotification
{
    
    return  ^{
        
        if (_fireDate==nil) {
            _fireDate = [NSDate date];
        }
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))//iOS 10 通知设置
        {
            // 1.使用 UNUserNotificationCenter 来管理通知
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            
            // 2.需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
            UNMutableNotificationContent* contentNoti = [[UNMutableNotificationContent alloc] init];
            contentNoti.title = _title;
            contentNoti.body = _content;
            contentNoti.userInfo = _userInfo;
            contentNoti.sound = [UNNotificationSound defaultSound];
            // 在 alertTime 后推送本地推送,repeats:是否重复
            UNNotificationTrigger * trigger = nil;
            
            if (_calendarUnit==NSCalendarUnitDay) {
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *componentsDate = [cal components:(NSCalendarUnitHour|NSCalendarUnitSecond|NSCalendarUnitMinute) fromDate:_fireDate];
                //每天 提醒我
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.hour = [componentsDate hour];
                components.minute = [componentsDate minute];
                components.second = [componentsDate second];
                trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                   repeats:YES];
            }else if (_calendarUnit==NSCalendarUnitWeekday) {
                
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *componentsDate = [cal components:(NSCalendarUnitHour|NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitWeekday) fromDate:_fireDate];
                
                //每周 提醒我
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.weekday = [componentsDate weekday];
                components.hour = [componentsDate hour];
                components.minute = [componentsDate minute];
                components.second = [componentsDate second];
                trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                   repeats:YES];
                
            }else{
                trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:([_fireDate timeIntervalSinceNow] + 1) > 0?([_fireDate timeIntervalSinceNow] + 1):1
                                                                             repeats:NO];
            }
            //生成唯一随机数推送id-原因是同一个Identifier 会覆盖上次的所以必须保证唯一性
            NSString* notifiRandom = [NSString stringWithFormat:@"%d",(arc4random()%2147483647) + 1];
            // 新建一个推送请求
            UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:notifiRandom
                                                                                  content:contentNoti trigger:trigger];
            
            //添加推送成功后，弹出提示框
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
            }];
            
        }else{
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            notification.fireDate=[_fireDate dateByAddingTimeInterval:1]; //触发通知的时间
            notification.timeZone=[NSTimeZone defaultTimeZone];
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.alertBody = _content;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.2")) {
                notification.alertTitle = _title;
            }
            notification.repeatInterval = _calendarUnit;
            notification.alertAction = @"确定";
            notification.hasAction = YES;
//            notification.applicationIconBadgeNumber = 1;
            notification.userInfo = _userInfo;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification]; 
        }
    };
    
}


/**
 *  注册通知
 *
 */
+(void)registerUserNotificationSettings:(UIApplication*)_application responder:(id)respond{
    
    // Set Notification
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))//iOS 10 通知设置
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = respond;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                                 UNAuthorizationOptionSound |
                                                 UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
			 if (granted) {
				 [_application registerForRemoteNotifications];
			 }
             if (!error) {
                 //            NSLog(@"request authorization succeeded!");
             }
         }];
    }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))//ios8 通知设置改变
    {
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeSound
                                                            | UIUserNotificationTypeAlert
                                                            | UIUserNotificationTypeBadge
                                                                                             categories:nil];
        [_application registerUserNotificationSettings:notificationSettings];
    }
    else//ios7及以下
    {
//        [_application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         | UIRemoteNotificationTypeSound
//         | UIRemoteNotificationTypeAlert];
    }
}



//后台推送数据处理
+ (void)receiveRemoteNotification:(NSDictionary *)userInfo{
    
    if (userInfo==nil) {
        return;
    }
    
    //获取推送通知相关参数
    //推送类型/Type
    NSString *parameterType = [userInfo objectForKey:@"parameterType"];
    if ([parameterType length] == 0) {
        parameterType = userInfo[@"t"];
    }
    //推送参数/URL
    NSString *parameter = [userInfo objectForKey:@"sceneryId"];
    if ([parameter length] == 0) {
        parameter = userInfo[@"u"];
    }
    //推送消息类别：用户/系统
    NSString *CID=userInfo[@"CID"];
    if ([CID length] == 0) {
        CID = userInfo[@"c"];
    }
    
    //行程推送不保存消息
    if (![parameterType isEqualToString:@"7"]) {
     }
    
   
}


//处理本地推送逻辑
+ (void)receiveLocalNotification:(NSDictionary *)userInfo message:(NSString*)message{
    
    UIApplication *application = [UIApplication sharedApplication];
     
 
    if ([userInfo[@"notificationType"] isEqualToString:@"kLocalNotificationType_PushMessage"]) {
        //10以下 前台推送，转本地推送时
        //需要添加本地推送，才能把消息保留在消息栏中，只作保留不作处理动作
    }
    else if ([application applicationState] != UIApplicationStateActive) {
        [TCTNotificationManager receiveRemoteNotification:userInfo];
    }
    
}


//前台推送数据处理
+ (void)receiveActiveNotification:(NSDictionary *)userInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    
    NSDictionary *aps = (NSDictionary *)[userInfo objectForKey:@"aps"];
    
    id alertNode = [aps objectForKey:@"alert"];
    
    NSString *content = nil;
    if ([alertNode isKindOfClass:[NSDictionary class]]) {
        content = [alertNode objectForKey:@"body"];
    }else if([alertNode isKindOfClass:[NSString class]]){
        content = alertNode;
    }
    
    //运营秒杀订阅类推送，以“友情提示”四字做判断，直接弹框显示
    if ([content hasPrefix:@"友情提示"]) {
        if ([content length] > 4){
            content = [content stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
        }
        
       
    }
    else {
        //推送通知在程序正运行时，以本地通知呈现
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))//iOS 10 通知设置
        {
            //iOS10 走系统提示逻辑
        }else{
            //10以下，需要添加本地推送，才能把消息保留在消息栏中
            
            //推送通知在程序正运行时，以本地通知呈现
            [dict setValue:@"youqinId" forKey:@"youqinNotificationIdentifiers"];
            [dict setValue:@"kLocalNotificationType_PushMessage" forKey:@"notificationType"];
            [[TCTNotificationManager alloc] init]
            .content(content)
            .fireDate([NSDate date])
            .userInfo(dict)
            .addLocalNotification();
            //在状态栏显示提示信息
            [TCTNotificationView displayNotificationWithSimpleMessage:content
                                                             duration:2.0f
                                                             tapBlock:^{
                                                                 [TCTNotificationManager receiveRemoteNotification:dict];
                                                                 //10以下
                                                                 NSArray *localNotificatonArray = [UIApplication sharedApplication].scheduledLocalNotifications;
                                                                 for (UILocalNotification *localNotification in localNotificatonArray) {
                                                                     if ([localNotification.userInfo[@"youqinNotificationIdentifiers"] isEqualToString:@"youqinId"] ) {
                                                                         [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                                                                     }
                                                                 }
                                                             }];
        }
        
        
    }
}



@end
