//
//  TKWebViewController.m
//  dsf;kokwgkwefwe
//
//  Created by asffff on 2017/6/2.
//  Copyright © 2017年 a'f;;'we. All rights reserved.
//

#import "TKQWebViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface TKQWebViewController ()
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation TKQWebViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
//sfasd
        _webView.scrollView.scrollEnabled = YES;
        [self.view addSubview:_webView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [TKNoResult hideNoResult];
    [self.hud hide:YES];
    self.hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode=MBProgressHUDModeCustomView;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loadingtk" ofType:@"gif"];
    GifView *dataView2 = [[GifView alloc] initWithFrame:CGRectMake(0, 0, 80, 80) filePath:path];
    _hud.color = [UIColor clearColor];

    _hud.customView =dataView2;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.hud hide:YES];
    //其他错误
     if (error.code == -1009) {
         [TKNoResult hideNoResult];
         [TKNoResult showNoResultInView:self.view
                           aboveOrBelow:enumAboveSubView
                                subview:self.webView
                           noResultType:enumNoResultTypeLostConnect
                              imageName:nil
                                  title:nil  message:nil
                               btnTitle:nil
                         didPressButton:nil];
//        无网络
//         as.dfasf
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
