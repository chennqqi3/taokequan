//
//  asdfsadf
//  sdfasdf
//
//  Created by dfasdf on 2017/6/2.
//  Copyright © 2017年 safd. All rights reserved.
//
#ifndef AlibcTradeWantViewController_h
#define AlibcTradeWantViewController_h

#import <UIKit/UIKit.h>
#import "TKBaseViewController.h"
@interface TKQWebViewController : TKBaseViewController
<UIWebViewDelegate>

@property (nonatomic,copy) NSString *sUrl;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
//

//
/*
 
 #pragma mark - UIScrollerDelegate
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 if (self.isSearch) {
 [searchController.searchBar resignFirstResponder];
 }
 if (scrollView.contentOffset.y > SCREEN_HEIGHT) {
 self.btnScrollerUp.hidden = NO;
 }
 else{
 self.btnScrollerUp.hidden = YES;
 }
 }
 */
@end

#endif /* AlibcTradeWantViewController_h */
