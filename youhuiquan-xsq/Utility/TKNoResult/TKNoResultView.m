//
//  TKNoResultView.m
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/5/31.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import "TKNoResultView.h"

typedef enum {
    kSendToBackType = 0,
    kAboveSomeView,
    kBelowSomeView
} subViewType;

static TKNoResultView *sharedNoResultView = nil;

@interface TKNoResultView ()

@property (nonatomic, assign) enumNoResultType noResultType;
@property (nonatomic, assign) BOOL isSpascZero;

@end

@implementation TKNoResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _noResultType = enumNoResultTypeSearch;
        _ivNoResult = [[UIImageView alloc] init];
        _lblNoResult = [[UILabel alloc] init];
        _btnNoResult = [[UIButton alloc] init];
        _lblNoResultTitle = [[UILabel alloc] init];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _noResultType = enumNoResultTypeSearch;
        _ivNoResult = [[UIImageView alloc] init];
        _lblNoResult = [[UILabel alloc] init];
        _btnNoResult = [[UIButton alloc] init];
        _lblNoResultTitle = [[UILabel alloc] init];
        _isSpascZero = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self refreshView];
}

+ (instancetype)noResultInstance
{
    TKNoResultView *noResultView = [[[self class] alloc] init];
    
    return noResultView;
}

- (void)hideNoResult
{
    [self removeFromSuperview];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - 无结果页面显示方法
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
            didPressButton:(void (^)(enumNoResultType noResultType))didPressButton
{
    [self removeFromSuperview];

    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    _noResultType = type;
    _message = message;
    _btnTitle = btnTitle;
    _didPressButton = didPressButton;
    _title = title;
    _imageName = imageName;
    
    switch (aboveOrBelow)
    {
        case enumAboveSubView:
        {
            [view insertSubview:self aboveSubview:subView];
        }
            break;
        case enumBelowSubView:
        {
            [view insertSubview:self belowSubview:subView];
        }
            break;
        case enumNotSetToSubView:
        default:
        {
            [view addSubview:self];
            [view bringSubviewToFront:self];
        }
            break;
    }
    
    [self refreshView];
}

- (void)refreshView
{
    
    [self setBackgroundColor:[UIColor colorWithRed:(float)237/255.0f green:(float)240/255.0f blue:(float)245/255.0f alpha:1]];
    
    [_ivNoResult removeFromSuperview];
    [_lblNoResult removeFromSuperview];
    [_btnNoResult removeFromSuperview];
    [_lblNoResultTitle removeFromSuperview];
    
    [self imageViewConfig:_ivNoResult];
    
    switch (self.noResultType)
    {
        case enumNoResultTypeSearch:
        {
            _ivNoResult.image = [UIImage imageNamed:@"icon_no_result_search"];
            _title = @"查无结果";
            [_lblNoResult setText:@"请换个关键词试试\n如：“花王尿不湿”，更换为“花王”或“尿不湿”查询"];
//            [_btnNoResult setTitle:@"再试试" forState:UIControlStateNormal];
//            [_btnNoResult setTitle:@"再试试" forState:UIControlStateHighlighted];
        }
            break;
        case enumNoResultTypeLostConnect:
        {
            _ivNoResult.image = [UIImage imageNamed:@"icon_no_result_network"];
            _title = @"网络未开启";
            _message = @"客官网络不给力，请稍候再试吧~";
            [_lblNoResult setText:@"请检查网络设置"];
            [_btnNoResult setTitle:@"重新加载" forState:UIControlStateNormal];
            [_btnNoResult setTitle:@"重新加载" forState:UIControlStateHighlighted];
        }
            break;
        case enumNoResultTypeNoService:
        case enumNoResultTypeOtherErr:
        case enumNoResultTypeServerException:
        {
            _ivNoResult.image = [UIImage imageNamed:@"icon_no_result_melt"];
            _title = @"加载失败";
            _message = @"加载错误，请稍候再试吧~";
            [_lblNoResult setText:@"再试一下吧"];
            [_btnNoResult setTitle:@"重新加载" forState:UIControlStateNormal];
            [_btnNoResult setTitle:@"重新加载" forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
    
    [self imageViewConfig:_ivNoResult];
    [self messageLabelConfig:_lblNoResult];
    [self titleLabelConfig:_lblNoResultTitle];
    [self buttonConfig:_btnNoResult];
    [_btnNoResult addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_ivNoResult];
    [self addSubview:_lblNoResult];
    [self addSubview:_btnNoResult];
    [self addSubview:_lblNoResultTitle];
}

- (void)didPressButton:(id)sender
{
    if (self.didPressButton)
    {
        self.didPressButton(self.noResultType);
    }
}

#pragma mark - deprecated methods
+ (id)sharedView
{
    @synchronized(self) {
        if(sharedNoResultView == nil)
            sharedNoResultView = [[self alloc] init];
    }
    return sharedNoResultView;
}

- (id)noResultViewWithType:(enumNoResultType)type
                 showImage:(NSString *)strShowImage
                     title:(NSString *)strTitle
                   message:(NSString *)strMsg
               buttonTitle:(NSString *)strBtnTitle
            pressReconnect:(void (^)(enumNoResultType noResultType))didPressButton
{
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 44);
    self.noResultType = type;
    _imageName = strShowImage;
    _title = strTitle;
    _message = strMsg;
    _btnTitle = strBtnTitle;
    _didPressButton = didPressButton;
    return self;
}


#pragma mark - rewrite methods
/**
 可继承重写，配置无结果图标的imageView，请勿主动调用
 
 @param imageView 无结果图标的imageView
 */
- (void)imageViewConfig:(UIImageView *)imageView {
    if (self.imageName) {
        imageView.image = [UIImage imageNamed:self.imageName];
    }
    CGSize size = [imageView sizeThatFits:CGSizeMake(320, 320)];
    imageView.frame = CGRectMake((self.frame.size.width - size.width) /2, (NSInteger)(self.frame.size.width * 0.23), size.width, size.height);
}

/**
 可继承重写，配置无结果文案label，请勿主动调用
 
 @param messageLabel 无结果文案label
 */
- (void)messageLabelConfig:(UILabel *)messageLabel {
    //LblNoResult Rect
    CGFloat fLblNoResultX           = 20.f;
    CGFloat fLblNoResultY           = CGRectGetMaxY(self.ivNoResult.frame) + 12;
    CGFloat fLblNoResultYWithTitle  = fLblNoResultY + 25;
    CGFloat fLblNoResultWidth       = CGRectGetWidth(self.frame) - 40;
    CGFloat fLblNoResultHeight      = 20.f;
    
    //lblNoResult 内容
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel setTextColor:[UIColor colorWithRed:(float)192/255.0f green:(float)197/255.0f blue:(float)208/255.0f alpha:1]];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.4f]; //设置文本的阴影色彩和透明度。
    messageLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);     //设置阴影的倾斜角度。
    messageLabel.layer.shadowOpacity = 0;//阴影透明度，默认0
    messageLabel.layer.shadowRadius = 4; //阴影半径 默认3
    messageLabel.numberOfLines = 0;
    
    //lblNoResultTitle 标题
    if (self.title) {
        messageLabel.frame = CGRectMake(fLblNoResultX, fLblNoResultYWithTitle, fLblNoResultWidth, fLblNoResultHeight);
        [messageLabel setFont:[UIFont systemFontOfSize:16.f]];
    } else {
        //无标题
        messageLabel.frame = CGRectMake(fLblNoResultX, fLblNoResultY, fLblNoResultWidth, fLblNoResultHeight);
        [messageLabel setFont:[UIFont systemFontOfSize:16.f]];
    }
    
    if (self.message)
    {
        [messageLabel setText:self.message];
    }
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:messageLabel.font, NSFontAttributeName, nil];
    CGRect frame = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, FLT_MAX)
                                                   options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributesDictionary context:nil];
    CGFloat height = round(frame.size.height + 0.5);
    
    [messageLabel setFrame:CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, height)];
}

/**
 可继承重写，配置无结果的点击按钮，请勿主动调用
 
 @param button 无结果的点击按钮
 */
- (void)buttonConfig:(UIButton *)button {
    button.frame = CGRectMake(self.frame.size.width * 0.17, self.lblNoResult.frame.origin.y + self.lblNoResult.frame.size.height + 20, self.frame.size.width * 0.66, 44);
    
    [button setTitleColor:[UIColor colorWithRed:(float)102/255.0f green:(float)102/255.0f blue:(float)102/255.0f alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:(float)102/255.0f green:(float)102/255.0f blue:(float)102/255.0f alpha:1] forState:UIControlStateHighlighted];
    
    UIImage *defaultImage = [self imageWithColor:[UIColor colorWithRed:(float)255/255.0f green:(float)255/255.0f blue:(float)255/255.0f alpha:1] andSize:button.frame.size];
    [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
    UIImage *highlightedImage = [self imageWithColor:[UIColor colorWithRed:(float)238/255.0f green:(float)238/255.0f blue:(float)238/255.0f alpha:1] andSize:button.frame.size];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [button.layer setMasksToBounds:YES];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor colorWithRed:(float)220/255.0f green:(float)220/255.0f blue:(float)220/255.0f alpha:1] CGColor];
    button.layer.cornerRadius = 8.0f;
    
    if (self.btnTitle)
    {
        [button setTitle:self.btnTitle forState:UIControlStateNormal];
        [button setTitle:self.btnTitle forState:UIControlStateHighlighted];
    }
    
    if (self.didPressButton)
    {
        button.hidden = NO;
    }
    else
    {
        button.hidden = YES;
    }
}

/**
 可继承重写，配置无结果的概述label，请勿主动调用
 
 @param titleLabel 无结果的概述label
 */
- (void)titleLabelConfig:(UILabel *)titleLabel {
    //LblNoResultTitleFrame Rect
    CGFloat fLblNoResultTitleX      = 30.f;
    CGFloat fLblNoResultTitleY      = CGRectGetMaxY(self.ivNoResult.frame) + 5;
    CGFloat fLblNoResultTitleWidth  = CGRectGetWidth(self.frame) - 60;
    CGFloat fLblNoResultTitleHeight = 20.f;
    
    //lblNoResultTitle 标题
    if (self.title)
    {
        //有标题
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [titleLabel setTextColor:[UIColor colorWithRed:(float)51/255.0f green:(float)51/255.0f blue:(float)51/255.0f alpha:1]];
        [titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.4f]; //设置文本的阴影色彩和透明度。
        titleLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);     //设置阴影的倾斜角度。
        titleLabel.layer.shadowOpacity = 0;//阴影透明度，默认0
        titleLabel.layer.shadowRadius = 4; //阴影半径 默认3
        [titleLabel setFrame:CGRectMake(fLblNoResultTitleX, fLblNoResultTitleY, fLblNoResultTitleWidth, fLblNoResultTitleHeight)];
        [titleLabel setText:self.title];
    }
    else
    {
        //标题默认为空
        [titleLabel setText:@""];
    }
}
@end
