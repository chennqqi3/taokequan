//
//  TCTNotificationView.m
//  MPNotificationViewTest
//
//  Created by Zhuyc on 14/12/31.
//  Copyright (c) 2014年 Moped Inc. All rights reserved.
//

#import "TCTNotificationView.h"
#import "TCTNotificationSimpleView.h"
#import <AudioToolbox/AudioToolbox.h>

@class TCTNotificationWindow;

#define kDefaultNotificationAnimateTime 2
#define kTCTNotificationHeight 64

static TCTNotificationWindow *__tctNotificationWindow = nil;

static CGRect TCTNotificationRect()
{
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        return CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, kTCTNotificationHeight);
    }
    
    return CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, kTCTNotificationHeight);
}

@interface TCTNotificationWindow : UIWindow
@property (atomic, strong) NSMutableArray *notificationQueue;
@property (nonatomic, strong) UIView *currentNotification;
@end

@implementation TCTNotificationWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        _notificationQueue = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}
@end

@interface TCTNotificationView ()
    @property (nonatomic, strong) UIView * contentView;
    @property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
    @property (nonatomic, copy) TCTNotificationViewTappedBlock tapBlock;
    @property (nonatomic, assign) CGFloat duration;
@end

@implementation TCTNotificationView

+ (void)displayNotificationWithSimpleMessage:(NSString *)aMessage
                                    duration:(CGFloat)aDuration
                                    tapBlock:(TCTNotificationViewTappedBlock)tapBlock {
    if (aDuration == 0) {
        aDuration = kDefaultNotificationAnimateTime;
    }

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    TCTNotificationSimpleView *simpleView = [[TCTNotificationSimpleView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, kTCTNotificationHeight) withMessage:aMessage];
    
    float height=[simpleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    simpleView.frame=CGRectMake(simpleView.frame.origin.x,
                                simpleView.frame.origin.y,
                                simpleView.frame.size.width,
                                height);
    
    [self displayNotificationWithContentView:simpleView duration:aDuration tapBlock:tapBlock];
}

+ (void)displayNotificationWithContentView:(UIView *)aView
                                  duration:(CGFloat)aDuration
                                  tapBlock:(TCTNotificationViewTappedBlock)tapBlock {
    
    if (__tctNotificationWindow == nil) {
        __tctNotificationWindow = [[TCTNotificationWindow alloc] initWithFrame:TCTNotificationRect()];
    }
    __tctNotificationWindow.hidden = NO;
    
    TCTNotificationView *notificationView = [[TCTNotificationView alloc] initWithFrame:aView.bounds];
    [notificationView addSubview:aView];
    notificationView.contentView = aView;
    notificationView.duration = aDuration;
    notificationView.tapBlock = tapBlock;
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:notificationView
                                                                         action:@selector(handleTap:)];
    notificationView.tapGestureRecognizer = gr;
    [notificationView addGestureRecognizer:gr];
    
    [__tctNotificationWindow.notificationQueue addObject:notificationView];
    
    if (__tctNotificationWindow.currentNotification == nil)
    {
        [self showNextNotification];
    }
}

- (void) handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (__tctNotificationWindow.currentNotification) {
        TCTNotificationView *notificationView = (TCTNotificationView *)__tctNotificationWindow.currentNotification;
        if (notificationView.tapBlock) {
            notificationView.tapBlock();
        }
    }
    [TCTNotificationView showNextNotification];
}

+ (void)showNextNotification {
    [NSObject cancelPreviousPerformRequestsWithTarget:[self class]
                                             selector:@selector(showNextNotification)
                                               object:nil];
    
    if (__tctNotificationWindow.currentNotification) {
        UIView *notificationView = __tctNotificationWindow.currentNotification;
        
        CGRect endFrame = notificationView.frame;
        endFrame.origin.y -= endFrame.size.height;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             notificationView.alpha = 0;
                             notificationView.frame = endFrame;
                         } completion:^(BOOL finished) {
                             [notificationView removeFromSuperview];
                             
                             __tctNotificationWindow.currentNotification = nil;
                             [self showNextNotification];
                         }];
    }
    else {
        if ([__tctNotificationWindow.notificationQueue count] > 0) {
            TCTNotificationView *notificationView = __tctNotificationWindow.notificationQueue[0];
            
            CGRect startFrame = notificationView.bounds;
            startFrame.origin.y -= startFrame.size.height;
            notificationView.frame = startFrame;
            [__tctNotificationWindow addSubview:notificationView];
            
            CGRect endFrame = CGRectMake(startFrame.origin.x, startFrame.origin.y + startFrame.size.height, startFrame.size.width, startFrame.size.height);
            __tctNotificationWindow.currentNotification = notificationView;
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 notificationView.alpha = 1;
                                 notificationView.frame = endFrame;
                             } completion:^(BOOL finished) {
                                 if ([__tctNotificationWindow.notificationQueue count] > 0) {
                                     [__tctNotificationWindow.notificationQueue removeObjectAtIndex:0];
                                 }
                                 
                                 if (notificationView.duration > 0.0)
                                 {
                                     [self performSelector:@selector(showNextNotification)
                                                withObject:nil
                                                afterDelay:notificationView.duration];
                                 }
                                 else {
                                     [self showNextNotification];
                                 }
                             }];
        }
        else {
            __tctNotificationWindow.hidden = YES;
            __tctNotificationWindow.currentNotification = nil;
        }
    }
    
}

@end
