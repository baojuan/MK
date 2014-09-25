//
//  WebViewControllerForPad.m
//  MKProject
//
//  Created by baojuan on 14-8-30.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "WebViewControllerForPad.h"
#import "WebViewToolBar.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "WebViewToolBarForPad.h"
#import "CommentViewControllerForPad.h"
#import "CommentListViewControllerForPad.h"
#import "GAI.h"

@interface WebViewControllerForPad ()<UIWebViewDelegate,MobiSageBannerDelegate>
@property (nonatomic, strong) NSString *changyanId;
@property (nonatomic, strong) MobiSageBanner* mobiSageBanner;
@property (nonatomic, assign) BOOL fromUrl;


@end

@implementation WebViewControllerForPad
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    UIWebView *webView;
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
        [self changyan];
        self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
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
    [self.view removeFromSuperview];
    self.mobiSageBanner.delegate = nil;
    self.mobiSageBanner = nil;
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
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [backgroundview addGestureRecognizer:swipeGes];

    
    
    
    [MobClick event:[NSString stringWithFormat:@"正在访问页面%@",self.url]];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setWebViewProperty];
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
    footView = [[UIView alloc] initWithFrame:RECT(0, 0, webView.frame.size.width, 80)];
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

- (void)setWebViewProperty
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, 470, SCREEN_WIDTH)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    [view addGestureRecognizer:tap];
    
    webView = [[UIWebView alloc] initWithFrame:RECT(475 + 60, navigationView.frame.size.height, SCREEN_WIDTH - 475 - 60, SCREEN_HEIGHT - navigationView.frame.size.height - 35 - 50)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        webView.frame = RECT(475 + 60, navigationView.frame.size.height, 470, SCREEN_WIDTH - navigationView.frame.size.height - 35);
    }
    webView.backgroundColor = [UIColor clearColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    webView.delegate = self;
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [self footView];
    //
    //    CGRect rect = footView.frame;
    //    CGFloat contentHeight = webView.scrollView.contentSize.height;
    //    // 表格的高度
    //    CGFloat scrollHeight = webView.scrollView.frame.size.height;
    //    CGFloat y = MAX(contentHeight, scrollHeight);
    //    rect.origin.y = y;
    //    footView.frame = rect;
    //    CGSize size = webView.scrollView.contentSize;
    //    size.height += footView.frame.size.height;
    //    webView.scrollView.contentSize = size;
    //
    //    [webView.scrollView addSubview:footView];
    
}

#pragma mark - banner id
- (void)bannerId
{
    //创建MobiSage横幅广告
    self.mobiSageBanner = [[MobiSageBanner alloc] initWithDelegate:self
                                                            adSize:Default_size
                                                         slotToken:MS_Test_SlotToken_Banner];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_WIDTH - 320) / 2.0, SCREEN_HEIGHT - 70 - 10 + 2, 320, 50);
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
//        toolBarForPad = [[WebViewToolBarForPad alloc] initWithState:NO delegate:self];
//        [self.view addSubview:toolBarForPad];
//    }
//    else {
        toolBar = [[WebViewToolBar alloc] initWithState:YES delegate:self];
        [self.view addSubview:toolBar];
//    }
    [self getCommentNumber];
}

- (void)webBackButtonClick
{
    [webView goBack];
}

- (void)webForwardButtonClick
{
    [webView goForward];
}

- (void)webRefreshButtonClick
{
    [webView reload];
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
             //             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
             //             hud.mode = MBProgressHUDModeText;
             //             hud.labelText = @"评论数获取失败";
             //             hud.removeFromSuperViewOnHide = YES;
             //             [hud hide:YES afterDelay:1];
             return ;
         }
         
         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         toolBar.talkLabel.text = [[[[dict objectForKey:@"result"] objectForKey:self.changyanId] objectForKey:@"comments"] stringValue];
     }];
}


@end
