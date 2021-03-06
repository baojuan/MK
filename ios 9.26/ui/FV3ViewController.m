//
//  FV3ViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "FV3ViewController.h"
#import "NewsiPhoneCell.h"
#import "GDataXMLNode.h"
#import "ArticleModel.h"
#import "WebViewController.h"
#import "MJRefresh.h"
#import "NewsDetailViewController.h"
#import "XLCycleScrollView.h"
#import "GetVideoUrlAndPresentViewPlayViewController.h"
#import "ScanPictureViewController.h"
#import "SimplerWebViewController.h"
#import "NewsDetailViewControllerForPad.h"
#import "WebViewControllerForPad.h"

@interface FV3ViewController ()<UITableViewDataSource,UITableViewDelegate, MJRefreshBaseViewDelegate,XLCycleScrollViewDelegate,XLCycleScrollViewDatasource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *bannerArray;


@end

@implementation FV3ViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    XLCycleScrollView *csView;

    NewsDetailViewControllerForPad *web;
    WebViewControllerForPad *webPad;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        _page = 1;
        _dataArray = [[NSMutableArray alloc] init];
        _bannerArray = [[NSMutableArray alloc] init];

    }
    return self;
}

+ (NSString *)getTypeId
{
    return @"1";
}
- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationView = [[MKNavigationView alloc] initWithTitle:self.navTitle leftButtonImage:IMAGENAMED(@"navleft") rightButtonImage:IMAGENAMED(@"navright") ForPad:YES ForPadFullScreen:NO];
        
    }
    else {
        navigationView = [[MKNavigationView alloc] initWithTitle:self.navTitle leftButtonImage:IMAGENAMED(@"navleft") rightButtonImage:IMAGENAMED(@"navright") ForPad:NO ForPadFullScreen:NO];
        
    }
    
    [self.view addSubview:navigationView];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [navigationView.rightButton addTarget:self action:@selector(openLeftDrawer) forControlEvents:UIControlEventTouchUpInside];
        [navigationView.leftButton setImage:Nil forState:UIControlStateNormal];
        [navigationView.rightButton setImage:IMAGENAMED(@"navleft") forState:UIControlStateNormal];
    }
    else {
        [navigationView.leftButton addTarget:self action:@selector(openLeftDrawer) forControlEvents:UIControlEventTouchUpInside];
        [navigationView.rightButton addTarget:self action:@selector(openRightDrawer) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)openLeftDrawer
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [appdelegate addLeftViewToViewForPadAnimated:YES];
    }
    else {
        [appdelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
    }
}

- (void)openRightDrawer
{
    [appdelegate.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([appdelegate.haveType length] == 0) {
        [self getBannerData];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(appdelegate.padBackgroundImageName)];
    }
    else
    {
        if (appdelegate.navigationStyle) {
            self.view.backgroundColor = appdelegate.navigationBackgroundImageColor;
        }
        else {
            self.view.backgroundColor = appdelegate.navigationBackgroundColor;
        }
    }
    [self setHeadView];
    [self setTableViewProperty];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [appdelegate addLeftViewToViewForPadAnimated:YES Appear:YES];
        [appdelegate resetTabbarFrame];
    }
}


- (void)getBannerData
{
    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/app/news%@.xml",HOST,appdelegate.topicId];
    [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finishBannerMethod:" failMethod:@"failBannerMethod:"];
}

- (void)finishBannerMethod:(NSData *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSError *error;
    GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
    NSArray *employees = [pagedoc nodesForXPath:@"//iteam" error:NULL];
    if ([employees count] == 0) {
        return;
    }
    for (GDataXMLElement *employe in employees) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dict setObject:[[employe attributeForName:@"thumb"] stringValue] forKey:@"thumb"];
        [dict setObject:[[employe attributeForName:@"link"] stringValue] forKey:@"link"];
        [dict setObject:[[employe attributeForName:@"title"] stringValue] forKey:@"title"];
        [dict setObject:[[employe attributeForName:@"classes"] stringValue] forKey:@"classes"];//classes 10 网页 就是typeid
        
        [array addObject:dict];
    }
    [_bannerArray addObjectsFromArray:array];
    [self setBannerView];
    [csView reloadData];
}

- (void)failBannerMethod:(NSError *)error
{
    MKLog(@"banner获取失败%@",error);
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"报错"
                                            action:@"banner获取失败"
                                             label:[NSString stringWithFormat:@"banner获取失败%@",error]
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
    [MobClick event:[NSString stringWithFormat:@"banner获取失败%@",error]];
    
}

- (void)setBannerView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        csView = [[XLCycleScrollView alloc] initWithFrame:RECT(0, 0, 470, 470 / 2.0)];
    }
    else {
        csView = [[XLCycleScrollView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, 320 / 2.0)];
    }
    csView.backgroundColor = [UIColor clearColor];
    csView.delegate = self;
    csView.datasource = self;
    _tableView.tableHeaderView = csView;
}


- (NSInteger)numberOfPages
{
    return [_bannerArray count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, 320 / 2.0)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageView.frame = RECT(0, 0, 470, 470 / 2.0);
    }
    imageView.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = [_bannerArray objectAtIndex:(index%[_bannerArray count])];
    [imageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"thumb"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image == nil) {
            return ;
        }
    }];
    return imageView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    NSDictionary *dict = [_bannerArray objectAtIndex:(index%[_bannerArray count])];
    NSString *string = [dict objectForKey:@"classes"];
    if ([string isEqualToString:[FV1ViewController getTypeId]]) {
        ArticleModel *item = [[ArticleModel alloc] init];
        item.title = [dict objectForKey:@"title"];
        item.articleId = [dict objectForKey:@"link"];
        
        GetVideoUrlAndPresentViewPlayViewController *play = [[GetVideoUrlAndPresentViewPlayViewController alloc] init];
        [play getItem:item nowNumber:0 page:0 listArray:nil isLocal:YES delegate:self category:@""];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
        });
        return;
    }
    
    else if ([string isEqualToString:[FV2ViewController getTypeId]]) {
        ArticleModel *item = [[ArticleModel alloc] init];
        item.title = [dict objectForKey:@"title"];
        item.articleId = [dict objectForKey:@"link"];
        NSString *url = [NSString stringWithFormat:@"%@/flashinterface/GetPicturesDetails.ashx?picID=%@",HOST,item.articleId];
        
        ScanPictureViewController *viewController = [[ScanPictureViewController alloc] initWithUrl:url rect:CGRectZero ArticleModel:item];
        
        [self presentViewController:viewController animated:YES completion:^{
            ;
        }];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
        });
        return;
    }
    else if ([string isEqualToString:[FV3ViewController getTypeId]]) {
        ArticleModel *item = [[ArticleModel alloc] init];
        item.articleId = [dict objectForKey:@"link"];
        item.title = [dict objectForKey:@"title"];
        NSString *string = [NSString stringWithFormat:@"%@/m/detail/newsdetails.aspx?id=%@&frame=no&comment=no",appdelegate.appUrl, item.articleId];
        WebViewController *web = [[WebViewController alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
        [appdelegate.mainNavigationController pushViewController:web animated:YES];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
        });
        return;
    }
    
    else {
        SimplerWebViewController *webview = [[SimplerWebViewController alloc] initWithUrl:[dict objectForKey:@"link"] title:[dict objectForKey:@"title"]];
        [appdelegate.mainNavigationController pushViewController:webview animated:YES];
    }
    
}




- (void)getCenterViewData:(NSString *)title
{
    if (self.page == 1)
    {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
    self.navTitle = title;
    navigationView.titleLabel.text = self.navTitle;
    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *string = [NSString stringWithFormat:@"%@/flashinterface/getnewsbypage.ashx?page=%d&pagesize=10&classes=%@&sort=1",HOST,self.page,title];
    [request urlRequestWithGetUrl:string delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
}

- (void)finishMethod:(NSData *)data
{
    if (self.page == 1) {
        [_dataArray removeAllObjects];
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_dataArray];
    NSError *error;
    GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
    NSArray *employees = [pagedoc nodesForXPath:@"//article" error:NULL];
    BOOL flag = NO;

    for (GDataXMLElement *employe in employees) {
        ArticleModel *model = [[ArticleModel alloc] init];
        model.title = [[employe attributeForName:@"t"] stringValue];
        model.image = [[employe attributeForName:@"p"] stringValue];
        model.articleId = [[employe attributeForName:@"id"] stringValue];
        model.date = [[employe attributeForName:@"date"] stringValue];
        model.detail = [[employe attributeForName:@"n"] stringValue];
        model.fromUrl = [[employe attributeForName:@"fromurl"] stringValue];
        model.isRead = [ModelExChangeDictionary modelIsInUserDefaultToRead:model.articleId Typeid:[[self class] getTypeId]];
        model.field1 = [[employe attributeForName:@"field1"] stringValue];
        model.date = [[employe attributeForName:@"date"] stringValue];
        model.video_count = [[employe attributeForName:@"show"] stringValue];

        [array addObject:model];
        flag = YES;
    }
    self.dataArray = array;
    if (!flag && [_footer isRefreshing])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已经到底啦！";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    [_header endRefreshing];
    [_footer endRefreshing];
    self.page ++;
}

- (void)failMethod:(NSError *)error
{
    [_header endRefreshing];
    [_footer endRefreshing];

    MKLog(@"error :%@",error);
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}



- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, navigationView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - navigationView.frame.size.height - 49) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.frame = RECT(60, 64, 470, SCREEN_WIDTH - 64);
    }
    else {
        self.tableView.backgroundColor = [UIColor clearColor];
        
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    [self.view addSubview:self.tableView];
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    UIView *tempFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 1)];
    tempFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tempFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"newsForIphone";
    NewsiPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[NewsiPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    ArticleModel *item = [_dataArray objectAtIndex:indexPath.row];
    if (item.isRead) {
        cell.titleLabel.textColor = RGBCOLOR(183, 183, 183);
    }
    else {
        cell.titleLabel.textColor = appdelegate.h1Color;
    }
    if (item.detail.length == 0) {
        cell.titleLabel.numberOfLines = 2;
        CGRect rect = cell.titleLabel.frame;
        rect.size.height = 40;
        cell.titleLabel.frame = rect;
        cell.descriptionLabel.hidden = YES;
    }
    else {
        cell.titleLabel.numberOfLines = 1;
        CGRect rect = cell.titleLabel.frame;
        rect.size.height = 20;
        cell.titleLabel.frame = rect;
        cell.descriptionLabel.hidden = NO;
    }
    cell.titleLabel.text = item.title;
    cell.descriptionLabel.text = item.detail;
    cell.playCountLabel.text = item.video_count;
    cell.dateLabel.text = item.date;

    [cell.videoImageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:IMAGENAMED(appdelegate.placeholderName) options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image == nil) {
            return ;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *item = [_dataArray objectAtIndex:indexPath.row];
    item.isRead = YES;
    NewsiPhoneCell *cell = (NewsiPhoneCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = RGBCOLOR(183, 183, 183);
    NSString *string = [NSString stringWithFormat:@"%@/m/detail/newsdetails.aspx?id=%@&frame=no&comment=no",appdelegate.appUrl, item.articleId];
    
    if ([item.field1 isEqualToString:@"0"] || [item.field1 length] == 0) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            web = [[NewsDetailViewControllerForPad alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
            [appdelegate.tabBarController.view addSubview:web.view];
//            [appdelegate.mainNavigationController pushViewController:web animated:YES];

        }
        else {
            NewsDetailViewController *wweb = [[NewsDetailViewController alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
            [appdelegate.mainNavigationController pushViewController:wweb animated:YES];
        }
        
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            webPad = [[WebViewControllerForPad alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
            [appdelegate.tabBarController.view addSubview:webPad.view];
            //            [appdelegate.mainNavigationController pushViewController:web animated:YES];
            
        }
        else {
            WebViewController *wweb = [[WebViewController alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
            [appdelegate.mainNavigationController pushViewController:wweb animated:YES];
        }
        

    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToRead:item Typeid:[[self class] getTypeId]];
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
    });

}

#pragma mark - refresh delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) {
        self.page = 1;
        [self getCenterViewData:self.navTitle];
    }
    else {
        [self getCenterViewData:self.navTitle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
