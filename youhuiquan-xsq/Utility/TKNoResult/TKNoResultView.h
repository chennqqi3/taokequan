//
//  TKNoResultView.h
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/5/31.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TKNoResult [TKNoResultView sharedView]

typedef NS_ENUM (NSUInteger, enumAboveOrBelowSubview) {
    enumNotSetToSubView = 0,    // 未设置
    enumAboveSubView,           // 在subView之上
    enumBelowSubView            // 在subView之下
};

typedef NS_ENUM (NSUInteger, enumNoResultType) {
    enumNoResultTypeSearch = 0,       // 结果返回无结果
    enumNoResultTypeLostConnect,      // 用户无网络
    enumNoResultTypeNoService,        // 未连接到服务器或请求超时
    enumNoResultTypeOtherErr,         // 其他错误
    enumNoResultTypeServerException   // 接口返回错误
};

@interface TKNoResultView : UIView

@property (nonatomic, copy, readonly) NSString *imageName;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, copy, readonly) NSString *btnTitle;

@property (nonatomic, strong, readonly) UIImageView *ivNoResult;
@property (nonatomic, strong, readonly) UILabel *lblNoResult;
@property (nonatomic, strong, readonly) UIButton *btnNoResult;
@property (nonatomic, strong, readonly) UILabel *lblNoResultTitle;

@property (nonatomic, copy, readonly) void (^didPressButton)(enumNoResultType newNoResultType);
/**
 *  空态页展示
 *
 *  @param view           空态页显示在哪个父view下，不能为nil
 *  @param aboveOrBelow   在子view上还是下，确定空态页所在层级，传nil则默认在父view顶层
 *  @param subView        相关的子view，确定空态页所在层级，传nil则默认在父view顶层
 *  @param type           空态页类型，不同类型对应不同默认图片和文案
 *  @param imageName      空态页图片名称，传nil则根据type显示默认图片
 *  @param title          空态页标题，传nil则无标题
 *  @param message        空态页内容，传nil则根据type显示默认文案
 *  @param btnTitle       空态页按钮文案，传nil则根据type显示默认按钮文案，didPressButton如果是nil，则此参数无效
 *  @param didPressButton 空态页按钮点击方法，传nil则无按钮
 */
- (void)showNoResultInView:(UIView *)view
              aboveOrBelow:(enumAboveOrBelowSubview)aboveOrBelow
                   subview:(UIView *)subView
              noResultType:(enumNoResultType)type
                 imageName:(NSString *)imageName
                     title:(NSString *)title
                   message:(NSString *)message
                  btnTitle:(NSString *)btnTitle
            didPressButton:(void (^)(enumNoResultType noResultType))didPressButton;

/**
 *  快速生成一个无结果页对象
 *
 *  @return 新的无结果页对象
 */
+ (instancetype)noResultInstance;

/**
 *	@brief	隐藏无结果页面
 */
- (void)hideNoResult;

/**
 *  单例对象
 *
 *  @return 单例无结果页对象
 */
+ (instancetype)sharedView;

#pragma mark - rewrite methods
/**
 可继承重写，配置无结果图标的imageView，请勿主动调用

 @param imageView 无结果图标的imageView
 */
- (void)imageViewConfig:(UIImageView *)imageView;


/**
 可继承重写，配置无结果文案label，请勿主动调用

 @param messageLabel 无结果文案label
 */
- (void)messageLabelConfig:(UILabel *)messageLabel;


/**
 可继承重写，配置无结果的点击按钮，请勿主动调用

 @param button 无结果的点击按钮
 */
- (void)buttonConfig:(UIButton *)button;


/**
 可继承重写，配置无结果的概述label，请勿主动调用

 @param titleLabel 无结果的概述label
 */
- (void)titleLabelConfig:(UILabel *)titleLabel;

@end
