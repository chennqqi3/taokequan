//
//  TCTNotificationView.h
//  MPNotificationViewTest
//
//  Created by Zhuyc on 14/12/31.
//  Copyright (c) 2014年 Moped Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TCTNotificationViewTappedBlock)(void);

@interface TCTNotificationView : UIView

+ (void)displayNotificationWithSimpleMessage:(NSString *)aMessage
                                    duration:(CGFloat)aDuration
                                    tapBlock:(TCTNotificationViewTappedBlock)tapBlock;

+ (void)displayNotificationWithContentView:(UIView *)aView
                                  duration:(CGFloat)aDuration
                                  tapBlock:(TCTNotificationViewTappedBlock)tapBlock;
@end
