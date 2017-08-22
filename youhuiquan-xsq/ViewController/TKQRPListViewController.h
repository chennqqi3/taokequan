//
//  TKRedPackgeListViewController.h
//  sdfdfff
//
//  Created by sfdasf on 2017/6/1.
//  Copyright © 2017年 sdfccc. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TKBaseViewController.h"

@interface TKQRPListViewController : TKBaseViewController
@property (nonatomic,copy) NSDictionary *dicKeyWord;//关键字
@property (nonatomic,assign) BOOL needPage;//需要分页
@property (nonatomic,assign) BOOL isSearch;//是否是搜索进来的
//aslkfjtest
@property (nonatomic,copy) NSString *url;//链接
@end
