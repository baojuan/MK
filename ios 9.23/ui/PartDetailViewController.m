//
//  PartDetailViewController.m
//  MKProject
//
//  Created by baojuan on 14-7-15.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "PartDetailViewController.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#import "GAI.h"
#import "CommentViewController.h"
#import "PartCellBottomView.h"
#import "SimplerWebViewController.h"
#import "ScanPictureForPartViewController.h"
#import "PartCellBottomButtonClickMethod.h"
#import "UIView+ReportView.h"

@interface PartDetailViewController ()<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate,MobiSageBannerDelegate,PartCellBottomButtonClickMethod>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ArticleModel *item;
@property (nonatomic, strong) NSString *changyanId;
@property (nonatomic, strong) MobiSageBanner* mobiSageBanner;
@property (nonatomic, strong) PartCellBottomView *bottomView;


@end

@implementation PartDetailViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    int page;
    MJRefreshFooterView *_footer;
    ShareView *shareView;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        _dataArray = [[NSMutableArray alloc] init];
        page = 1;
        self.screenName = @"查看段子";
    }
    return self;
}

- (id)initWithArticle:(ArticleModel *)item
{
    if (self = [super init]) {
        self.item = item;
        [self changyan:item.articleId];
        self.title = item.title;
    }
    return self;
}

- (void)backButtonClick
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentFinished" object:nil];
    self.mobiSageBanner.delegate = nil;
    self.mobiSageBanner = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBottomView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"commentBottom")];
    imageView.userInteractionEnabled = YES;
    imageView.frame = RECT(0, SCREEN_HEIGHT - 95 / 2.0, SCREEN_WIDTH, 95 / 2.0);
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(15, 13, imageView.frame.size.width - 56, 95 / 2.0 - 26)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageView.frame = RECT(0, SCREEN_WIDTH - 95 / 2.0, SCREEN_HEIGHT, 95 / 2.0);
        label.frame = RECT(50, 13, imageView.frame.size.width - 56, 95 / 2.0 - 26);
    }
    
    label.backgroundColor = [UIColor clearColor];
    label.text = @"我来说两句";
    label.textColor = RGBCOLOR(196, 196, 196);
    [imageView addSubview:label];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentButtonClick)];
    [imageView addGestureRecognizer:tap];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGENAMED(@"report_part") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reportButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = RECT(SCREEN_WIDTH - 95 / 2.0, SCREEN_HEIGHT - 95 / 2.0, 95 / 2.0, 95 / 2.0);
    [self.view addSubview:button];
}

- (void)reportButtonClick
{
    [self.view appearReportView];
}

- (void)commentButtonClick
{
    CommentViewController * comment = [[CommentViewController alloc] initWithArticle:self.item articleId:self.changyanId];
    [self presentViewController:comment animated:YES completion:^{
        ;
    }];
}

- (void)setTableHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = RECT(0, 0, view.frame.size.width, 187);
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = RGBCOLOR(232, 232, 232);

    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    UIImageView *placeholderImageView;
    placeholderImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"waitatime1")];
    placeholderImageView.frame = RECT((imageView.frame.size.width - placeholderImageView.frame.size.width) / 2.0, (imageView.frame.size.height - placeholderImageView.frame.size.height) / 2.0, placeholderImageView.frame.size.width, placeholderImageView.frame.size.height);
    [imageView addSubview:placeholderImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImagaView)];
    [imageView addGestureRecognizer:tap];
    
    __weak UIImageView *pp = placeholderImageView;
    CGFloat height = [self.item.field3 floatValue] / 320 * 320;
    imageView.frame = RECT(0, 0, view.frame.size.width, height);
    NSMutableString *imageUrl = [[NSMutableString alloc] initWithString:self.item.image];
    [imageUrl replaceOccurrencesOfString:@"app." withString:@"t1." options:NSLiteralSearch range:NSMakeRange(0, [imageUrl length])];
    if ([self.item.field1 integerValue] == 2) {
        [imageUrl appendString:@"/2000"];
    }
    else {
        [imageUrl appendString:@"/480"];
    }
    __weak UIImageView *tempImageView = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image == nil) {
            [imageUrl replaceOccurrencesOfString:@"t1." withString:@"t2." options:NSLiteralSearch range:NSMakeRange(0, [imageUrl length])];
            [tempImageView setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                pp.hidden = YES;
                if (image == nil) {
                    return ;
                }
            }];
        }
        else {
            pp.hidden = YES;
        }
    }];

    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:RECT(10, imageView.frame.size.height + imageView.frame.origin.y, view.frame.size.width - 20, 80)];
    
    contentLabel.backgroundColor = [UIColor whiteColor];
    contentLabel.font = FONTSIZE(15);
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = RGBCOLOR(91, 91, 91);
    [view addSubview:contentLabel];
    
    
    contentLabel.text = self.item.title;
    
    CGSize size = [self.item.title sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(contentLabel.frame.size.width, 500)];
    CGRect rect = contentLabel.frame;
    rect.size.height = size.height + 20;
    contentLabel.frame = rect;

    self.bottomView = [[PartCellBottomView alloc] initWithSimple:NO];
    [view addSubview:self.bottomView];
    
    self.bottomView.frame = RECT(0, contentLabel.frame.origin.y + contentLabel.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    self.bottomView.delegate = self;
    
    [self.bottomView insertIntoDataGoodNumber:self.item.goodNumber commentNumber:self.item.commentNumber isCollect:[self isCollectOrNot:self.item.articleId]];
    
    [self bannerId];
    [view addSubview:self.mobiSageBanner];

    
    view.frame = RECT(0, 0, SCREEN_WIDTH, self.mobiSageBanner.frame.size.height + self.mobiSageBanner.frame.origin.y);
    self.tableView.tableHeaderView = view;
}


- (BOOL)isCollectOrNot:(NSString *)articleId
{
    NSArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT] objectForKey:LOCAL_LANGUAGE(@"part")];
    BOOL isCollect = NO;
    for (NSDictionary *dd in arr) {
        if ([self.item.articleId isEqualToString:[dd objectForKey:@"articleId"]]) {
            isCollect = YES;
        }
    }
    return isCollect;
}
- (void)partCellBottomButtonTalkClick:(UIButton *)button
{
    
}

- (void)partCellBottomButtonGoodButtonClick:(UIButton *)button
{
    if (self.item.isgood) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"顶过了";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        [self.bottomView.goodButton setTitle:self.item.goodNumber forState:UIControlStateNormal];
        return;
    }

    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/flashinterface/AdditionalOperation.ashx?typeid=%@&operation=2&targetid=%@&value=1",HOST,[FV10ViewController getTypeId],self.item.articleId];
    [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finishGoodButtonMethod:" failMethod:@"failGoodButtonMethod:"];
}

- (void)finishGoodButtonMethod:(NSData *)data
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"顶一下成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];

    self.item.goodNumber = [NSString stringWithFormat:@"%d",[self.bottomView.goodButton.titleLabel.text intValue] + 1];
    self.item.isgood = YES;
    self.bottomView.goodButton.titleLabel.text = [NSString stringWithFormat:@"%d",[self.bottomView.goodButton.titleLabel.text intValue] + 1];
//    [self.bottomView.goodButton setTitle:item.goodNumber forState:UIControlStateNormal];
}

- (void)failGoodButtonMethod:(NSError *)error
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"顶一下失败";
    [hud hide:YES afterDelay:1];
    
}



- (void)partCellBottomButtonCollectButtonClick:(UIButton *)button
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:LOCAL_LANGUAGE(@"part")]];;
    
    NSDictionary *nowModel = [ModelExChangeDictionary modelChangeToDictionary:self.item];
    if (button.selected) {
        
        NSArray *aa = [NSArray arrayWithArray:array];
        for (NSDictionary *dd in aa) {
            if ([[dd objectForKey:@"articleId"] isEqualToString:self.item.articleId]) {
                [array removeObject:dd];
            }
        }
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"part")];
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
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"part")];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}


- (void)partCellBottomButtonShareButtonClick:(UIButton *)button
{
    self.item.link = [NSString stringWithFormat:@"%@/m/detail/partdetails.aspx?id=%@",appdelegate.appUrl,self.item.articleId];
    [shareView getArticleModel:self.item];
    
    //    if (button.selected) {
    //        [UIView beginAnimations:nil context:nil];
    //        CGRect rect = shareView.frame;
    //        rect.origin.y += rect.size.height;
    //        shareView.frame = rect;
    //        [UIView commitAnimations];
    //    }
    //    else {
    [UIView beginAnimations:nil context:nil];
    CGRect rect = shareView.frame;
    rect.origin.y -= rect.size.height;
    shareView.frame = rect;
    [UIView commitAnimations];
    
    //    }
    
}

- (void)hiddenShareButton
{
    [UIView beginAnimations:nil context:nil];
    CGRect rect = shareView.frame;
    rect.origin.y += rect.size.height;
    shareView.frame = rect;
    [UIView commitAnimations];
}



- (void)tapImagaView
{
    if ([self.item.field1 integerValue] == 10) {
        SimplerWebViewController *webview = [[SimplerWebViewController alloc] initWithUrl:self.item.field2 title:self.item.title];
        [appdelegate.mainNavigationController pushViewController:webview animated:YES];

    }
    else {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self.item.field2 componentsSeparatedByString:@"^"]];
        [array removeObject:@""];
        ScanPictureForPartViewController *controller = [[ScanPictureForPartViewController alloc] initWithArray:array title:self.item.title];
        [appdelegate.mainNavigationController pushViewController:controller animated:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    [MobClick event:[NSString stringWithFormat:@"正在查看段子%@",self.item.title]];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    
    [self setTableViewProperty];
    [self setBottomView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:IMAGENAMED(@"partclose") forState:UIControlStateNormal];
    backButton.frame = RECT(self.view.frame.size.width - 10 - 50, 10, 50, 50);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentFinished) name:@"commentFinished" object:nil];
    
    
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
    [self.view addSubview:shareView];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}


- (void)commentFinished
{
    page = 1;
    [self getCommentForPage:page];
}

- (void)setTableViewProperty
{
    self.navigationController.navigationBarHidden = YES;
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 95 / 2.0) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(0, 64, SCREEN_HEIGHT, SCREEN_WIDTH - 64 - 95 / 2.0);
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    [self.view addSubview:self.tableView];
    [self setTableHeadView];
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, 35)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view.frame = RECT(0, 0, SCREEN_HEIGHT, 35);
    }
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc] initWithFrame:RECT(0, 9, 5, view.frame.size.height - 18)];
    view1.backgroundColor = appdelegate.navigationColor;
    [view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:RECT(10, view.frame.size.height - 1, view.frame.size.width - 20, 1)];
    view2.backgroundColor = appdelegate.navigationColor;
    [view addSubview:view2];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(10, 0, view2.frame.size.width, view.frame.size.height - 2)];
    label.textColor = appdelegate.navigationColor;
    label.font = FONTSIZE(17);
    [view addSubview:label];
    //    if (section == 0) {
    //        label.text = @"热门评论";
    //    }
    //    if (section == 1) {
    label.text = @"最新评论";
    //    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
    //    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"commentCellName";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    int score = [[dict objectForKey:@"score"] integerValue];
    long long ctime = [[dict objectForKey:@"create_time"] longLongValue] / 1000;
    [cell insertIntoDataIcon:[NSURL URLWithString:[[dict objectForKey:@"passport"] objectForKey:@"img_url"]] name:[[dict objectForKey:@"passport"] objectForKey:@"nickname"] date:[self changeTime:[NSString stringWithFormat:@"%lld",ctime]] comment:[dict objectForKey:@"content"] score:score];
    cell.commentGoodNumberLabel.text = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"support_count"] intValue]];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size;
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    size = [[dict objectForKey:@"content"] sizeWithFont:FONTSIZE(15) constrainedToSize:SIZE(SCREEN_WIDTH - 20, 1000)];
    return (size.height + 60) > 110? (size.height + 60 + 10) : 110;
}


- (NSString *)changeTime:(NSString *)tt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone *gtmZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:gtmZone];
    NSDate *destDate= [NSDate dateWithTimeIntervalSince1970:[tt intValue]];
    
    NSString *nowtimeStr = [dateFormatter stringFromDate:destDate];
    return nowtimeStr;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [self commendGood:[dict objectForKey:@"comment_id"]];
}

#pragma mark - refresh delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self getCommentForPage:page];
}



#pragma mark - banner id
- (void)bannerId
{
    //创建MobiSage横幅广告
    self.mobiSageBanner = [[MobiSageBanner alloc] initWithDelegate:self
                                                            adSize:Default_size
                                                         slotToken:MS_Test_SlotToken_Banner];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_WIDTH - 320) / 2.0, self.bottomView.frame.origin.y + self.bottomView.frame.size.height, 320, 50);
    } else {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 728) / 2.0, SCREEN_WIDTH - 70 - 50 - 5, 728, 90);
    }
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




#pragma mark - changyan

#pragma mark - changyan

- (void)changyan:(NSString *)articleId;
{
    NSString *topicid = [NSString stringWithFormat:@"6_%@",articleId];
    
    [ChangyanSDK loadTopic:@"" topicTitle:@"" topicSourceID:topicid pageSize:@"0" hotSize:@"0" completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
     {
         if (statusCode != CYSuccess) {
             return ;
         }
         
         MKLog(@"%@",responseStr);
         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         self.changyanId = [[dict objectForKey:@"topic_id"] stringValue];
         [self getCommentForPage:page];
     }];
}

- (void)getCommentForPage:(int)p
{
    NSString *ss = [NSString stringWithFormat:@"%d",p];
    [ChangyanSDK getTopicComments:self.changyanId pageSize:@"20" pageNo:ss completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        [_footer endRefreshing];
        if (statusCode != CYSuccess) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"评论获取失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            return ;
            
        }
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *Array = [dict objectForKey:@"comments"];
        [_footer endRefreshing];
        if ([Array count] == 0 && page != 1)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"已经到底啦！";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            return;
        }
        [_dataArray addObjectsFromArray:Array];
        if (page == 1) {
            if ([_dataArray count] == 0) {
                [self.tableView.tableFooterView removeFromSuperview];
                self.tableView.tableFooterView = nil;
                UILabel *label = [[UILabel alloc] initWithFrame:RECT(0, 30, self.tableView.frame.size.width, 80)];
                label.backgroundColor = [UIColor whiteColor];
                label.textColor = RGBCOLOR(80, 80, 80);
                label.font = FONTSIZE(19);
                label.text = LOCAL_LANGUAGE(@"no comment");
                label.textAlignment = NSTextAlignmentCenter;
                self.tableView.tableFooterView = label;
            }
            else {
                [self.tableView.tableFooterView removeFromSuperview];
                self.tableView.tableFooterView = nil;
                UIView *tempFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 1)];
                tempFooterView.backgroundColor = [UIColor whiteColor];
                self.tableView.tableFooterView = tempFooterView;
                
            }
        }
        page ++;
        [self.tableView reloadData];
    }];
}


- (void)commendGood:(NSString *)commentId
{
    [ChangyanSDK commentAction:1 topicID:self.changyanId commentID:commentId completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode != CYSuccess) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"顶一下失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            return ;
            
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"顶一下成功";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            return ;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
