//
//  f;l;wef;wlef
//  wf;,vld;lfl;v
//
//  Created by ;w;ellk923 on 2017/5/31.
//  Copyright © 2017年 ssfd All rights reserved.
//

#import "GlobarSearchBar.h"

@implementation GlobarSearchBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        for (UIView *subViews in view.subviews) {
            if ([subViews isKindOfClass:[UITextField class]]) {
                subViews.frame = CGRectMake(0, 7, self.frame.size.width, 31);
            }
        }
    }
}
//asdfkw
//asdfkw
- (instancetype)init
{
    
    //asdfkw
    self = [super init];
    if (self) {//asdfkw
        self.backgroundImage = [UIImage imageNamed:@"icon_cleanColor"];
        self.barTintColor = RGBA(252,252,252,1);//searchbar背景色
        for (UIView *view in self.subviews) {
            for (UIView *subViews in view.subviews) {
                if ([subViews isKindOfClass:[UITextField class]]) {
                    [subViews.layer setMasksToBounds:YES];
                    [subViews.layer setCornerRadius:15.0]; //设置矩圆角半径
                    subViews.backgroundColor = RGBA(234, 237, 241, 1);//输入框背景色
                }
            }
        }
        UIImage *imgSearch = [UIImage imageNamed:@"icon_home_search"];
        [self setImage:imgSearch forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
    return self;
}

@end
