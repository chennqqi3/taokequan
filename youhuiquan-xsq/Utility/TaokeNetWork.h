//
//  TaokeNetWork.h
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/6/1.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import <Foundation/Foundation.h>
extern int const ResultNullKey;     
extern int const ResultNetWorkKey;

typedef void(^TKRequestSuccessBlock)(id responseObject, NSDictionary *options);
typedef void(^TKRequestFailBlock)(NSError *error, NSDictionary *options);

@interface TaokeNetWork : NSObject
+(void)sendPostData:(NSString*)URLString successBlock:(TKRequestSuccessBlock)success failBlock:(TKRequestFailBlock)fail;

+(void)sendPostData:(NSString*)URLString contentData:(id)contentData successBlock:(TKRequestSuccessBlock)success failBlock:(TKRequestFailBlock)fail;

+(NSString *)imageConvertWithImageString:(NSString*)url;
@end
