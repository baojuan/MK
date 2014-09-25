//
//  ScanPictureViewController.m
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ScanPictureViewController.h"
#import "GDataXMLNode.h"
#import "MKNavigationView.h"
#import "PictureToolBar.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "PictureToolBarForPad.h"
#import "CommentViewControllerForPad.h"
#import "CommentListViewControllerForPad.h"


@interface ScanPictureViewController ()<MobiSageBannerDelegate>
@property(nonatomic, strong) MobiSageBanner* mobiSageBanner;

@end

@implementation ScanPictureViewController
{
    AppDelegate *appdelegate;
    BOOL getDataComplete;
    ArticleModel *item;
    PictureToolBar *toolBar;
    NSMutableArray *imageViewArray;
    PictureToolBarForPad *toolBarForPad;
    UILabel *titleViewForPad;
    ShareView *shareView;
    
    CommentListViewControllerForPad *controller;
    CommentViewControllerForPad *commentView;
    UIImageView *nowImageView;
    UIScrollView *nowScrollView;

    NSMutableArray *scrollViewArray;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.screenName = @"查看图片";
        
    }
    return self;
}

- (id)initWithUrl:(NSString *)string rect:(CGRect)rect ArticleModel:(ArticleModel *)model
{
    if (self = [super init]) {
        item = model;
        //        self.frame = rect;
        imageViewArray = [[NSMutableArray alloc] init];
        scrollViewArray = [[NSMutableArray alloc] init];
        appdelegate = APPDELEGATE;
        self.url = string;
        self.dataArray = [[NSMutableArray alloc] init];
        [self getData];
        self.view.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
        [self changyan];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"查看图片"
                                            action:@"正在查看图片"
                                             label:[NSString stringWithFormat:@"正在查看图片%@",self.title]
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
    
    [MobClick event:[NSString stringWithFormat:@"正在查看图片%@",self.title]];
    
}


- (void)getData
{
    UrlRequest *request = [[UrlRequest alloc] init];
    [request urlRequestWithGetUrl:self.url delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
}

- (void)finishMethod:(NSData *)data
{
    GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:Nil];
    
    NSArray *employees = [pagedoc nodesForXPath:@"//article" error:NULL];
    
    for (GDataXMLElement *employe in employees) {
        NSString *String = [[employe attributeForName:@"p"] stringValue];
        [self.dataArray addObject:String];
    }
    getDataComplete = YES;
    [self setScrollViewProperty];
}
- (void)failMethod:(NSError *)error
{
    [self setScrollViewProperty];
    
    MKLog(@"error:%@",error);
}


- (void)tap
{
    
    [self hiddenShareButton];
    self.mobiSageBanner.hidden = !self.mobiSageBanner.hidden;
    _navigationView.hidden = !_navigationView.hidden;
    toolBar.hidden = !toolBar.hidden;
    toolBarForPad.hidden = !toolBarForPad.hidden;
    titleViewForPad.hidden = !titleViewForPad.hidden;
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
}



- (void)setHeadView
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    BOOL iscollect = [self isCollectOrNot:item.articleId];
    
    
    _navigationView = [[MKNavigationView alloc] initWithTitle:item.title rightButtonImage:IMAGENAMED(@"articleCollect") ForPad:NO ForPadFullScreen:YES];
    [_navigationView.rightButton setImage:IMAGENAMED(@"articleCollectSelect") forState:UIControlStateSelected];
    _navigationView.rightButton.selected = iscollect;
    [_navigationView.rightButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationView];
    
}


- (BOOL)isCollectOrNot:(NSString *)articleId
{
    NSArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT] objectForKey:LOCAL_LANGUAGE(@"picture")];
    BOOL isCollect = NO;
    for (NSDictionary *dd in arr) {
        if ([item.articleId isEqualToString:[dd objectForKey:@"articleId"]]) {
            isCollect = YES;
        }
    }
    return isCollect;
}


- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        [shareView removeFromSuperview];
        shareView = nil;;
    }];
}






- (void)collectionButtonClick:(UIButton *)button
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:LOCAL_LANGUAGE(@"picture")]];;
    
    NSDictionary *nowModel = [ModelExChangeDictionary modelChangeToDictionary:item];
    if (button.selected) {
        
        NSArray *aa = [NSArray arrayWithArray:array];
        for (NSDictionary *dd in aa) {
            if ([[dd objectForKey:@"articleId"] isEqualToString:item.articleId]) {
                [array removeObject:dd];
            }
        }
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"picture")];
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
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"picture")];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    button.selected = !button.selected;
}



#pragma mark - banner id
- (void)bannerId
{
    //创建MobiSage横幅广告
    self.mobiSageBanner = [[MobiSageBanner alloc] initWithDelegate:self
                                                            adSize:Default_size
                                                         slotToken:MS_Test_SlotToken_Banner];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_WIDTH - 320) / 2.0, SCREEN_HEIGHT - 35 - 50, 320, 50);
    } else {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 728) / 2.0, 20, 728, 90);
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







- (void)setScrollViewProperty
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.tag = 100;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.scrollView.frame = RECT(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = SIZE(self.scrollView.frame.size.width * [_dataArray count], self.scrollView.frame.size.height);
    for (int i = 0; i < [_dataArray count]; i ++) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:RECT(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        scroll.tag = 1000 + i;
        scroll.maximumZoomScale = 2.0f                            ;
        scroll.minimumZoomScale = 1.0f;
        scroll.delegate = self;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:RECT((scroll.frame.size.width - 361 / 2.0) / 2.0, (scroll.frame.size.height - 344 / 2.0) / 2.0, 361 / 2.0, 344 / 2.0)];
        imageView.image = IMAGENAMED(@"picloadwait");
        [imageViewArray addObject:imageView];
        [scroll addSubview:imageView];
        [scrollViewArray addObject:scroll];
        [self.scrollView addSubview:scroll];
        if (i == 0) {
            nowImageView = imageView;
        }
    }
    [self.view addSubview:self.scrollView];
    [self setHeadView];
    [self setBottomView];
    [self bannerId];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getImages];
    });
}


- (void)getImages
{
    for (int i = 0; i < [_dataArray count]; i ++) {
        
        NSString *string = [_dataArray objectAtIndex:i];
        __weak UIScrollView *scrollView = [scrollViewArray objectAtIndex:i];
        __weak UIImageView *imageView = [imageViewArray objectAtIndex:i];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        [imageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:IMAGENAMED(@"picloadwait") options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image == nil) {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    imageView.image = IMAGENAMED(@"noimageipa");
                    imageView.frame = RECT(0,0,1024,768);
                }else{
                    imageView.image = IMAGENAMED(@"noimage");
                    imageView.frame = RECT(0,0,320,161);
                }
                return ;
            }
            CGFloat space = 10;
            CGFloat scaleNumber;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                scaleNumber = ((image.size.width * 1.0 / SCREEN_HEIGHT) >= (image.size.height * 1.0 / SCREEN_WIDTH)) ? (SCREEN_HEIGHT - space) * 1.0 / image.size.width : SCREEN_WIDTH * 1.0 / image.size.height;
            }
            else {
                scaleNumber = ((image.size.width * 1.0 / SCREEN_WIDTH) >= (image.size.height * 1.0 / SCREEN_HEIGHT)) ? (SCREEN_WIDTH - space) * 1.0 / image.size.width : SCREEN_HEIGHT * 1.0 / image.size.height;
            }
            imageView.frame = RECT(space / 2.0 + (self.scrollView.frame.size.width - space - image.size.width * scaleNumber) / 2.0, (self.scrollView.frame.size.height - image.size.height * scaleNumber) / 2.0, image.size.width * scaleNumber, image.size.height * scaleNumber);
        }];
    }
}


- (void)setBottomView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        titleViewForPad = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - 35 - 227 / 2.0, SCREEN_HEIGHT, 227 / 2.0)];
        titleViewForPad.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(@"pictureTitleBackgroundImageForPad")];
        titleViewForPad.textAlignment = NSTextAlignmentCenter;
        titleViewForPad.numberOfLines = 2;
        titleViewForPad.textColor = [UIColor whiteColor];
        titleViewForPad.font = FONTBOLDSIZE(24);
        titleViewForPad.text = item.title;
        [self.view addSubview:titleViewForPad];
        
        toolBarForPad = [[PictureToolBarForPad alloc] initWithState:NO delegate:self];
        
        toolBarForPad.centerLabel.text = [NSString stringWithFormat:@"1/%d",[self.dataArray count]];
        [self.view addSubview:toolBarForPad];
    }
    else {
        toolBar = [[PictureToolBar alloc] initWithState:NO delegate:self];
        
        toolBar.centerLabel.text = [NSString stringWithFormat:@"1/%d",[self.dataArray count]];
        [self.view addSubview:toolBar];
    }
    
    [self getCommentNumber];
    
    
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
    item.link = [NSString stringWithFormat:@"%@/m/detail/picturesdetails.aspx?id=%@",appdelegate.appUrl,item.articleId];
    [shareView getArticleModel:item];
    [self.view addSubview:shareView];
    
}

- (void)hiddenShareButton
{
    if (toolBarForPad.shareButton.selected) {
        [self shareButtonClick:toolBarForPad.shareButton];
    }
    if (toolBar.shareButton.selected) {
        [self shareButtonClick:toolBar.shareButton];
    }
}


- (void)shareButtonClick:(UIButton *)button
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

- (void)talkButtonClick:(UIButton *)button
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

- (void)editButtonClick:(UIButton *)button
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        commentView = [[CommentViewControllerForPad alloc] initWithArticle:item articleId:self.changyanId];
        [self.view addSubview:commentView.view];
        return;
    }
    
    
    CommentViewController * comment = [[CommentViewController alloc] initWithArticle:item articleId:self.changyanId];
    [self presentViewController:comment animated:YES completion:^{
        ;
    }];
    
}

- (void)downloadButtonClick:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在保存";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    int a = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    __weak UIImageView *imageView = [imageViewArray objectAtIndex:a];
    
    UIImage *Image = [[UIImage alloc]initWithData:UIImagePNGRepresentation(imageView.image)];
    UIImageWriteToSavedPhotosAlbum(Image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    NSString *msg = nil;
    
    if(error != NULL) {
        msg = @"保存图片失败";
        NSMutableDictionary *event =
        [[GAIDictionaryBuilder createEventWithCategory:@"报错"
                                                action:@"保存图片失败"
                                                 label:[NSString stringWithFormat:@"保存图片失败%@",self.title]
                                                 value:nil] build];
        [[GAI sharedInstance].defaultTracker send:event];
        [[GAI sharedInstance] dispatch];
        [MobClick event:[NSString stringWithFormat:@"保存图片失败%@",self.title]];
        
        
    }
    else {
        msg = @"保存图片成功";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) {
        nowScrollView.zoomScale = 1.0;
        int number = (scrollView.contentOffset.x / scrollView.frame.size.width);
        nowImageView = [imageViewArray objectAtIndex:number];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            toolBarForPad.centerLabel.text = [NSString stringWithFormat:@"%d/%d",number + 1, [self.dataArray count]];
        }
        else {
            toolBar.centerLabel.text = [NSString stringWithFormat:@"%d/%d",number + 1, [self.dataArray count]];

        }

    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    if (scrollView.tag >= 1000) {
        
        //NSLog(@"scrollViewDidEndZooming");
        CGFloat zs = scrollView.zoomScale;
        zs = MAX(zs, 1.0);                // 捏合最小
        zs = MIN(zs, 2.0);                // 捏合最大
        
        scrollView.zoomScale = zs;
    }
    
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    //NSLog(@"viewForZoomingInScrollView");
    if (scrollView.tag >= 1000) {
        nowScrollView = scrollView;
        return nowImageView;
    }
    return nil;
}


#pragma mark - changyan

- (void)changyan
{
    NSString *topicid = [NSString stringWithFormat:@"2_%@",item.articleId];
    
    [ChangyanSDK loadTopic:@"" topicTitle:@"" topicSourceID:topicid pageSize:@"0" hotSize:@"0" completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
     {
         if (statusCode != CYSuccess) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    [ChangyanSDK getCommentCountTopicUrl:@"" topicSourceID:@"" topicID:self.changyanId completeBlock:^(CYStatusCode statusCode,NSString *responseStr)
     {
         if (statusCode != CYSuccess) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             hud.removeFromSuperViewOnHide = YES;
             [hud hide:YES afterDelay:1];
             return ;
             
         }
         
         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         toolBar.talkLabel.text = [[[[dict objectForKey:@"result"] objectForKey:self.changyanId] objectForKey:@"comments"] stringValue];
     }];
}





- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [[UIApplication sharedApplication] statusBarOrientation];
    }
    else {
        return UIInterfaceOrientationPortrait;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
