//
//  fsf
//  sadff
//
//  Created by sdf on 2017/6/3.
//  Copyright © 2017年 as;;v. All rights reserved.
//aweflkklwefwe

#import "TKBaseViewController.h"

@interface TKBaseViewController ()

@end

@implementation TKBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 手势有效设置为YES  无效为NO
        ///fwolkfwefkwef
        weakSelf.navigationController.interactivePopGestureRecognizer.enabled = YES;
        // 手势的代理设置为self
        weakSelf.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 22)];
    [btnBack addTarget:self action:@selector(didPressedBack) forControlEvents:UIControlEventTouchUpInside];
//恭喜啊；wlef
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"btn_Back"] forState:UIControlStateNormal];

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
}


-(void)didPressedBack{
    //frclk bak
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
