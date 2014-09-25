//
//  NewsDetailViewControllerForPad.m
//  MKProject
//
//  Created by baojuan on 14-8-30.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "NewsDetailViewControllerForPad.h"
#import "WebViewToolBar.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "WebViewToolBarForPad.h"
#import "CommentViewControllerForPad.h"
#import "CommentListViewControllerForPad.h"
#import "GAI.h"
#import "GDataXMLNode.h"
#import "NewsDetailCell.h"
#import "ScanPictureForNewsDetailViewController.h"
#import "UIView+ReportView.h"

@interface NewsDetailViewControllerForPad ()<UITableViewDataSource,UITableViewDelegate,MobiSageBannerDelegate,NewsDetailCellDelegate>
@property (nonatomic, strong) NSString *changyanId;
@property (nonatomic, strong) MobiSageBanner* mobiSageBanner;
@property (nonatomic, assign) BOOL fromUrl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageShowArray;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;



@end

@implementation NewsDetailViewControllerForPad
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    WebViewToolBar *toolBar;
    WebViewToolBarForPad *toolBarForPad;
    ArticleModel *item;
    
    ShareView *shareView;
    
    
    CommentListViewControllerForPad *controller;
    CommentViewControllerForPad *commentView;
    UIView *footView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        self.screenName = @"新闻页";
    }
    return self;
}

- (id)initWithUrl:(NSString *)url articleId:(NSString *)articleId title:(NSString *)title ArticleModel:(ArticleModel *)model
{
    return [self initWithUrl:url articleId:articleId title:title ArticleModel:model fromUrl:NO];
}

- (id)initWithUrl:(NSString *)url articleId:(NSString *)articleId title:(NSString *)title ArticleModel:(ArticleModel *)model fromUrl:(BOOL)fromUrl
{
    if (self = [super init]) {
        self.url = url;
        self.articleId = articleId;
        self.navTitle = title;
        item = model;
        self.fromUrl = fromUrl;
        self.dataArray = [[NSMutableArray alloc] init];
        self.imageShowArray = [[NSMutableArray alloc] init];
        [self changyan];
        
        

//        [self viewDidLoad];
        self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        self.view.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

- (void)getDataArray
{
    NSString *string = [NSString stringWithFormat:@"%@/flashinterface/getnewsdetailsnew.ashx?id=%@",HOST,self.articleId];
    UrlRequest *request = [[UrlRequest alloc] init];
    [request urlRequestWithGetUrl:string delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
}

- (void)finishMethod:(NSData *)data
{
    NSMutableString *string = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [string replaceOccurrencesOfString:@"</root>]]><" withString:@"</root><" options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"><![CDATA[<root>" withString:@"><root>" options:0 range:NSMakeRange(0, [string length])];
    NSData *rightData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",[[NSString alloc] initWithData:rightData encoding:NSUTF8StringEncoding]);
    GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:rightData options:0 error:nil];
    
    NSArray *articelEmployees = [pagedoc nodesForXPath:@"//article" error:NULL];
    for (GDataXMLElement *ele in articelEmployees) {
        self.title = [[ele attributeForName:@"t"] stringValue];
        self.date = [[ele attributeForName:@"date"] stringValue];
    }
    
    NSArray *employees = [pagedoc nodesForXPath:@"//p" error:NULL];
    if ([employees count] == 0) {
        return;
    }
    float lines = 0;
    for (GDataXMLElement *employe in employees) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dict setObject:[[employe attributeForName:@"classe"] stringValue] forKey:@"classe"];
        [dict setObject:[[employe attributeForName:@"src"] stringValue] forKey:@"src"];
        NSMutableString *string = [NSMutableString stringWithString:[employe stringValue]];
        [string replaceOccurrencesOfString:@"\n\n\n" withString:@"" options:0 range:NSMakeRange(0, [string length])];
        //        [string replaceOccurrencesOfString:@"\n\n" withString:@"" options:0 range:NSMakeRange(0, [string length])];
        [dict setObject:string forKey:@"title"];
        [dict setObject:[NSNumber numberWithFloat:lines] forKey:@"indexof"];
        lines ++;
        if ([[dict objectForKey:@"classe"] isEqualToString:@"p"]) {
            [dict setObject:[NSNumber numberWithFloat:0] forKey:@"textHeight"];
            [dict setObject:[NSNumber numberWithFloat:165] forKey:@"imageHeight"];

        }
        else {
            CGSize size = [[dict objectForKey:@"title"] sizeWithFont:FONTSIZE(14) constrainedToSize:SIZE(self.tableView.frame.size.width - 20, 10000)];
            [dict setObject:[NSNumber numberWithFloat:size.height] forKey:@"textHeight"];
            [dict setObject:[NSNumber numberWithFloat:0] forKey:@"imageHeight"];

        }
        
        
        [dict setObject:[NSNumber numberWithFloat:0] forKey:@"runBOOL"];
        
        
        [self.dataArray addObject:dict];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int a = 0;
        for (int i = 0; i < [_dataArray count]; i ++) {
            __weak NSMutableDictionary *dict = [self.dataArray objectAtIndex:i];
            if ([[dict objectForKey:@"classe"] isEqualToString:@"p"]) {
                [dict setObject:[NSString stringWithFormat:@"%d",a] forKey:@"index"];
                [self.imageShowArray addObject:[dict objectForKey:@"src"]];
                a++;
            }
        }
    });
    self.tableView.tableHeaderView = [self tableViewHeadView];
    [self.tableView reloadData];
}

- (void)failMethod:(NSError *)error
{
    
}

- (BOOL)isCollectOrNot:(NSString *)articleId
{
    NSArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT] objectForKey:LOCAL_LANGUAGE(@"news")];
    BOOL isCollect = NO;
    for (NSDictionary *dd in arr) {
        if ([item.articleId isEqualToString:[dd objectForKey:@"articleId"]]) {
            isCollect = YES;
        }
    }
    
    return isCollect;
}

- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        return;
//    }
    BOOL iscollect = [self isCollectOrNot:self.articleId];
    navigationView = [[MKNavigationView alloc] initWithTitle:self.navTitle rightButtonImage:IMAGENAMED(@"articleCollect") ForPad:YES ForPadFullScreen:NO];
    navigationView.frame = RECT(475 + 60, 0, navigationView.frame.size.width, navigationView.frame.size.height);
    [navigationView.rightButton setImage:IMAGENAMED(@"articleCollectSelect") forState:UIControlStateSelected];
    [navigationView.rightButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    navigationView.rightButton.selected = iscollect;
    [self.view addSubview:navigationView];
    
}

- (void)backButtonClick
{
    self.mobiSageBanner.delegate = nil;
    self.mobiSageBanner = nil;
    [self.view removeFromSuperview];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionButtonClick:(UIButton *)button
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:LOCAL_LANGUAGE(@"news")]];;
    
    NSDictionary *nowModel = [ModelExChangeDictionary modelChangeToDictionary:item];
    if (button.selected) {
        
        NSArray *aa = [NSArray arrayWithArray:array];
        for (NSDictionary *dd in aa) {
            if ([[dd objectForKey:@"articleId"] isEqualToString:item.articleId]) {
                [array removeObject:dd];
            }
        }
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"news")];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"取消收藏";
        [hud hide:YES afterDelay:1];
    }
    else {
        [array addObject:nowModel];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"收藏成功";
        [hud hide:YES afterDelay:1];
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"news")];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    button.selected = !button.selected;
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self backButtonClick];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.2;
    view.userInteractionEnabled = NO;
    [self.view addSubview:view];

    
    
    UIView *backgroundview = [[UIView alloc] initWithFrame:RECT(475 + 60, 0, 470, SCREEN_WIDTH)];
    backgroundview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundview];
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGes];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    [self.view addGestureRecognizer:tap];
    
    
    
    [MobClick event:[NSString stringWithFormat:@"正在访问页面%@",self.url]];
        self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setScrollViewProperty];
    [self getDataArray];
    [self setBottomView];
//    [self bannerId];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        shareView = [[ShareView alloc] initForHorizontal:YES];
    }
    else {
        shareView = [[ShareView alloc] initForHorizontal:NO];
    }
    shareView.delegate = self;
    CGRect rect = shareView.frame;
    rect.origin.y += rect.size.height;
    shareView.frame = rect;
    item.link = [NSString stringWithFormat:@"%@/m/detail/newsdetails.aspx?id=%@",appdelegate.appUrl,item.articleId];
    [shareView getArticleModel:item];
    [self.view addSubview:shareView];
}

- (void)footView
{
    footView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 80)];
    footView.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(0, 0, footView.frame.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"(本文来自互联网，不代表我们的观点和立场)";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONTSIZE(13);
    label.textColor = RGBCOLOR(153, 153, 153);
    if (self.fromUrl) {
        CGRect rect = footView.frame;
        rect.size.height += 50;
        footView.frame = rect;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = RGBCOLOR(219, 219, 219);
        [button setTitle:@"查看原文" forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(117, 117, 117) forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE(14);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.frame = RECT(15, footView.frame.size.height - 10 - 30, 320 - 30, 30);
        [button addTarget:self action:@selector(originalButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
    }
    [footView addSubview:label];
}

- (void)originalButtonClick
{
    
}

- (void)setScrollViewProperty
{
    
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, 470, SCREEN_WIDTH)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    [view addGestureRecognizer:tap];
    
    self.tableView = [[UITableView alloc] initWithFrame:RECT(480, navigationView.frame.size.height, 470, SCREEN_HEIGHT - navigationView.frame.size.height - 35 - 50)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(475 + 60, navigationView.frame.size.height, 470, SCREEN_WIDTH - navigationView.frame.size.height - 35);
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (UIView *)tableViewHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 140)];
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(10, 10, view.frame.size.width - 20, 10)];
    label.numberOfLines = 2;
    label.text = self.title;
    label.font = FONTSIZE(18);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 500)];
    
    CGRect labelFrame;
    labelFrame = label.frame;
    labelFrame.size = size;
    label.frame = labelFrame;
    
    [view addSubview:label];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:RECT(10, label.frame.size.height + label.frame.origin.y, view.frame.size.width - 20, 20)];
    dateLabel.textColor = RGBCOLOR(205, 205, 205);
    dateLabel.font = FONTSIZE(12);
    dateLabel.text = self.date;
    [view addSubview:dateLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:RECT(10, dateLabel.frame.size.height + dateLabel.frame.origin.y+2, view.frame.size.width-20, 1)];
    line.backgroundColor = RGBCOLOR(205, 205, 205);
    [view addSubview:line];
    
    
    CGRect viewFrame = view.frame;
    viewFrame.size.height = line.frame.size.height + line.frame.origin.y;
    view.frame = viewFrame;
    
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (void)refreshCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView reloadData];
    //
    //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"newsDetailCellName";
    NewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    //NewsDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[NewsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.delegate = self;
        
        
    }
    
    
    
    
    if ([[dict objectForKey:@"runBOOL"] floatValue]==0) {
        
        [cell insertIntoData:[_dataArray objectAtIndex:indexPath.row] complete:^{
            cell.detailImageView.tag = indexPath.row + 100;
            
            /*
             UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
             [cell.detailImageView addGestureRecognizer:tap];
             */
        }];
    }else{
        /**/
        [cell insertIntoDataComplete:[_dataArray objectAtIndex:indexPath.row] complete:^{
            cell.detailImageView.tag = indexPath.row + 100;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
            [cell.detailImageView addGestureRecognizer:tap];
        }];
        
        
        //insertIntoDataComplete
    }
    
    
    
    
    return cell;
}

- (void)tapGes:(UIGestureRecognizer *)ges
{
    NSDictionary *dict = [_dataArray objectAtIndex:(ges.view.tag - 100)];
    ScanPictureForNewsDetailViewController *cc = [[ScanPictureForNewsDetailViewController alloc] initWithArray:self.imageShowArray title:nil Index:[[dict objectForKey:@"index"] integerValue]];
    [appdelegate.mainNavigationController pushViewController:cc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    //    if ([dict objectForKey:@"cellHeight"]) {
    //        return [[dict objectForKey:@"cellHeight"] floatValue];
    //    }
    //    else {
    //        NewsDetailCell *cell = (NewsDetailCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    //        CGFloat height = cell.detailLabel.frame.size.height + cell.detailLabel.frame.origin.y;
    //        [dict setObject:[NSNumber numberWithFloat:height] forKey:@"cellHeight"];
    //        return height;
    //    }
    if ([[dict objectForKey:@"classe"] isEqualToString:@"p"]) {
        
        return [[dict objectForKey:@"imageHeight"] floatValue];
        //return 230;
        
    }
    else {
        return [[dict objectForKey:@"textHeight"] floatValue] + [[dict objectForKey:@"imageHeight"] floatValue] + 17;
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((NewsDetailCell *)cell).detailLabel.text = @"";
    ((NewsDetailCell *)cell).detailImageView.image = IMAGENAMED(@"placeholderForNews");
    
}

#pragma mark - banner id
- (void)bannerId
{
    //创建MobiSage横幅广告
    self.mobiSageBanner = [[MobiSageBanner alloc] initWithDelegate:self
                                                            adSize:Default_size
                                                         slotToken:MS_Test_SlotToken_Banner];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_WIDTH - 320) / 2.0, SCREEN_HEIGHT - 70 - 10 - 5, 320, 50);
    } else {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 728) / 2.0, SCREEN_WIDTH - 70 - 50 - 5, 728, 90);
    }
    [self.view addSubview:self.mobiSageBanner];
}



//横幅广告被点击时,触发此回调方法,用于统计广告点击数
- (void)mobiSageBannerClick:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerClick");
}

//横幅广告成功展示时,触发此回调方法,用于统计广告展示数
- (void)mobiSageBannerSuccessToShowAd:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerSuccessToShowAd");
}

//横幅广告展示失败时,触发此回调方法
- (void)mobiSageBannerFaildToShowAd:(MobiSageBanner*)adBanner withError:(NSError *)error
{
    NSLog(@"mobiSageBannerFaildToShowAd, error = %@", [error description]);
}

//横幅广告点击后,打开 LandingSite 时,触发此回调方法,请勿释放横幅广告
- (void)mobiSageBannerPopADWindow:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerPopADWindow");
}

//关闭 LandingSite 回到应用界面时,触发此回调方法
- (void)mobiSageBannerHideADWindow:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerHideADWindow");
}



- (void)setBottomView
{
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        toolBarForPad = [[WebViewToolBarForPad alloc] initWithState:YES delegate:self];
//        toolBarForPad.backButton.hidden = YES;
//        toolBarForPad.forwardButton.hidden = YES;
//        [self.view addSubview:toolBarForPad];
//    }
//    else {
        toolBar = [[WebViewToolBar alloc] initWithState:YES delegate:self];
        toolBar.backButton.hidden = YES;
        toolBar.forwardButton.hidden = YES;
        [self.view addSubview:toolBar];
//    }
    [self getCommentNumber];
}

- (void)webBackButtonClick
{
    //    [webView goBack];
}

- (void)webForwardButtonClick
{
    //    [webView goForward];
}

- (void)webRefreshButtonClick
{
    //    [webView reload];
    
    [self.view appearReportView];
    
}

- (void)webEditButtonClick
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        commentView = [[CommentViewControllerForPad alloc] initWithArticle:item articleId:self.changyanId];
        [self.view addSubview:commentView.view];
        return;
    }
    
    CommentViewController *comment = [[CommentViewController alloc] initWithArticle:item articleId:self.changyanId];
    [self presentViewController:comment animated:YES completion:^{
    }];
}

- (void)webTalkButtonClick
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controller = [[CommentListViewControllerForPad alloc] initWithArticle:item articleId:self.changyanId];
        [self.view addSubview:controller.view];
        return;
    }
    
    CommentListViewController *comment = [[CommentListViewController alloc] initWithArticle:item articleId:self.changyanId];
    [self presentViewController:comment animated:YES completion:^{
    }];
}

- (void)webShareButtonClick:(UIButton *)button
{
    if (button.selected) {
        [UIView beginAnimations:nil context:nil];
        CGRect rect = shareView.frame;
        rect.origin.y += rect.size.height;
        shareView.frame = rect;
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:nil context:nil];
        CGRect rect = shareView.frame;
        rect.origin.y -= rect.size.height;
        shareView.frame = rect;
        [UIView commitAnimations];
        
    }
    
    button.selected = !button.selected;
    
}

- (void)hiddenShareButton
{
    if (toolBar.shareButton.selected) {
        [self webShareButtonClick:toolBar.shareButton];
    }
    if (toolBarForPad.shareButton.selected) {
        [self webShareButtonClick:toolBarForPad.shareButton];
    }
    
}

#pragma mark - changyan

- (void)changyan
{
    NSString *topicid = [NSString stringWithFormat:@"1_%@",item.articleId];
    
    [ChangyanSDK loadTopic:@"" topicTitle:@"" topicSourceID:topicid pageSize:@"0" hotSize:@"0" completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
     {
         if (statusCode != CYSuccess) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             hud.removeFromSuperViewOnHide = YES;
             [hud hide:YES afterDelay:1];
             return ;
         }
         
         MKLog(@"%@",responseStr);
         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         self.changyanId = [[dict objectForKey:@"topic_id"] stringValue];
         
     }];
}


- (void)getCommentNumber
{
    [ChangyanSDK getCommentCountTopicUrl:nil topicSourceID:nil topicID:self.changyanId completeBlock:^(CYStatusCode statusCode,NSString *responseStr)
     {
         if (statusCode != CYSuccess) {
             return ;
         }
         
         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         toolBar.talkLabel.text = [[[[dict objectForKey:@"result"] objectForKey:self.changyanId] objectForKey:@"comments"] stringValue];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
