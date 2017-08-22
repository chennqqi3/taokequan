//
//  TKRedPackgeListViewController.m
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/6/1.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import "TKQRPListViewController.h"
#import "TaokeNetWork.h"
#import "TKRedPackgeCell.h"
#import "TKQDefaultViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "SearchBarController.h"
#import "TKMainCell.h"

@interface TKQRPListViewController ()
<
SearchBarControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
    SearchBarController *searchController;
}
@property (weak, nonatomic) IBOutlet UICollectionView *conllectionView;
@property(nonatomic,retain) NSMutableArray *arrayResult;
@property (weak, nonatomic) IBOutlet UITableView *tvMain;
@property (assign, nonatomic)int page;
@property (nonatomic, weak) IBOutlet UIButton *btnScrollerUp;
@end

@implementation TKQRPListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDefaultData];
    [self createBaseView]; 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isSearch) {
        [searchController.searchBar resignFirstResponder];
    }
}


- (void)createBaseView{
    if (self.isSearch) {
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        [btnRight setTitleColor:color_Main forState:UIControlStateNormal];
        [btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btnRight setTitle:@"取消" forState:UIControlStateNormal];
        [btnRight addTarget:self action:@selector(didPressedCancel) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
//        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 10);
        //设置每个item的大小
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2+MAINHEIGHT);
        //创建collectionView 通过一个布局策略layout来创建
        self.conllectionView.collectionViewLayout = layout;
        
        [self.conllectionView registerNib:[UINib nibWithNibName:@"TKMainCell" bundle:nil] forCellWithReuseIdentifier:@"TKMainCell"];
        searchController = [[SearchBarController alloc] init];
        
        searchController.delegate = self;
        self.navigationItem.titleView = [searchController initializeSearchBar:self.view];
        if (self.dicKeyWord) {
            searchController.searchBar.text = [[self.dicKeyWord allKeys] firstObject];
        }else{
            [searchController.searchBar becomeFirstResponder];
        }
    }else{
        
        self.title = @"优惠券列表";
    }
}

- (void)loadDefaultData{
    //total时支持分页
    if (self.needPage) {
        [self addFooter];
    }
    if (self.isSearch) {
        if (self.dicKeyWord) {
            self.url = [NSString stringWithFormat:@"https://www.58sucai.com/search.php?pname=&aname=cid&json=1&p=1&pid=1&cid=%@",[[self.dicKeyWord allValues] firstObject]];
            [self fetchGetRequest];
        }
    }else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
        //asfasdf
        [self fetchGetRequest];
    }
   
}


-(void)dealloc{
    
    
    ////fasdf;lk;welf
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

#pragma mark - action
- (IBAction)didPressScrollerUpButton:(id)sender
{
    //ftstl
    UIScrollView *scroll = self.tvMain;
    if (self.isSearch) {
        scroll = self.conllectionView;
        [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [scroll setContentOffset:CGPointMake(0, -64) animated:YES];
    }
    
    
}
- (void)networkChanged:(NSNotification *)noti
{
    AFNetworkReachabilityStatus status;
    status = [noti.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (AFNetworkReachabilityStatusNotReachable != status && self.arrayResult.count == 0) {
        [self fetchGetRequest];    //ftstl
        
    }
}

-(void)didPressedCancel{
    //ftstl

    if (self.arrayResult.count) {
        searchController.searchBar.text=@"";
        [searchController.searchBar becomeFirstResponder];
        self.page = 0;    //ftstl

        [self.arrayResult removeAllObjects];
        [self.conllectionView reloadData];    //ftstl

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)fetchGetRequest{
    NSString *url = self.url;
    [TKNoResult hideNoResult];

    self.page ++;
    //total时支持分页
    if (self.needPage) {
        url = [NSString stringWithFormat:@"%@&p=%d",url,self.page];
    }
    
    MBProgressHUD *hud=nil;
    if (self.page==1) {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeCustomView;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loadingtk" ofType:@"gif"];
        GifView *dataView2 = [[GifView alloc] initWithFrame:CGRectMake(0, 0, 80, 80) filePath:path];
        hud.color = [UIColor clearColor];
        hud.customView =dataView2;
        hud.removeFromSuperViewOnHide=YES;
    }
    
    __weak __typeof(self) weakSelf = self;
    [TaokeNetWork sendPostData:url successBlock:^(NSArray *responseObject, NSDictionary *options) {
        if (weakSelf.arrayResult==nil) {
            weakSelf.arrayResult = [NSMutableArray arrayWithArray:responseObject];
        }else{
            [weakSelf.arrayResult addObjectsFromArray:responseObject];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{

            if (hud) {
                [hud hide:YES];
            }
            if (self.isSearch) {
                weakSelf.conllectionView.delegate = self;
                weakSelf.conllectionView.dataSource = self;
                [weakSelf.conllectionView.mj_footer setHidden:NO];
                [weakSelf.conllectionView reloadData];
                weakSelf.conllectionView.hidden = NO;
                [weakSelf.conllectionView.mj_footer endRefreshing];
            }else{
                weakSelf.tvMain.delegate = self;
                weakSelf.tvMain.dataSource = self;
                [weakSelf.tvMain.mj_footer setHidden:NO];
                [weakSelf.tvMain reloadData];
                weakSelf.tvMain.hidden = NO;
                [weakSelf.tvMain.mj_footer endRefreshing];
            }
        });
    } failBlock:^(NSError *error, NSDictionary *options) {
        weakSelf.page--;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            UIScrollView *scroll = self.tvMain;
            if (self.isSearch) {
                scroll = self.conllectionView;
            }
            if (hud) {
                [hud hide:YES];
            }
            scroll.hidden = NO;
            BOOL needNoResult = YES;
            //其他错误
            enumNoResultType errType = enumNoResultTypeOtherErr;
            void(^didPressButtonBlock)(enumNoResultType newNoResultType) = nil;
            if (error.code == ResultNullKey){
                if (weakSelf.arrayResult.count>0) {
                    needNoResult = NO;
                    [weakSelf.conllectionView.mj_footer setHidden:YES];
                }else{
                    errType = enumNoResultTypeSearch;
                }
                
            }else {
                didPressButtonBlock = ^(enumNoResultType newNoResultType){
                    [weakSelf fetchGetRequest];
                };
                if (error.code == ResultNetWorkKey) {
                    //无网络
                    errType = enumNoResultTypeLostConnect;
                }
            }
            [TKNoResult hideNoResult];
            if (needNoResult) {
                [TKNoResult showNoResultInView:weakSelf.view
                                  aboveOrBelow:enumAboveSubView
                                       subview:scroll
                                  noResultType:errType
                                     imageName:nil
                                         title:nil message:nil
                                      btnTitle:nil
                                didPressButton:didPressButtonBlock];
            }
            
            [scroll.mj_footer endRefreshing];
        });
    }];
}



- (void)addFooter
{
    // 上拉刷新
    __weak __typeof(self) weakSelf = self;

    UIScrollView *scroll = self.tvMain;
    if (self.isSearch) {
        scroll = self.conllectionView;
    }
    
    scroll.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchGetRequest];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = self.arrayResult.count == 0;
    return self.arrayResult.count;
    ///    __weak __typeof(self) weakSelf = self;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKRedPackgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKRedPackgeCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TKRedPackgeCell" owner:self options:nil];
        cell = nibs.firstObject;
    }
    
    NSDictionary *dic = self.arrayResult[indexPath.row];
    NSString *imageUrl = [TaokeNetWork imageConvertWithImageString:dic[@"pic_url"]];
    [cell.imageViewIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_230x230.jpg",imageUrl]] placeholderImage:[UIImage imageNamed:@"icon_default"]];

    ///    __weak __typeof(self) weakSelf = self;
////
    NSString *title = dic[@"oldtitle"];
    cell.lblTitle.text = title.length>0?title:dic[@"title"]; 
    
    float price = [[dic objectForKey:@"coupon_price"] floatValue];
    float quan = [[dic objectForKey:@"quan"] floatValue];
    NSString *quanAfterPrice = [NSString stringWithFormat:@"￥%.2f",price-quan];

    NSArray *arrPrice = [quanAfterPrice componentsSeparatedByString:@"."];
    NSString *str1 = [arrPrice firstObject];
    NSString *str2 = [arrPrice lastObject];
    str2 = [str2 stringByReplacingOccurrencesOfString:@".00" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    if (str2.length>0) {
        cell.lblPrice.text = [NSString stringWithFormat:@"%@.%@",str1,str2];
    }else{
        cell.lblPrice.text = str1;
    }
    NSString *quanPrice = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"quan"]];
    cell.lblQuan_price.text = [quanPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    NSString *orgPrice = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"coupon_price"]];
    cell.lblOrg_Price.text = [orgPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
//    NSAttributedString *attrStr =
//    [[NSAttributedString alloc]initWithString:[orgPrice stringByReplacingOccurrencesOfString:@".00" withString:@""]
//                                   attributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:20.f],
//       NSForegroundColorAttributeName:RGBA(153, 153, 153, 1),
//       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
//       NSStrikethroughColorAttributeName:RGBA(153, 153, 153, 1)}];
//    
//    cell.lblOrg_Price.attributedText = attrStr;
//    cell.lblOrg_Price.;
    cell.lblSales_num.text = [NSString stringWithFormat:@"销量%@",[dic objectForKey:@"volume"]];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayResult.count<=0) {
        return;
    }
    NSDictionary *dic = self.arrayResult[indexPath.row];
    if (dic) {
        TKQDefaultViewController *defaultView = [TKQDefaultViewController new];
        defaultView.dicResult = dic;
        [self.navigationController pushViewController:defaultView animated:YES];
    }
    
}


#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    collectionView.mj_footer.hidden = self.arrayResult.count == 0;
    return self.arrayResult.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayResult.count) {
        return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2+MAINHEIGHT);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayResult.count) {
        NSDictionary *dic = self.arrayResult[indexPath.row];
        TKMainCell *cell = [collectionViews dequeueReusableCellWithReuseIdentifier:@"TKMainCell" forIndexPath:indexPath];
        [cell.lblQuan.layer setMasksToBounds:YES];
        [cell.lblQuan.layer setCornerRadius:3]; //设置矩圆角半径
        [cell.lblQuan.layer setBorderWidth:0.5];   //边框宽度
        cell.lblQuan.text = @"";
        cell.lblMoney.text = @"";
        cell.lblTitle.text = @"";
        
        NSString *title = dic[@"oldtitle"];
        cell.lblTitle.text = title.length>0?title:dic[@"title"];
        float price = [[dic objectForKey:@"coupon_price"] floatValue];
        float quan = [[dic objectForKey:@"quan"] floatValue];
        NSString *quanAfterPrice = [NSString stringWithFormat:@"￥%.2f",price-quan];
        cell.lblMoney.text = [quanAfterPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
        
        NSString *quan_price = [NSString stringWithFormat:@" %.2f元优惠券 ",quan];
        cell.lblQuan.text = [quan_price stringByReplacingOccurrencesOfString:@".00" withString:@""];
        cell.lblOrg_Price.text = [[NSString stringWithFormat:@"原价 ￥%@",[dic objectForKey:@"coupon_price"]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        
        //边框颜色
        [cell.lblQuan.layer setBorderColor:[RGBA(231, 101, 130, 1) CGColor]];
        
        cell.lblSales_num.text = [NSString stringWithFormat:@"已售%@",[dic objectForKey:@"volume"]];
        NSString *picOld = [TaokeNetWork imageConvertWithImageString:dic[@"pic_url"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:picOld] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        
        return cell;
    }
    return UICollectionViewCell.new;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionViews didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayResult.count<=0) {
        return;
    }
    NSDictionary *dic = self.arrayResult[indexPath.row];
    if (dic)
    {
        TKQDefaultViewController *defaultView = [TKQDefaultViewController new];
        defaultView.dicResult = dic;
        [self.navigationController pushViewController:defaultView animated:YES];
    }
}

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
#pragma mark - 键盘搜索按钮点击操作
- (void)searchBarControllerDelegate:(SearchBarController*)searchBarController
                searchButtonClicked:(NSString*)text{
    self.page = 0;
    [self.arrayResult removeAllObjects];
    [self.conllectionView reloadData];
    NSString *transString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.url = [NSString stringWithFormat:@"https://www.58sucai.com/search.php?kiss=%@&pname=search&aname=submit2&json=1",transString];
    [self fetchGetRequest];
}



@end
