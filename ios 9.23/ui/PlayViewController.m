//
//  PlayViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-28.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//




#import "PlayViewController.h"
#import "PlayManager.h"
#import "NGVolumeControl.h"
#import "MJRefresh.h"
#import "VideoDefinitionChooseButton.h"
#import "M3U8Manager.h"
#import "DownloadFinishedManager.h"
#import "GDataXMLNode.h"
#import "CommentListViewController.h"
#import "CommentListViewControllerForPad.h"
#import "GAI.h"
#import "CachingView.h"
#import "VolumnView.h"


#define SCALE SCREEN_WIDTH / 320.0


@interface PlayViewController () <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate,MobiSageFloatWindowDelegate,MobiSageBannerDelegate>
@property (nonatomic, weak) CyberPlayerController *cbPlayerController;
@property (nonatomic, strong) NSMutableArray *dataArray; //listarray
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *videoUrlArray;
@property (nonatomic, strong) ArticleModel *item;
@property (nonatomic, assign) NSInteger nowNumber;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *changyanId;

@property(nonatomic, strong) MobiSageFloatWindow *floatWindow;
@property(nonatomic, strong) MobiSageBanner* mobiSageBanner;

@end



@implementation PlayViewController
{
    
    AppDelegate *appdelegate;

    NSTimer *_timer;
    BOOL timerPause;
    
    //headView
    UIImageView *headBackgroundView;
    UIButton *downloadButton;
    UIButton *commentButton;
    UIButton *shareButton;
    UIButton *collectButton;
    UIButton *listButton;
    UILabel *titleLabel;
    
    
    //bottomView
    UIImageView *bottomBackgroundView;
    UIButton *backButton;
    UILabel *currentTime;
    UILabel *totalTime;
    UISlider *slider;
    
    //playView
    UIImageView *playBackgroundView;
    UIButton *beforeButton;
    UIButton *nextButton;
    NGVolumeControl *volumeController;
    VideoDefinitionChooseButton *videoDefinitionButton;
    UIButton *reportButton;
    
    //volumnView
    VolumnView *volumnView;
    
    CachingView *cacheView;
    
    MJRefreshFooterView *_footer;

    
    ShareView *shareView;
    
    
    CGFloat scale;
    
    
    CommentListViewControllerForPad *controller;
    BOOL isFirst;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        self.screenName = @"播放视频";

    }
    return self;
}

- (id)initWithUrlArray:(NSArray *)array isLocal:(BOOL)islocal list:(NSArray *)listArray item:(ArticleModel *)item page:(NSInteger)page nowNumber:(NSInteger)nowNumber isCollect:(BOOL)isCollect category:(NSString *)category
{
    if (self = [super init]) {
        self.category = category;
        self.videoUrlArray = array;
        self.dataArray = [[NSMutableArray alloc] initWithArray:listArray];
        self.nowNumber = nowNumber;
        self.page = page;
        self.item = item;
        self.isLocal = islocal;
        if (self.isLocal) {
            self.url = [array objectAtIndex:0];
        }
        else {
            self.url = [array objectAtIndex:1];
        }
        self.isCollect = isCollect;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            scale = SCALE / 2.0;
        }
        else {
            scale = SCALE;
        }
        isFirst = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    cacheView = [[CachingView alloc] init];
    
    //[self ad];

    
    [self setPlayViewControllerProperty];
    [self bannerId];

    [self setHeadView];
    [self setBottomView];
//    [self setPlayView];
    [self setVolumnViewForPlay];
    
    [self.view addSubview:self.tableView];
    [self changyan];
    
    

    
    shareView = [[ShareView alloc] init];
    shareView.delegate = self;
    CGRect rect = shareView.frame;
    rect.origin.y += rect.size.height;
    shareView.frame = rect;
    self.item.link = [NSString stringWithFormat:@"%@/m/detail/videosdetails.aspx?id=%@",appdelegate.appUrl,self.item.articleId];
    [shareView getArticleModel:self.item];
    [self.view addSubview:shareView];

    [self.view addSubview:cacheView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playnow) name:@"playNow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playnow) name:@"playPause" object:nil];

}

- (void)playnow
{
    [self playButtonClick:self.playButton];
}

- (void)beginPlay
{
    [self performSelectorOnMainThread:@selector(playButtonClick:) withObject:_playButton waitUntilDone:NO];

}

- (void)ad
{
    if (self.floatWindow) {
        
    }else{
    self.floatWindow = [[MobiSageFloatWindow alloc] initWithAdSize:Float_size_0
                                                          delegate:self
                                                         slotToken:MS_Test_SlotToken_Poster];
    }
}


#pragma mark - MobiSageFloatWindowDelegate
#pragma mark

- (void)mobiSageFloatClick:(MobiSageFloatWindow*)adFloat
{
    NSLog(@"mobiSageFloatClick");

}

- (void)mobiSageFloatClose:(MobiSageFloatWindow*)adFloat
{
    NSLog(@"mobiSageFloatClose");
    [self.floatWindow removeFromSuperview];
    self.floatWindow.delegate = nil;
    self.floatWindow = nil;

}

- (void)mobiSageFloatSuccessToRequest:(MobiSageFloatWindow*)adFloat
{
    NSLog(@"mobiSageFloatSuccessToRequest");
    [self.floatWindow showAdvView];
//    [self performSelector:@selector(mobiSageFloatClose:) withObject:self.floatWindow afterDelay:2];

}

- (void)mobiSageFloatFaildToRequest:(MobiSageFloatWindow*)adFloat withError:(NSError *)error
{
    NSLog(@"mobiSageFloatFaildToRequest error = %@", [error description]);
    [self.floatWindow removeFromSuperview];
    self.floatWindow.delegate = nil;
    self.floatWindow = nil;
    [self beginPlay];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    if (_cbPlayerController.playbackState == CBPMoviePlaybackStatePaused) {
        [self playButtonClick:_playButton];
    }
    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"播放"
                                            action:@"正在播放视频"
                                             label:[NSString stringWithFormat:@"正在播放视频 %@" ,self.url]
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];

    [MobClick event:[NSString stringWithFormat:@"正在播放视频 %@" ,self.url]];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;

}

- (void)setPlayViewControllerProperty
{
    _cbPlayerController = [PlayManager shareManager].cbPlayerController;
    //_cbPlayerController.scalingMode = CBPMovieScalingModeNone;
    if (IS_IOS8) {
        _cbPlayerController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    else {
        _cbPlayerController.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);

    }
    [self.view addSubview:_cbPlayerController.view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes)];
    [_cbPlayerController.view addGestureRecognizer:tap];
    [_cbPlayerController setContentString:self.url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparedDone:) name:CyberPlayerLoadDidPreparedNotification object:nil];
    _cbPlayerController.shouldAutoplay = NO;
    [_cbPlayerController prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheProgress:) name:CyberPlayerGotCachePercentNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seekComplete:)
                                                 name:CyberPlayerSeekingDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(error:) name:CyberPlayerPlaybackErrorNotification object:Nil];
    
}

- (void)error:(NSNotification *)notication
{
    NSLog(@"error:%@",notication.object);
}

- (void)preparedDone:(NSNotification *)notication
{
    [self performSelectorOnMainThread:@selector(cacheHidden) withObject:Nil waitUntilDone:NO];
    NSLog(@"prepare done");
    [self startTimer];
//    if (isFirst)
//    {
//        return;
//        isFirst = NO;
//    }
    [self performSelectorOnMainThread:@selector(playButtonClick:) withObject:_playButton waitUntilDone:NO];

}


- (void)startTimer{
    //为了保证UI刷新在主线程中完成。
    [self performSelectorOnMainThread:@selector(startTimeroOnMainThread) withObject:nil waitUntilDone:NO];
}
- (void)startTimeroOnMainThread{
    timerPause = NO;
    if (_timer) {
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
}
- (void)timerHandler:(NSTimer*)timer
{
    [self refreshProgress:_cbPlayerController.currentPlaybackTime totalDuration:_cbPlayerController.duration];
}
- (void)refreshProgress:(int) curTime totalDuration:(int)allSecond
{
    //    NSLog(@"speed:%f,progress:%f,downloadnumber:%d",[[M3U8Manager sharedManager] getSpeedFromUrl:self.url],[[M3U8Manager sharedManager] getProgress:self.url],[M3U8Manager sharedManager].finishNumber);
    if (timerPause) {
        return;
    }
    
    //    if ([self stringToNumber:totalTime.text] <= 0) {
    totalTime.text = [NSString stringWithFormat:@"/%@",[self numberToString:_cbPlayerController.duration]];
    //    }
    currentTime.text = [self numberToString:curTime];
    slider.value = curTime * 1.0 / _cbPlayerController.duration;
    
}


- (void)cacheProgress:(NSNotification *)notication
{
    NSLog(@"cache : %@",notication.object);
    int value = [(NSNumber *)notication.object integerValue];
    if (value < 100) {
        if (cacheView.hidden) {
            [self performSelectorOnMainThread:@selector(cacheAppear) withObject:Nil waitUntilDone:NO];
        }
    }
    if (value == 100) {
        if (!cacheView.hidden) {
            [self performSelectorOnMainThread:@selector(cacheHidden) withObject:Nil waitUntilDone:NO];
        }
    }
    
}

- (void)cacheHidden
{
    cacheView.hidden = YES;
}

- (void)cacheAppear
{
    cacheView.hidden = NO;
}

- (void)seekComplete:(NSNotification*)notification
{
    [self performSelectorOnMainThread:@selector(cacheHidden) withObject:Nil waitUntilDone:NO];
    NSLog(@"seek Complete");
    
    //开始启动UI刷新
    [self startTimer];

}


#pragma mark - headView
- (void)setHeadView
{
    headBackgroundView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"headBackgroundPlay")];
    headBackgroundView.frame = CGRectMake(0, 0, _cbPlayerController.view.frame.size.width, 40 * scale);
    [self.view addSubview:headBackgroundView];
    headBackgroundView.userInteractionEnabled = YES;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _cbPlayerController.view.frame.size.width - 300, headBackgroundView.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineBreakMode = NSLineBreakByClipping;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.item.title;
    titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:18];
    [headBackgroundView addSubview:titleLabel];
    
    
    
    CGFloat width = 56;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        width = 67;
    }
    
    if (!self.isLocal) {
        
        
        UIImageView *sep = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
        sep.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width - 1, (headBackgroundView.frame.size.height - 30 * scale) / 2.0, sep.frame.size.width, 30 * scale);
        [headBackgroundView addSubview:sep];
        
        UIImageView *sep1 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
        sep1.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width * 2 - 1 * 2, (headBackgroundView.frame.size.height - 30 * scale) / 2.0, sep.frame.size.width, 30 * scale);
        [headBackgroundView addSubview:sep1];
        
        
        UIImageView *sep2 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
        sep2.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width  * 3 - 1 * 3, (headBackgroundView.frame.size.height - 30 * scale) / 2.0, sep.frame.size.width, 30 * scale);
        [headBackgroundView addSubview:sep2];
        
        
//        UIImageView *sep3 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
//        sep3.frame = CGRectMake(_cbPlayerController.view.frame.size.width - 56 * 4 - 1 * 4, (headBackgroundView.frame.size.height - 30 * scale) / 2.0, sep.frame.size.width, 30 * scale);
//        [headBackgroundView addSubview:sep3];
        
        
        
        
        listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        listButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width - 1, 0, width, headBackgroundView.frame.size.height);
        [listButton setImage:IMAGENAMED(@"video_choose") forState:UIControlStateNormal];
        [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headBackgroundView addSubview:listButton];
        
        videoDefinitionButton = [[VideoDefinitionChooseButton alloc] initWithFrame:CGRectMake(_cbPlayerController.view.frame.size.width - width * 2 - 1 * 2, 0, width, headBackgroundView.frame.size.height) Delegate:self buttonFrame:CGRectMake(0, 0, width, headBackgroundView.frame.size.height)];
        videoDefinitionButton.backgroundColor = [UIColor clearColor];
        [headBackgroundView addSubview:videoDefinitionButton];
        
        
        downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width * 3 - 1 * 3, 0, width, headBackgroundView.frame.size.height);
        [downloadButton setImage:IMAGENAMED(@"download") forState:UIControlStateNormal];
        [downloadButton addTarget:self action:@selector(downloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [headBackgroundView addSubview:downloadButton];
        
        
        
        
        reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reportButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width * 4 - 1 * 4, 0, width, headBackgroundView.frame.size.height);
        [reportButton setImage:IMAGENAMED(@"report_video") forState:UIControlStateNormal];
        
        [reportButton addTarget:self action:@selector(reportButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [headBackgroundView addSubview:reportButton];
        
        
        
        

        
    }
    else {
        CGRect rect = titleLabel.frame;
        rect.size.width += 280;
        titleLabel.frame = rect;
    }
    
}

- (void)downloadButtonClick
{
    NSString *url = [self.videoUrlArray objectAtIndex:1];
    if ([[DownloadFinishedManager shareManager] searchLocationHaveThisFile:url]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"该视频已下载";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    
    else if ([[M3U8Manager sharedManager].downloadDictionary objectForKey:url])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"该视频正在下载";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = LOCAL_LANGUAGE(@"begin download");
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[M3U8Manager sharedManager] addTargetForUrl:self.url name:self.item.title category:self.category];
        
    });
}


- (void)listButtonClick:(UIButton *)button
{
    self.tableView.hidden = !self.tableView.hidden;
}


- (void)commentButtonClick:(UIButton *)button
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controller = [[CommentListViewControllerForPad alloc] initWithArticle:self.item articleId:self.changyanId];
        [self.view addSubview:controller.view];
        return;
    }
    CommentListViewController *comment = [[CommentListViewController alloc] initWithArticle:self.item articleId:self.changyanId];
    comment.isPresent = YES;
    [self presentViewController:comment animated:YES completion:^{
        ;
    }];
}

- (void)shareButtonClick:(UIButton *)button
{
    
    [self playButtonClick:_playButton];
    
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

- (void)collectButtonClick:(UIButton *)button
{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:LOCAL_LANGUAGE(@"video")]];;
    ArticleModel *model = [self.dataArray objectAtIndex:self.nowNumber];
    
    NSDictionary *nowModel = [ModelExChangeDictionary modelChangeToDictionary:model];
    if (button.selected) {
        
        NSArray *aa = [NSArray arrayWithArray:array];
        for (NSDictionary *dd in aa) {
            if ([[dd objectForKey:@"articleId"] isEqualToString:model.articleId]) {
                [array removeObject:dd];
            }
        }
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"video")];
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
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"video")];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];


    }
    button.selected = !button.selected;

}

#pragma mark - tableView

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_cbPlayerController.view.frame.size.width - 200, 40 * scale, 200, _cbPlayerController.view.frame.size.height - (40 + 54 ) * scale) style:UITableViewStylePlain];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _tableView.frame = CGRectMake(_cbPlayerController.view.frame.size.width - 300, 40 * scale, 300, _cbPlayerController.view.frame.size.height - (40 + 54) * scale);
        }
        _tableView.hidden = YES;
        _tableView.backgroundColor = RGBCOLOR(73, 73, 73);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //for adapter ios7 tableview
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            self.edgesForExtendedLayout = UIRectEdgeBottom;
        }
        _footer = [[MJRefreshFooterView alloc] init];
        _footer.delegate = self;
        _footer.scrollView = self.tableView;
        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = FONTSIZE(14);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    if (self.nowNumber == indexPath.row) {
        cell.textLabel.textColor = RGBCOLOR(255, 138, 0);
    }
    else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    ArticleModel *articleModel = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = articleModel.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopTimer];
    titleLabel.text = self.item.title;
    _tableView.hidden = YES;
    _playButton.selected = NO;
    totalTime.text = @"00:00";
    currentTime.text = @"00:00";
    slider.value = 0;

    
    ArticleModel *articleModel = [_dataArray objectAtIndex:indexPath.row];
    self.item = articleModel;
    self.nowNumber = indexPath.row;
    [self videoUrlArrayRequest];
    
}

- (void)videoUrlArrayRequest
{

    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/flashinterface/getmovieurl.ashx?movieid=%@&typeid=2&level=10",HOST,self.item.articleId];
    [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finishVideoMethod:" failMethod:@"failVideoMethod:"];
}


- (void)finishVideoMethod:(NSData *)data
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT];
    if ([dict objectForKey:self.item.articleId]) {
        self.isCollect = YES;
    }
    else {
        self.isCollect = NO;
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *aa = [string componentsSeparatedByString:@"^"];
    self.videoUrlArray = aa;
    self.url = [aa objectAtIndex:1];
    
    //self.url = @"http://v.youku.com/player/getM3U8/vid/XNzQwOTkwOTAw/type/hd2/v.m3u8";
    
    _cbPlayerController.contentString = self.url;
    [_cbPlayerController prepareToPlay];
    [self.tableView reloadData];
}

- (void)failVideoMethod:(NSError *)error
{
    MKLog(@"error:%@",error);
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self getCenterViewData];
}



- (void)getCenterViewData
{
    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *string = [NSString stringWithFormat:@"%@/flashinterface/getmoviebypage.ashx?page=%d&pagesize=10&classes=%@&sort=1",HOST,self.page,self.category];
    [request urlRequestWithGetUrl:string delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
}

- (void)finishMethod:(NSData *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSError *error;
    GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
    NSArray *employees = [pagedoc nodesForXPath:@"//article" error:NULL];
    
    for (GDataXMLElement *employe in employees) {
        ArticleModel *model = [[ArticleModel alloc] init];
        model.title = [[employe attributeForName:@"t"] stringValue];
        model.image = [[employe attributeForName:@"p"] stringValue];
        model.articleId = [[employe attributeForName:@"id"] stringValue];
        model.date = [[employe attributeForName:@"date"] stringValue];
        [array addObject:model];
    }
    [_footer endRefreshing];

    if ([array count] == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已经到底啦！";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
    }

    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
    self.page ++;
}

- (void)failMethod:(NSError *)error
{
    MKLog(@"error :%@",error);
}



#pragma mark - bottomView

- (void)setBottomView
{
    bottomBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headBackgroundPlay"]];
    bottomBackgroundView.frame = CGRectMake(0, _cbPlayerController.view.frame.size.height - 54 * scale, _cbPlayerController.view.frame.size.width, 54  * scale);
    bottomBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:bottomBackgroundView];
    
    CGFloat width = 56;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        width = 67;
    }

    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(17, (bottomBackgroundView.frame.size.height - 38) / 2.0, 38, 38);
    [_playButton setImage:IMAGENAMED(@"play_orange") forState:UIControlStateNormal];
    [_playButton setImage:IMAGENAMED(@"play_suspend") forState:UIControlStateSelected];
    
    [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:_playButton];
    
    
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(80, (bottomBackgroundView.frame.size.height - 20) / 2.0, 20, 20);
    [nextButton setImage:IMAGENAMED(@"next") forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:nextButton];

    
    UIImageView *sep = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width - 1, (bottomBackgroundView.frame.size.height - 30 * scale) / 2.0, sep.frame.size.width, 30 * scale);
    [bottomBackgroundView addSubview:sep];
    
    UIImageView *sep1 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep1.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width * 2 - 1 * 2, (bottomBackgroundView.frame.size.height - 30 * scale) / 2.0, sep.frame.size.width, 30 * scale);
    [bottomBackgroundView addSubview:sep1];
    
    
    UIImageView *sep2 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep2.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width  * 3 - 1 * 3, (bottomBackgroundView.frame.size.height - 30 * scale) / 2.0, sep.frame.size.width, 30 * scale);
    [bottomBackgroundView addSubview:sep2];
    
    
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width, 0, width, bottomBackgroundView.frame.size.height);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setTitle:LOCAL_LANGUAGE(@"back") forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = FONTSIZE(14);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:backButton];
    
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, bottomBackgroundView.frame.size.width, 5)];
    slider.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:138/255.0 blue:0 alpha:1];
    slider.maximumTrackTintColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [slider addTarget:self action:@selector(onDragSlideValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(onDragSlideStart:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(onDragSlideDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:slider];
    slider.continuous = true;
    
    
    currentTime = [[UILabel alloc] initWithFrame:CGRectMake(136, 3, 50, bottomBackgroundView.frame.size.height)];
    currentTime.font = [UIFont fontWithName:@"Heiti SC" size:14];
    currentTime.textAlignment = NSTextAlignmentCenter;
    currentTime.backgroundColor = [UIColor clearColor];
    currentTime.textColor = [UIColor whiteColor];
    currentTime.text = @"00:00";
    currentTime.textAlignment = NSTextAlignmentRight;
    [bottomBackgroundView addSubview:currentTime];
    
    
    totalTime = [[UILabel alloc] initWithFrame:CGRectMake(currentTime.frame.size.width + currentTime.frame.origin.x, 3, 50, bottomBackgroundView.frame.size.height)];
    totalTime.font = [UIFont fontWithName:@"Heiti SC" size:14];
    totalTime.textAlignment = NSTextAlignmentLeft;
    totalTime.textColor = [UIColor whiteColor];
    totalTime.backgroundColor = [UIColor clearColor];
    totalTime.text = @"/00:00";
    [bottomBackgroundView addSubview:totalTime];
    
    
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width * 2 - 1 * 1, 0, width, bottomBackgroundView.frame.size.height);
    [collectButton setImage:IMAGENAMED(@"video_collect") forState:UIControlStateNormal];
    [collectButton setImage:IMAGENAMED(@"video_collect_pressed") forState:UIControlStateSelected];
    
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:collectButton];
    collectButton.selected = self.isCollect;
    
    
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width * 3 - 1 * 2, 0, width, bottomBackgroundView.frame.size.height);
    [shareButton setImage:IMAGENAMED(@"icon_share") forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:shareButton];
    
    if ([[appdelegate haveType] length] != 0) {
        shareButton.hidden = YES;
    }
    else {
        shareButton.hidden = NO;
    }

    
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - width * 4 - 1 * 3, 0, width, bottomBackgroundView.frame.size.height);
    [commentButton setImage:IMAGENAMED(@"comment_video") forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:commentButton];

    
}

- (void)onDragSlideValueChanged:(id)sender {
    [self stopTimer];
    NSLog(@"value changed");
    [self refreshProgress:slider.value * _cbPlayerController.duration totalDuration:_cbPlayerController.duration];
}

- (void)onDragSlideDone:(id)sender {
    NSLog(@"drag done");
    float currentTIme = slider.value * _cbPlayerController.duration;
    NSLog(@"seek to %f", currentTIme);
    //实现视频播放位置切换，
    [_cbPlayerController seekTo:currentTIme];
}
- (void)onDragSlideStart:(id)sender {
    NSLog(@"drag start");
    [self stopTimer];
}

- (void)stopTimer{
    //    if ([_timer isValid])
    //    {
    [_timer invalidate];
    //    }
    _timer = nil;
}


- (void)backButtonClick
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_cbPlayerController stop];
    [self stopTimer];
//    adBanner.delegate = Nil;
    [self dismissViewControllerAnimated:YES completion:^{
        [shareView removeFromSuperview];
        shareView = nil;
        self.mobiSageBanner.delegate = nil;
        self.mobiSageBanner = nil;
    }];
}
#pragma mark - volumnView

- (void)setVolumnViewForPlay
{
    volumnView = [[VolumnView alloc] initWithFrame:CGRectMake(0, (_cbPlayerController.view.frame.size.height - 175) / 2.0, 40, 175)];
    [self.view addSubview:volumnView];
}

#pragma mark - playView

- (void)setPlayView
{
    playBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playBackgroundPlay"]];
    CGFloat sepWidth;

    if (!self.isLocal) {
        playBackgroundView.frame = CGRectMake((_cbPlayerController.view.frame.size.width - 310 / 4.0 * 5) / 2.0, 230 * SCALE, 310 / 4.0 * 5, 44 * scale);
        sepWidth = playBackgroundView.frame.size.width / 6.0;
    }
    else {
        playBackgroundView.frame = CGRectMake((_cbPlayerController.view.frame.size.width - 310) / 2.0, 230 * SCALE, 310, 44 * scale);
        sepWidth = playBackgroundView.frame.size.width / 4.0;

    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect rect = playBackgroundView.frame;
        rect.origin.y -= 40;
        playBackgroundView.frame = rect;
    }
    playBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:playBackgroundView];
    
    
    UIImageView *sep1 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep1.frame = CGRectMake(sepWidth, (playBackgroundView.frame.size.height - 30 * scale) / 2.0, 1, 30 * scale);
    [playBackgroundView addSubview:sep1];
    
    UIImageView *sep2 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep2.frame = CGRectMake(sepWidth * 2 + 1, (playBackgroundView.frame.size.height - 30 * scale) / 2.0, 1, 30 * scale);
    [playBackgroundView addSubview:sep2];
    
    UIImageView *sep3 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep3.frame = CGRectMake(sepWidth * 3 + 2, (playBackgroundView.frame.size.height - 30 * scale) / 2.0, 1, 30 * scale);
    [playBackgroundView addSubview:sep3];
    
    
    
    
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(sepWidth, 0, sepWidth, playBackgroundView.frame.size.height);
    [_playButton setImage:IMAGENAMED(@"playButtonPlay") forState:UIControlStateNormal];
    [_playButton setImage:IMAGENAMED(@"pauseButtonPlay") forState:UIControlStateSelected];
    
    [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [playBackgroundView addSubview:_playButton];
    
    
    beforeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beforeButton.frame = CGRectMake(0, 0, sepWidth, playBackgroundView.frame.size.height);
    [beforeButton setImage:IMAGENAMED(@"beforePlayButtonPlay") forState:UIControlStateNormal];
    
    [beforeButton addTarget:self action:@selector(beforeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [playBackgroundView addSubview:beforeButton];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(sepWidth * 2, 0, sepWidth, playBackgroundView.frame.size.height);
    [nextButton setImage:IMAGENAMED(@"nextPlayButtonPlay") forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [playBackgroundView addSubview:nextButton];
    
    
    
    
    
    volumeController = [[NGVolumeControl alloc] initWithFrame:CGRectMake(playBackgroundView.frame.origin.x + sepWidth * 3, playBackgroundView.frame.origin.y, sepWidth, playBackgroundView.frame.size.height)];
    volumeController.userInteractionEnabled = YES;
    [self.view addSubview:volumeController];
    
    
    
    if (self.isLocal) {
        return;
    }
    UIImageView *sep4 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep4.frame = CGRectMake(sepWidth * 4 + 3, (playBackgroundView.frame.size.height - 30 * scale) / 2.0, 1, 30 * scale);
    [playBackgroundView addSubview:sep4];
    
    
    UIImageView *sep5 = [[UIImageView alloc] initWithImage:IMAGENAMED(@"sepPlay")];
    sep5.frame = CGRectMake(sepWidth * 5 + 4, (playBackgroundView.frame.size.height - 30 * scale) / 2.0, 1, 30 * scale);
    [playBackgroundView addSubview:sep5];

    
    
    
}

- (void)reportButtonClick
{
    [self.view appearReportView];
}

- (void)ChooseDefinition:(NSNumber *)number
{
    NSString *url;
    url = [self.videoUrlArray objectAtIndex:([number integerValue] - 100)];
    if ([url isEqualToString:self.url]) {
        return;
    }
    else {
        timerPause = YES;
        [self stopTimer];
        [self playButtonClick:_playButton];
        self.url = url;
        _cbPlayerController.contentURL = [NSURL URLWithString:self.url];
        [_cbPlayerController prepareToPlay];
        float currentTIme = slider.value * _cbPlayerController.duration;
        NSLog(@"seek to %f", currentTIme);
        //实现视频播放位置切换，
        [_cbPlayerController seekTo:currentTIme];
    }
}


- (void)playButtonClick:(UIButton *)button
{
    if (button.selected) {
        [_cbPlayerController pause];
        
        [self ad];
    }
    else
    {
        [_cbPlayerController play];
        //        [self startTimer];
    }
    button.selected = !button.selected;
}

- (void)beforeButtonClick
{
    timerPause = YES;
    [self stopTimer];
    _cbPlayerController.currentPlaybackTime -= 30;
    if (_cbPlayerController.currentPlaybackTime < 0) {
        _cbPlayerController.currentPlaybackTime = 0;
    }
    currentTime.text = [self numberToString:_cbPlayerController.currentPlaybackTime];
    slider.value = _cbPlayerController.currentPlaybackTime * 1.0 / _cbPlayerController.duration;
}

- (void)nextButtonClick
{
    timerPause = YES;
    [self stopTimer];
    _cbPlayerController.currentPlaybackTime += 30;
    if (_cbPlayerController.currentPlaybackTime > _cbPlayerController.duration) {
        _cbPlayerController.currentPlaybackTime = _cbPlayerController.duration;
    }
    currentTime.text = [self numberToString:_cbPlayerController.currentPlaybackTime];
    slider.value = _cbPlayerController.currentPlaybackTime * 1.0 / _cbPlayerController.duration;
}

- (void)hiddenShareButton
{
    if (shareButton.selected) {
        [self shareButtonClick:shareButton];
    }
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (!self.tableView.hidden) {
//        self.tableView.hidden = YES;
//    }
//    [self hiddenShareButton];
//    headBackgroundView.hidden = !headBackgroundView.hidden;
//    bottomBackgroundView.hidden = !bottomBackgroundView.hidden;
//    playBackgroundView.hidden = !playBackgroundView.hidden;
//    volumeController.hidden = !volumeController.hidden;
//    videoDefinitionButton.hidden = !videoDefinitionButton.hidden;
//    [videoDefinitionButton backgroundViewHiddenOrNot:YES];
////    adBanner.hidden = !adBanner.hidden;
//}

- (void)tapGes
{
    if (!self.tableView.hidden) {
        self.tableView.hidden = YES;
    }
    [self hiddenShareButton];
    self.mobiSageBanner.hidden = !self.mobiSageBanner.hidden;
    headBackgroundView.hidden = !headBackgroundView.hidden;
    bottomBackgroundView.hidden = !bottomBackgroundView.hidden;
    playBackgroundView.hidden = !playBackgroundView.hidden;
    volumeController.hidden = !volumeController.hidden;
    videoDefinitionButton.hidden = !videoDefinitionButton.hidden;
    [videoDefinitionButton backgroundViewHiddenOrNot:YES];
    volumnView.hidden = !volumnView.hidden;
//    adBanner.hidden = !adBanner.hidden;
}



- (NSString *)numberToString:(NSTimeInterval)time
{
    int min = (int)time / 60;
    int sec = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",min,sec];
}

- (NSTimeInterval)stringToNumber:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@":"];
    return [[array objectAtIndex:0] floatValue] * 60 + [[array lastObject] floatValue];
}


#pragma mark - banner id 
- (void)bannerId
{
    //创建MobiSage横幅广告
    self.mobiSageBanner = [[MobiSageBanner alloc] initWithDelegate:self
                                                            adSize:Default_size
                                                         slotToken:MS_Test_SlotToken_Banner];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 320) / 2.0, playBackgroundView.frame.origin.y + playBackgroundView.frame.size.height, 320, 50);
        
        self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 320) / 2.0, SCREEN_WIDTH - 83 - 30, 320, 50);
    } else {
        //self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 728) / 2.0, playBackgroundView.frame.origin.y + playBackgroundView.frame.size.height + 10, 728, 90);
        self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 728) / 2.0, SCREEN_WIDTH - 130, 728, 90);
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
    [self.mobiSageBanner removeFromSuperview];
    self.mobiSageBanner = nil;
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

- (void)changyan
{
    NSString *topicid = [NSString stringWithFormat:@"4_%@",self.item.articleId];
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
    [ChangyanSDK getCommentCountTopicUrl:nil topicSourceID:nil topicID:self.changyanId completeBlock:^(CYStatusCode statusCode,NSString *responseStr)
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
//         toolBar.talkLabel.text = [[[[dict objectForKey:@"result"] objectForKey:self.articleId] objectForKey:@"comments"] stringValue];
     }];
}



#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [[UIApplication sharedApplication] statusBarOrientation];
    }
    else {
        return UIInterfaceOrientationLandscapeLeft;
    }
}



@end
