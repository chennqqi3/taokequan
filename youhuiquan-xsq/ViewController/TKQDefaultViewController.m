//
//  TKCommodityDefaultViewController.m
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/6/1.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import "TKQDefaultViewController.h"
#import "TaokeNetWork.h"
#import "TKQWebViewController.h"
#import "WXApiObject.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "WXApi.h"
#import "NSString+URLCode.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] applicationFrame].size.width

#define RGBA(r,g,b,a)   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface TKQDefaultViewController ()
<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblIntroduce;
@property (weak, nonatomic) IBOutlet UILabel *lblOrg_Price;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice; 
@property (weak, nonatomic) IBOutlet UILabel *lblQuan_price;
@property (weak, nonatomic) IBOutlet UILabel *lblSales_num; 
@property (weak, nonatomic) IBOutlet UITableViewCell *cellDefaut;
@property (weak, nonatomic) IBOutlet UITableView *tvMain;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lcImageHight;
@property (weak, nonatomic) IBOutlet UIButton *btnSumbit;

@end

@implementation TKQDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblTitle.text = @"";
    self.lblIntroduce.text = @"";
    self.lblOrg_Price.text = @"";
    self.lblPrice.text = @"";
    self.lblSales_num.text = @"";
    self.lblQuan_price.text = @"";
    
    self.title = @"宝贝详情";
    float width = [[UIScreen mainScreen] bounds].size.width;
    self.lcImageHight.constant =  width;
    self.lblIntroduce.preferredMaxLayoutWidth = width-30;
    self.lblTitle.preferredMaxLayoutWidth = width-30;

    NSString *picOld = [TaokeNetWork imageConvertWithImageString:self.dicResult[@"pic_url"]];
    [self.imageView setImageWithURL:[NSURL URLWithString:picOld] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [btnRight setTitleColor:color_Main forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnRight setTitle:@"分享" forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(didPressedShare) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    NSString *title = [self.dicResult objectForKey:@"title"];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
    [self.lblTitle setAttributedText:attributedString1];
    
    NSString *introduce = [NSString stringWithFormat:@"小编推荐：%@",[self.dicResult objectForKey:@"intro"]];
    NSMutableAttributedString * attrIntroduce = [[NSMutableAttributedString alloc] initWithString:introduce];
    NSMutableParagraphStyle * paragraphStyleIntroduce = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyleIntroduce setLineSpacing:4];
    [attrIntroduce addAttribute:NSForegroundColorAttributeName value:RGBA(234, 63, 16, 1) range:NSMakeRange(0, [introduce length])];
    [attrIntroduce addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    
    [attrIntroduce addAttribute:NSParagraphStyleAttributeName value:paragraphStyleIntroduce range:NSMakeRange(0, [introduce length])];
    [self.lblIntroduce setAttributedText:attrIntroduce];
    
    float price = [[self.dicResult objectForKey:@"coupon_price"] floatValue];
    float quan = [[self.dicResult objectForKey:@"quan"] floatValue];
    NSString *quanAfterPrice = [NSString stringWithFormat:@"￥%.2f",price-quan];
    
    NSArray *arrPrice = [quanAfterPrice componentsSeparatedByString:@"."];
    NSString *str1 = [arrPrice firstObject];
    NSString *str2 = [arrPrice lastObject];
    str2 = [str2 stringByReplacingOccurrencesOfString:@".00" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    if (str2.length>0) {
        self.lblPrice.text = [NSString stringWithFormat:@"%@.%@",str1,str2];
    }else{
        self.lblPrice.text = str1;
    }
    
    NSString *orgPrice = [NSString stringWithFormat:@"￥%@",[self.dicResult objectForKey:@"coupon_price"]];
    self.lblOrg_Price.text = [orgPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    NSString *quanPrice = [NSString stringWithFormat:@"领%@元券 ",[self.dicResult objectForKey:@"quan"]];
    
    
//    self.lblQuan_price.text = [quanPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    [self.btnSumbit setTitle:[quanPrice stringByReplacingOccurrencesOfString:@".00" withString:@""] forState:UIControlStateNormal];
    [self.btnSumbit setTitle:[quanPrice stringByReplacingOccurrencesOfString:@".00" withString:@""] forState:UIControlStateHighlighted];
//
//    [self.lblQuan_price.layer setMasksToBounds:YES];
//    [self.lblQuan_price.layer setCornerRadius:3]; //设置矩圆角半径
//    [self.lblQuan_price.layer setBorderWidth:0.5];   //边框宽度
//    //边框颜色
//    [self.lblQuan_price.layer setBorderColor:[RGBA(237, 116, 44, 1) CGColor]];
    
    self.lblSales_num.text = [NSString stringWithFormat:@"%@",[self.dicResult objectForKey:@"volume"]];
    [self.tvMain reloadData];

}

-(void)didPressedShare{
    
    NSString *activityId = self.dicResult[@"activity_id"];
    NSString *num_iid = self.dicResult[@"num_iid"];
    
    NSString *urlTaobao = [[NSString stringWithFormat:@"https://uland.taobao.com/coupon/edetail?activityId=%@&pid=%@&itemId=%@",activityId,taokePID,num_iid] URLEncodedString];
    NSString *text = [self.dicResult[@"oldtitle"] URLEncodedString];
    
    NSString *url = [NSString stringWithFormat:@"https://www.58sucai.com/tpwd.php?appkey=23774697&secretKey=774155d7b9353e763faa8124215c4da9&url=%@&text=%@",urlTaobao,text];
    [TaokeNetWork sendPostData:url contentData:@"" successBlock:^(NSDictionary *responseObject, NSDictionary *options) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
            request.text = [NSString stringWithFormat:@"我在淘宝看上这个商品了，你也来看看；复制整条消息%@，然后打开淘宝app就行~",responseObject[@"model"]];

            request.bText = YES;
            request.scene = WXSceneSession;
            [WXApi sendReq:request];
        });
    } failBlock:^(NSError *error, NSDictionary *options) {
        
        
        
    }];
}

- (IBAction)didGotoBuy:(id)sender{
    NSString *num_iid = self.dicResult[@"num_iid"];

    NSString *activityId = self.dicResult[@"activity_id"];
    
    if (activityId.length>0 && num_iid.length>0) {
        NSString *url = [NSString stringWithFormat:@"https://uland.taobao.com/coupon/edetail?activityId=%@&pid=%@&itemId=%@",activityId,taokePID,num_iid];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;

        id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
        AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
        showParams.isNeedPush = YES;//需要push
        
        TKQWebViewController *webView = [[TKQWebViewController alloc] init];
        NSString *title = self.dicResult[@"oldtitle"];
        webView.title = title.length>0?title:self.dicResult[@"title"];
        NSInteger res = [service show:webView
                              webView:webView.webView
                                 page:page
                           showParams:showParams
                          taoKeParams:nil
                           trackParam:nil tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
        if (res==1) {
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {//fasdlkfjlawkeflwqefwqefwef
    [self.cellDefaut.contentView setNeedsDisplay];
    [self.cellDefaut.contentView layoutIfNeeded];
    CGSize size = [self.cellDefaut.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellDefaut;
    //asdflmaklefkw;e
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
