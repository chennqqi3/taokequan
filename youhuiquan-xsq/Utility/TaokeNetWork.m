//
//  TaokeNetWork.m
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/6/1.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import "TaokeNetWork.h"

int const ResultNetWorkKey = -1009;
int const ResultNullKey = 9999;

@implementation TaokeNetWork


+(void)sendPostData:(NSString*)URLString contentData:(id)contentData successBlock:(TKRequestSuccessBlock)success failBlock:(TKRequestFailBlock)fail{
    
    
    @autoreleasepool {
        if (URLString==nil) {
            return;
        }
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
        [request setHTTPMethod:@"POST"];

        if (contentData) {
//            [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
//            NSString *strContent = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:contentData options:0 error:nil] encoding:NSUTF8StringEncoding];
//            NSData *requestData = [strContent dataUsingEncoding:NSUTF8StringEncoding];
//            [request setHTTPBody:requestData];

        }
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {//asdfkw
             if (connectionError==nil&&data) {
                 id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                 
                 if (result) {
                     if ([result isKindOfClass:[NSArray class]]||[result isKindOfClass:[NSDictionary class]]) {
                         success(result,nil);
                     }else{
                         NSError *err = nil;
                         if ([result isKindOfClass:[NSNull class]]||![result boolValue]) {
                             err = [NSError errorWithDomain:@"" code:ResultNullKey userInfo:nil];
                         }
                         fail(err,nil);
                         
                     }
                 }else{
                     fail(nil,nil);
                 }
             }else{
                 
                 fail(connectionError,nil);
             }
         }];
    }
    
}
+(void)sendPostData:(NSString*)URLString successBlock:(TKRequestSuccessBlock)success failBlock:(TKRequestFailBlock)fail{
    [self sendPostData:URLString contentData:nil successBlock:success failBlock:fail];
}
+(NSString *)imageConvertWithImageString:(NSString*)url{
    NSString *oldPic = url;// [url stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
    if ([oldPic hasPrefix:@"//"]) {
        oldPic = [@"http:" stringByAppendingString:oldPic];
    }
    return oldPic;
}
@end
