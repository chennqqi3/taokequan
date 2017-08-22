//
//  TKMainViewController.m
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/5/31.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import "TKMainViewController.h"
#import "TKMainCell.h"
#import "TaokeNetWork.h" 
#import "TKQDefaultViewController.h"
#import "TKQRPListViewController.h"
#import "TKMainHeaderCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "TKFilterCell.h"
#import "TKRedPackgeCell.h"
#import "TKFilterCollectionHeaderView.h"
static CGFloat kButtonBackgroundShowAlpha = 0.6f;

@interface TKMainViewController ()
@property(nonatomic,retain) NSMutableArray *arrayResult;
@property(nonatomic,retain) NSMutableArray *arrFilterProjectNames;
//@property (weak, nonatomic) IBOutlet UICollectionView *conllectionView;
//@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UITableView *tvMain;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTop;
@property (weak, nonatomic) IBOutlet UICollectionView *cvProjectSelect;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayoutProject;
@property (nonatomic, weak) IBOutlet UIButton *btnScrollerUp;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cvHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cvTopContraint;
@property (nonatomic) CGFloat fCollectionViewHeight;
@property (nonatomic) BOOL hasShowFilterView;
@property (nonatomic,assign) NSInteger iSelectedIndex;
@property (strong, nonatomic)  UIButton *btnBackground;

@property (assign, nonatomic)int page;
@end

@implementation TKMainViewController
- (UIButton *)btnBackground
{
    if (!_btnBackground) {
        _btnBackground = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBackground.frame = CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX);
        _btnBackground.alpha = 0.f;
        _btnBackground.backgroundColor = [UIColor blackColor];
        [_btnBackground addTarget:self action:@selector(didPressHiddenProjectSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBackground;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"淘券吧";
//    self.navigationItem.titleView = self.viewTitle;

    //网络检测
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
 
    //初始化
    [self loadDefautView];
}

-(void)loadDefautView{
    self.iSelectedIndex = -1;
    _arrFilterProjectNames = [NSMutableArray arrayWithObjects:@{@"女装":@"1"},
                              @{@"男装":@"2"},
                              @{@"内衣":@"3"},
                              @{@"母婴":@"4"},
                              @{@"包包":@"5"},
                              @{@"居家":@"7"},
                              @{@"鞋品":@"8"},
                              @{@"美食":@"9"},
                              @{@"文体":@"10"},
                              @{@"家电":@"11"},
                              @{@"配饰":@"13"},
                              @{@"数码":@"14"},
                              @{@"其他":@"12"},nil];
    
    self.cvProjectSelect.contentInset = UIEdgeInsetsMake(10, 14, 2, 14);
    self.flowLayoutProject.itemSize = CGSizeMake(floorf((SCREEN_WIDTH - 48)/3.f), 35.f);
    self.flowLayoutProject.minimumLineSpacing = 10.f;
    self.flowLayoutProject.minimumInteritemSpacing = 10.f;
    self.flowLayoutProject.scrollDirection = UICollectionViewScrollDirectionVertical;
//    self.flowLayoutProject.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);

//    self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2+MAINHEIGHT);
//    self.flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 100);
    
    int lines = (_arrFilterProjectNames.count/3.f);
    BOOL lineOther = _arrFilterProjectNames.count%3>0;
    lines = lines + lineOther;
    
    //collectionView高度
    CGFloat rowHeight = (35.f * lines) + ((lines - 1) * 10);
    CGFloat margin = 12;
    CGFloat headersize = 40;
    
    self.fCollectionViewHeight =  rowHeight + margin + headersize + 10;
    self.cvHeightConstraint.constant = self.fCollectionViewHeight;
    
    self.cvTopContraint.constant = self.hasShowFilterView ? (64.0) : (-self.fCollectionViewHeight);
    [self.cvProjectSelect reloadData];
    [self.view insertSubview:self.btnBackground belowSubview:self.cvProjectSelect];

    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    [btnBack setBackgroundImage: [UIImage imageNamed:@"icon_home_search"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [btnBack addTarget:self action:@selector(didPressedSearch) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [btnRight setTitleColor:color_Main forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnRight setTitle:@"筛选" forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(didPressedFilter) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = leftBarItem;
    self.navigationItem.leftBarButtonItem = rightBarItem;

    
//    [self.btnSearch addTarget:self action:@selector(didPressedSearch) forControlEvents:UIControlEventTouchUpInside];
//    self.btnSearch.layer.cornerRadius = 12;
//    self.btnSearch.clipsToBounds = YES;
//    [self.btnSearch setBackgroundColor:RGBA(234, 237, 241, 1)];
//    //创建一个layout布局类
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    //设置布局方向为垂直流布局
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 0;
//    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 10);
//    //设置每个item的大小
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2+MAINHEIGHT);
//    //创建collectionView 通过一个布局策略layout来创建
//    self.conllectionView.collectionViewLayout = layout;
//    
//    [self.conllectionView registerNib:[UINib nibWithNibName:@"TKMainCell" bundle:nil] forCellWithReuseIdentifier:@"TKMainCell"];
//    
//    [self.conllectionView registerClass:[TKMainHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"tkHeaderCell"];
    
    
    
    [self.cvProjectSelect registerClass:[TKFilterCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TKFilterCollectionHeaderViewIdentifier];

    [self.cvProjectSelect registerClass:[TKFilterCell class] forCellWithReuseIdentifier:TKFilterCellIdentifier];

    //请求首页数据
    [self fetchGetRequest];
    [self addFooter];
    
}

-(void)didPressedSearch{
    TKQRPListViewController *search = [TKQRPListViewController new];
    search.isSearch = YES;
    search.needPage = YES;
    [self.navigationController pushViewController:search animated:YES];
}

-(void)didPressedFilter{
    if (self.hasShowFilterView) {
        [self didPressHiddenProjectSelect];
    }else{
        [self showCollectionView];
    }
}

- (void)didPressHiddenProjectSelect {
    __weak typeof(self) weakSelf = self;
    [self hiddenCollectionViewCompletionBlock:^{
        weakSelf.cvProjectSelect.hidden = YES;
    }];
}

- (void)networkChanged:(NSNotification *)noti
{
    AFNetworkReachabilityStatus status;
    status = [noti.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (AFNetworkReachabilityStatusNotReachable != status && self.arrayResult.count == 0) {
        [self fetchGetRequest];
    }
}


- (void)showCollectionView
{
    self.cvProjectSelect.hidden = NO;
    self.cvTopContraint.constant = 64.0;
    self.btnBackground.alpha = 0.f;
    [UIView animateWithDuration:0.25 animations:^{
        self.btnBackground.alpha = kButtonBackgroundShowAlpha;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hasShowFilterView = YES;
    }];
}

- (void)hiddenCollectionViewCompletionBlock:(void(^)(void))completionBlock
{
    self.cvTopContraint.constant = - self.fCollectionViewHeight;
    self.btnBackground.alpha = kButtonBackgroundShowAlpha;
    [UIView animateWithDuration:0.25 animations:^{
        self.btnBackground.alpha = 0.f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hasShowFilterView = NO;
        !completionBlock ?: completionBlock();
    }];
}


-(void)fetchGetRequest{
    __weak __typeof(self) weakSelf = self;
    self.page ++;
    MBProgressHUD *hud=nil;
    if (self.page==1) {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeCustomView;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loadingtk" ofType:@"gif"];
        GifView *dataView2 = [[GifView alloc] initWithFrame:CGRectMake(0, 0, 80, 80) filePath:path];
        hud.customView =dataView2;
        hud.color = [UIColor clearColor];
        hud.removeFromSuperViewOnHide=YES;
    }
    
    NSString *url = [NSString stringWithFormat:@"https://www.58sucai.com/pinpai.php?pname=order&aname=onlines&p=%d&onlines=desc&json=1",self.page];
    [TaokeNetWork sendPostData:url successBlock:^(NSArray *responseObject, NSDictionary *options) {
        if (weakSelf.arrayResult==nil) {
            weakSelf.arrayResult = [NSMutableArray arrayWithArray:responseObject];
        }else{
            [weakSelf.arrayResult addObjectsFromArray:responseObject];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [TKNoResult hideNoResult];
            if (hud) {
                [hud hide:YES];
            }
            
            [weakSelf.tvMain.mj_footer setHidden:NO];
            [weakSelf.tvMain reloadData];
            [weakSelf.tvMain.mj_footer endRefreshing];
        });
    } failBlock:^(NSError *error, NSDictionary *options) {
       
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (hud) {
                [hud hide:YES];
            }
            BOOL needNoResult = YES;
            //其他错误
            enumNoResultType errType = enumNoResultTypeOtherErr;
            void(^didPressButtonBlock)(enumNoResultType newNoResultType) = nil;
            if (error.code == ResultNullKey){
                if (weakSelf.arrayResult.count>0) {
                    needNoResult = NO;
                    [weakSelf.tvMain.mj_footer setHidden:YES];
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
                                       subview:weakSelf.tvMain
                                  noResultType:errType
                                     imageName:nil
                                         title:nil
                                       message:nil
                                      btnTitle:nil
                                didPressButton:didPressButtonBlock];
            } 
            
            weakSelf.page--;
            [weakSelf.tvMain.mj_footer endRefreshing];
        });
       
    }];
}

- (void)addFooter
{
    __weak __typeof(self) weakSelf = self;
    // 上拉刷新
    self.tvMain.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchGetRequest];
    }];
}
//  Created by sadmllvaaw on 2017/5/31.


- (IBAction)didGotoTwo:(id)sender{
    TKQRPListViewController *rpView = [TKQRPListViewController new];
    rpView.url = @"https://www.58sucai.com/search.php?pname=where&aname=isjhs&pid=1&isjhs=1&json=1";
    rpView.needPage = YES;
    [self.navigationController pushViewController:rpView animated:YES];
}
#pragma mark - action
- (IBAction)didGotoOne:(id)sender{
    TKQRPListViewController *rpView = [TKQRPListViewController new];
    rpView.url = @"https://www.58sucai.com/search.php?pname=between&aname=submit&commission_rates%5B0%5D=40&commission_rates%5B1%5D=0&json=1";
    rpView.needPage = YES;
    //  Created by sadmllvaaw on 2017/5/31.

    [self.navigationController pushViewController:rpView animated:YES];
}



- (IBAction)didGotoThree:(id)sender{
    TKQRPListViewController *rpView = [TKQRPListViewController new];
    rpView.url = @"https://www.58sucai.com/search.php?pname=where&aname=ishaiwai&ishaiwai=1&json=1";
    rpView.needPage = YES;
    [self.navigationController pushViewController:rpView animated:YES];
}
- (IBAction)didPressScrollerUpButton:(id)sender
{
    [self.tvMain setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didGotoNine:(id)sender{
    TKQRPListViewController *rpView = [TKQRPListViewController new];
    rpView.url = @"https://www.58sucai.com/search.php?pname=between&aname=submit&coupon_prices%5B1%5D=10&json=1";
    rpView.needPage = YES;
    [self.navigationController pushViewController:rpView animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = self.arrayResult.count == 0;
    return self.arrayResult.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 100;
    }
    return 95;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return self.cellTop;
    }
    TKRedPackgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKRedPackgeCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TKRedPackgeCell" owner:self options:nil];
        cell = nibs.firstObject;
    }
    
    NSDictionary *dic = self.arrayResult[indexPath.row-1];
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
    
    cell.lblSales_num.text = [NSString stringWithFormat:@"销量%@",[dic objectForKey:@"volume"]];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayResult.count<=0) {
        return;
    }
    NSDictionary *dic = self.arrayResult[indexPath.row-1];
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
    if (collectionView == self.cvProjectSelect) {
        return self.arrFilterProjectNames.count;
    }
//    collectionView.mj_footer.hidden = self.arrayResult.count == 0;
//    return self.arrayResult.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionViews == self.cvProjectSelect) {
        TKFilterCell *cell = [collectionViews dequeueReusableCellWithReuseIdentifier:TKFilterCellIdentifier forIndexPath:indexPath];
        NSDictionary *objc = self.arrFilterProjectNames[indexPath.row];
        BOOL isSelected = (indexPath.row == self.iSelectedIndex);
        [cell configureUIWithString:[[objc allKeys] firstObject]
                        hasSelected:isSelected];
        return cell;
    }
    return [UICollectionViewCell new];
}
//
//
//    if (self.arrayResult.count) {
//        TKMainCell *cell = [collectionViews dequeueReusableCellWithReuseIdentifier:@"TKMainCell" forIndexPath:indexPath];
//        
//        cell.lblTitle.text = @"";
//        cell.lblSales_num.text = @"";
//        cell.lblMoney.text = @"";
//        cell.lblQuan.text = @"";
//        NSDictionary *dic = self.arrayResult[indexPath.row];
//
//        NSString *title = dic[@"oldtitle"];
//        cell.lblTitle.text = title.length>0?title:dic[@"title"];
//        cell.lblOrg_Price.text = [[NSString stringWithFormat:@"原价 ￥%@",[dic objectForKey:@"coupon_price"]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
//        
//        
//        
//        [cell.lblQuan.layer setMasksToBounds:YES];
//        [cell.lblQuan.layer setCornerRadius:3]; //设置矩圆角半径
//        [cell.lblQuan.layer setBorderWidth:0.5];   //边框宽度
//        //边框颜色
//        [cell.lblQuan.layer setBorderColor:[RGBA(231, 101, 130, 1) CGColor]];
//        float price = [[dic objectForKey:@"coupon_price"] floatValue];
//        float quan = [[dic objectForKey:@"quan"] floatValue];
//        NSString *quanAfterPrice = [NSString stringWithFormat:@"￥%.2f",price-quan];
//        NSArray *arrPrice = [quanAfterPrice componentsSeparatedByString:@"."];        NSString *str2 = [arrPrice lastObject];
//
//        NSString *str1 = [arrPrice firstObject];
//        str2 = [str2 stringByReplacingOccurrencesOfString:@".00" withString:@""];
//        str2 = [str2 stringByReplacingOccurrencesOfString:@"0" withString:@""];
//        
//        if (str2.length>0) {
//            cell.lblMoney.text = [NSString stringWithFormat:@"%@.%@",str1,str2];
//        }else{
//            cell.lblMoney.text = str1;
//        }
//        
//        NSString *quan_price = [NSString stringWithFormat:@" %.2f元优惠券 ",quan];
//        cell.lblQuan.text = [quan_price stringByReplacingOccurrencesOfString:@".00" withString:@""];
//        
//        cell.lblSales_num.text = [NSString stringWithFormat:@"已售%@",[dic objectForKey:@"volume"]];
//
//        NSString *picOld = [TaokeNetWork imageConvertWithImageString:dic[@"pic_url"]];
//        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_230x230.jpg",picOld]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
//        
//        return cell;
//    }
//    return UICollectionViewCell.new;
//}
//
//#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionViews didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionViews == self.cvProjectSelect) {
        self.iSelectedIndex = indexPath.row;
        [collectionViews reloadData];
        TKQRPListViewController *search = [TKQRPListViewController new];
        search.isSearch = YES;
        NSDictionary *objc = self.arrFilterProjectNames[indexPath.row];
        search.needPage = YES;
        self.cvProjectSelect.hidden = YES;

        search.dicKeyWord = objc;
        [self didPressHiddenProjectSelect];
        [self.navigationController pushViewController:search animated:YES];
        return;
    }}
//
//    if (self.arrayResult.count<=0) {
//        return;
//    }
//    NSDictionary *dic = self.arrayResult[indexPath.row];
//    if (dic) {
//        
////        self.cvProjectSelect.hidden = YES;
//
//        TKCommodityDefaultViewController *defaultView = [TKCommodityDefaultViewController new];
//        defaultView.dicResult = dic;
//        [self.navigationController pushViewController:defaultView animated:YES];
//    }
//}
#pragma mark - UIScrollerDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{///asflwet
    if (scrollView.contentOffset.y > SCREEN_HEIGHT) {
        self.btnScrollerUp.hidden = NO;
    }
    else{
        self.btnScrollerUp.hidden = YES;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (collectionView == self.conllectionView)
//    {
//        //        self.cvProjectSelect.hidden = YES;
//
//        return CGSizeMake(SCREEN_WIDTH, 100);
//        
//    }else
        if (collectionView == self.cvProjectSelect)
    {
        //        self.cvProjectSelect.hidden = YES;
//sfljasdflas
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{//asdfljal;wef
    if (kind == UICollectionElementKindSectionHeader)
    {
//        if (collectionView == self.conllectionView) {
//            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"tkHeaderCell" forIndexPath:indexPath];
//            [headerView addSubview:self.headView];
//            self.headView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, 100);
//            return headerView;
//            //        self.cvProjectSelect.hidden = YES;
//
//        }else
        {
            TKFilterCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TKFilterCollectionHeaderViewIdentifier forIndexPath:indexPath];
            headerView.titleText = @"请选择分类";
            //        self.cvProjectSelect.hidden = YES;
//f/
            return headerView;
        }
    }
    return nil;
}



@end
