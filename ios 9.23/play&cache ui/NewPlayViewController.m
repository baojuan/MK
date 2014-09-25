//
//  NewPlayViewController.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-2.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "NewPlayViewController.h"

#import "CyberPlayerController.h"
#import "NGVolumeControl.h"
#import "M3U8VideoDownloader.h"
#import "M3U8Handler.h"
#import "NSString+Hashing.h"

#import "M3U8Manager.h"
#import "CachingView.h"
#import "PlayManager.h"
#import "DownloadFinishedManager.h"
#import "Variable.h"

#import "MJRefresh.h"
#import "AppDelegate.h"

#define SCALE SCREEN.width / 320.0


@interface NewPlayViewController ()<M3U8HandlerDelegate,VideoDownloadDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *movieTitle;
@property (nonatomic, assign) BOOL isLocationPlay;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, weak) CyberPlayerController *cbPlayerController;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation NewPlayViewController
{
    NSTimer *_timer;
    
    //headView
    UIImageView *headBackgroundView;
    UIButton *downloadButton;
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
    UIButton *playButton;
    UIButton *nextButton;
    NGVolumeControl *volumeController;
    
    //m3u8
    M3U8VideoDownloader* m_downloader;
    M3U8Handler* m_handler;
    
    BOOL viewIsHidden;
    BOOL timerPause;
    
    
    CachingView *cacheView;
    
    UIView *listView;
    NSMutableArray *dataArray;
    
    
    UILabel *beginAlert;
    
    
    MJRefreshFooterView *_footer;
    GDataXMLDocument *pagedoc;
    UITableView *tableView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)url isLocationPlay:(BOOL)locationPlay name:(NSString *)name category:(NSString *)category dataArray:(NSMutableArray *)array
{
    if (self = [super init]) {
        self.array = [[NSMutableArray alloc] initWithArray:array];
        self.name = name;
        self.category = category;
        self.isLocationPlay = locationPlay;
        if (locationPlay) {
            self.url = [[NSUserDefaults standardUserDefaults] objectForKey:[url MD5Hash]];
            if (!self.url) {
                self.url = url;
            }
        }
        else
        {
            self.url = url;
        }
        self.movieTitle = name;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _appDelegate = [[UIApplication sharedApplication] delegate];

    self.navigationController.navigationBarHidden = YES;
    
    [self reSetDataArray];
    timerPause = NO;
    listView = [self createListView];
    listView.hidden = YES;
    cacheView = [[CachingView alloc] init];
    [self setPlayViewControllerProperty];
    [self setHeadView];
    [self setBottomView];
    [self setPlayView];
    [self.view addSubview:listView];

    [self.view addSubview:cacheView];

}

- (void)reSetDataArray
{
    dataArray = [[NSMutableArray alloc] initWithArray:self.array];
    Variable *ii;
    for (Variable * item in dataArray) {
        if ([item.names isEqualToString:self.name]) {
            ii = item;
            break;
        }
    }
    [dataArray removeObject:ii];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"player state:%d", _cbPlayerController.playbackState);
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _cbPlayerController = Nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerLoadDidPreparedNotification object:Nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerGotCachePercentNotification object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerSeekingDidFinishNotification object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerPlaybackErrorNotification object:Nil];
    
    self.navigationController.navigationBarHidden = NO;


}

- (void)setPlayViewControllerProperty
{
//    NSString* msAK=@"j6KXbaOu8cGM8oiBjAEvE49q";
//    NSString* msSK=@"biFdX0ILp9pqyreI1rrYbU9cbNYBSFr2";
//    [[CyberPlayerController class] setBAEAPIKey:msAK SecretKey:msSK];
    NSString* videoFullPath = self.url;
    _cbPlayerController = [PlayManager shareManager].cbPlayerController;
    _cbPlayerController.view.frame = CGRectMake(0, 0, SCREEN.height, SCREEN.width);
    [self.view addSubview:_cbPlayerController.view];
    [_cbPlayerController setContentString:videoFullPath];
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
    [self performSelectorOnMainThread:@selector(playButtonClick:) withObject:playButton waitUntilDone:NO];
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
    NSLog(@"speed:%f,progress:%f,downloadnumber:%d",[[M3U8Manager sharedManager] getSpeedFromUrl:self.url],[[M3U8Manager sharedManager] getProgress:self.url],[M3U8Manager sharedManager].finishNumber);
    if (timerPause) {
        return;
    }
    
//    if ([self stringToNumber:totalTime.text] <= 0) {
        totalTime.text = [self numberToString:_cbPlayerController.duration];
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

- (void)setHeadView
{
    headBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headBackground"]];
    headBackgroundView.frame = CGRectMake(0, 0, _cbPlayerController.view.frame.size.width, 40 * SCALE);
    [self.view addSubview:headBackgroundView];
    headBackgroundView.userInteractionEnabled = YES;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _cbPlayerController.view.frame.size.width - 140, headBackgroundView.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineBreakMode = NSLineBreakByClipping;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.movieTitle;
    titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:18];
    [headBackgroundView addSubview:titleLabel];
    
    
    UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep"]];
    sep.frame = CGRectMake(_cbPlayerController.view.frame.size.width - 56 - 1, (headBackgroundView.frame.size.height - 30 * SCALE) / 2.0, sep.frame.size.width, 30 * SCALE);
    [headBackgroundView addSubview:sep];
    
    if (!self.isLocationPlay) {
        downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - 56, 0, 56, headBackgroundView.frame.size.height);
        [downloadButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [downloadButton addTarget:self action:@selector(downloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [headBackgroundView addSubview:downloadButton];
        
        
        
        listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        listButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - 56 * 2 - 1, 0, 56, headBackgroundView.frame.size.height);
        [listButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headBackgroundView addSubview:listButton];
    }
    
}

- (void)downloadButtonClick
{
    if ([[DownloadFinishedManager shareManager] searchLocationHaveThisFile:self.url]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该视频已下载" message:Nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    else if ([[M3U8Manager sharedManager].downloadDictionary objectForKey:self.url])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该视频正在下载" message:Nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
   
    beginAlert = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN.height - 100) / 2.0, (SCREEN.width - 30) / 2.0, 100, 30)];
    beginAlert.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    
    beginAlert.text = @"开始下载";
    beginAlert.textAlignment = NSTextAlignmentCenter;
    beginAlert.font = [UIFont fontWithName:@"Heiti SC" size:16];
    beginAlert.textColor = [UIColor whiteColor];
    [self.view addSubview:beginAlert];
    
    [self performSelector:@selector(removeBeginAlert) withObject:Nil afterDelay:1];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[M3U8Manager sharedManager] addTargetForUrl:self.url name:self.name category:self.category];

    });
}

- (void)removeBeginAlert
{
    [beginAlert removeFromSuperview];
    beginAlert = Nil;
}

- (void)listButtonClick:(UIButton *)button
{
    listView.hidden = !listView.hidden;
}

- (UIView *)createListView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN.height - 200, 40 * SCALE, 200, SCREEN.width - (40 + 30 ) * SCALE)];
    view.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [view addSubview:tableView];
    //for adapter ios7 tableview
    if([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = tableView;
    return view;
}



- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self initPageDate];
}
- (void)initPageDate{
    
    
    NSString* getURLsr = _appDelegate.serverURL;
    //NSString* getURLsrful = [getURLsr stringByAppendingString:@"/sound.xml?page=%d&pagesize=%d&categoryid=%@"];
    
    
    //NSString* getURLsrful = [getURLsr stringByAppendingString:@"/GetNewSoundByPage.ashx?page=%d&pagesize=%d&classes=%@"];
    
    NSString* getURLsrful = [getURLsr stringByAppendingString:@"/GetMovieByPage.ashx?page=%d&pagesize=%d&classes=%@&sort=%@"];
    self.pageNumber ++;
    NSString* CallWebServer = [[NSString alloc] initWithFormat:getURLsrful,self.pageNumber,_appDelegate.pageCountFn,_appDelegate.tabNavFn4,_appDelegate.bySort];
    
    NSLog(CallWebServer);
    
    
    
    CallWebServer = [CallWebServer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    __block __typeof__(self) blockSelf = self;
	__block ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:CallWebServer]];
	[request addRequestHeader:@"Content-Type" value:@"text/xml"];
    
	[request setCompletionBlock:^
     {
         [_footer endRefreshing];

         if ([request responseStatusCode] != 200)
         {
             NSDictionary* userInfo = [NSDictionary
                                       dictionaryWithObject:@"Unexpected response from server"
                                       forKey:NSLocalizedDescriptionKey];
             
             NSError* error = [NSError
                               errorWithDomain:NSCocoaErrorDomain
                               code:kCFFTPErrorUnexpectedStatusCode
                               userInfo:userInfo];
             
             [blockSelf handleError:error];
             return;
         }
         
         pagedoc = [[GDataXMLDocument alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding error:NULL];
         
         
         if (pagedoc) {
             NSArray *employees = [pagedoc nodesForXPath:@"//article" error:NULL];
             
             
             if(employees.count!=0){
                 GDataXMLElement *employe = [employees objectAtIndex:0];
                 
                 
                 for (GDataXMLElement *employe in employees) {
                     
                     
                     GDataXMLNode *node_id = [employe attributeForName:@"id"];//解析属性
                     //GDataXMLNode *node_categoryid = [employe attributeForName:@"categoryid"];//解析属性
                     
                     GDataXMLNode *node_t = [employe attributeForName:@"t"];//解析属性
                     GDataXMLNode *node_n = [employe attributeForName:@"release"];//解析属性
                     
                     
                     GDataXMLNode *node_p = [employe attributeForName:@"p"];//解析属性
                     GDataXMLNode *node_date = [employe attributeForName:@"date"];//解析属性
                     //GDataXMLNode *node_form = [employe attributeForName:@"form"];//解析属性
                     GDataXMLNode *node_ishot = [employe attributeForName:@"ishot"];//解析属性
                     GDataXMLNode *node_TopicID = [employe attributeForName:@"topicid"];//解析属性
                     
                     GDataXMLNode *node_startlight = [employe attributeForName:@"startlight"];//解析属性
                     
                     GDataXMLNode *node_actor = [employe attributeForName:@"actor"];//解析属性
                     
                     
                     GDataXMLNode *node_click = [employe attributeForName:@"click"];//解析属性
                     GDataXMLNode *node_classes = [employe attributeForName:@"classes"];//解析属性
                     
                     GDataXMLNode *node_area = [employe attributeForName:@"area"];//解析属性
                     GDataXMLNode *node_ding = [employe attributeForName:@"ding"];//解析属性
                     
                     
                     Variable *item = [[Variable alloc] init];
                     item.ids = node_id.stringValue;
                     item.names = node_t.stringValue;
                     item.notes = node_n.stringValue;
                     item.images = node_p.stringValue;
                     item.actor = node_actor.stringValue;
                     item.forms = @"";
                     item.ishot = node_ishot.stringValue;
                     item.starlight = node_startlight.stringValue;
                     item.area = node_area.stringValue;
                     item.classes = node_classes.stringValue;
                     item.dates = node_date.stringValue;
                     item.ding = node_ding.stringValue;
                     item.topicid = node_TopicID.stringValue;
                     [self.array addObject:item];
                     
                 }
             }
             [self reSetDataArray];
             [tableView performSelectorOnMainThread:@selector(reloadData) withObject:Nil waitUntilDone:NO];

         }
     }];
    
    [request setFailedBlock:^
     {
         [_footer endRefreshing];

         [blockSelf handleError:[request error]];
     }];
    
    if ([[M3U8Manager sharedManager].allTaskArray count] && ([[M3U8Manager sharedManager] getSpeedFromUrl:[M3U8Manager sharedManager].nowDownloading.url] != 0)) {
        [request startSynchronous];
        
    }
    else
    {
        [request startAsynchronous];
    }
}


- (void)handleError:(NSError*)error
{
    [_appDelegate HUDshowError:NSLocalizedString(@"Load Failed!",nil)];
    //NSLog(@"网络连接错误");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [_footer endRefreshing];

    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    }
    Variable *item = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.names;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopTimer];
    Variable *item = [dataArray objectAtIndex:indexPath.row];
    NSString *first = [[[[item.actor componentsSeparatedByString:@"id_"] lastObject] componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *string = [NSString stringWithFormat:@"http://v.youku.com/player/getM3U8/vid/%@/type/hd/v.m3u8",first];
    self.name = item.names;
    self.url = string;
    _cbPlayerController.contentString = string;
    [_cbPlayerController prepareToPlay];
    [self reSetDataArray];
    [tableView reloadData];
    titleLabel.text = self.name;
    listView.hidden = YES;
    playButton.selected = NO;
    totalTime.text = @"00:00";
    currentTime.text = @"00:00";
    slider.value = 0;
}

- (void)setBottomView
{
    bottomBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headBackground"]];
    bottomBackgroundView.frame = CGRectMake(0, _cbPlayerController.view.frame.size.height - 30 * SCALE, _cbPlayerController.view.frame.size.width, 30  * SCALE);
    bottomBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:bottomBackgroundView];
    
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(_cbPlayerController.view.frame.size.width - 50, 0, 50, bottomBackgroundView.frame.size.height);
    [backButton setImage:[UIImage imageNamed:@"backbutton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:backButton];
    
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(56, (bottomBackgroundView.frame.size.height - 20) / 2.0, bottomBackgroundView.frame.size.width - 100 - 56, 20)];
    slider.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:138/255.0 blue:0 alpha:1];
    slider.maximumTrackTintColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [slider addTarget:self action:@selector(onDragSlideValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(onDragSlideStart:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(onDragSlideDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackgroundView addSubview:slider];
    slider.continuous = true;
    
    
    currentTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 56, bottomBackgroundView.frame.size.height)];
    currentTime.font = [UIFont fontWithName:@"Heiti SC" size:14];
    currentTime.textAlignment = NSTextAlignmentCenter;
    currentTime.backgroundColor = [UIColor clearColor];
    currentTime.textColor = [UIColor whiteColor];
    currentTime.text = @"00:00";
    [bottomBackgroundView addSubview:currentTime];
    
    
    totalTime = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x + slider.frame.size.width, 3, 50, bottomBackgroundView.frame.size.height)];
    totalTime.font = [UIFont fontWithName:@"Heiti SC" size:14];
    totalTime.textAlignment = NSTextAlignmentCenter;
    totalTime.textColor = [UIColor whiteColor];
    totalTime.backgroundColor = [UIColor clearColor];
    totalTime.text = @"00:00";
    [bottomBackgroundView addSubview:totalTime];
    
    
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
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)setPlayView
{
    playBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playBackground"]];
    playBackgroundView.frame = CGRectMake((_cbPlayerController.view.frame.size.width - 310) / 2.0, 230 * SCALE, 310, 44 * SCALE);
    playBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:playBackgroundView];
    
    CGFloat sepWidth = playBackgroundView.frame.size.width / 4.0;
    
    UIImageView *sep1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep"]];
    sep1.frame = CGRectMake(sepWidth, (playBackgroundView.frame.size.height - 30 * SCALE) / 2.0, 1, 30 * SCALE);
    [playBackgroundView addSubview:sep1];
    
    UIImageView *sep2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep"]];
    sep2.frame = CGRectMake(sepWidth * 2 + 1, (playBackgroundView.frame.size.height - 30 * SCALE) / 2.0, 1, 30 * SCALE);
    [playBackgroundView addSubview:sep2];
    
    UIImageView *sep3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep"]];
    sep3.frame = CGRectMake(sepWidth * 3 + 2, (playBackgroundView.frame.size.height - 30 * SCALE) / 2.0, 1, 30 * SCALE);
    [playBackgroundView addSubview:sep3];
    
    
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(sepWidth, 0, sepWidth, playBackgroundView.frame.size.height);
    [playButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"pauseButton"] forState:UIControlStateSelected];
    
    [playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [playBackgroundView addSubview:playButton];
    
    
    beforeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beforeButton.frame = CGRectMake(0, 0, sepWidth, playBackgroundView.frame.size.height);
    [beforeButton setImage:[UIImage imageNamed:@"beforePlayButton"] forState:UIControlStateNormal];
    
    [beforeButton addTarget:self action:@selector(beforeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [playBackgroundView addSubview:beforeButton];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(sepWidth * 2, 0, sepWidth, playBackgroundView.frame.size.height);
    [nextButton setImage:[UIImage imageNamed:@"nextPlayButton"] forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [playBackgroundView addSubview:nextButton];
    
    
    volumeController = [[NGVolumeControl alloc] initWithFrame:CGRectMake(playBackgroundView.frame.origin.x + sepWidth * 3, playBackgroundView.frame.origin.y, sepWidth, playBackgroundView.frame.size.height)];
    volumeController.userInteractionEnabled = YES;
    [self.view addSubview:volumeController];
    
}

- (void)playButtonClick:(UIButton *)button
{
    if (button.selected) {
        [_cbPlayerController pause];
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (viewIsHidden) {
        headBackgroundView.hidden = NO;
        bottomBackgroundView.hidden = NO;
        playBackgroundView.hidden = NO;
        volumeController.hidden = NO;
        
    }
    else
    {
        headBackgroundView.hidden = YES;
        bottomBackgroundView.hidden = YES;
        playBackgroundView.hidden = YES;
        volumeController.hidden = YES;
        listView.hidden = YES;
    }
    viewIsHidden = !viewIsHidden;
    
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
    return UIInterfaceOrientationLandscapeRight;
}


@end
