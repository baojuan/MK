//
//  LocationPlayViewController.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-3.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "LocationPlayViewController.h"

#import "CyberPlayerController.h"
//#import "YDSlider.h"
#import "NGVolumeControl.h"
#import "M3U8VideoDownloader.h"
#import "M3U8Handler.h"
#import "NSString+Hashing.h"
#import "CachingView.h"
#import "PlayManager.h"


#define SCALE SCREEN.width / 320.0
@interface LocationPlayViewController ()<M3U8HandlerDelegate,VideoDownloadDelegate>
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *movieTitle;
@property (nonatomic, assign) BOOL isLocationPlay;
@property (nonatomic, weak) CyberPlayerController *cbPlayerController;

@end

@implementation LocationPlayViewController
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

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)url isLocationPlay:(BOOL)locationPlay
{
    if (self = [super init]) {
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
        self.movieTitle = @"12334354354534";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    timerPause = NO;
    cacheView = [[CachingView alloc] init];

    [self setPlayViewControllerProperty];
    [self setHeadView];
    [self setBottomView];
    [self setPlayView];
    [self.view addSubview:cacheView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _cbPlayerController = Nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerLoadDidPreparedNotification object:Nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerGotCachePercentNotification object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerSeekingDidFinishNotification object:Nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CyberPlayerPlaybackErrorNotification object:Nil];
    

}


- (void)setPlayViewControllerProperty
{
    
    NSString* videoFullPath = self.url;
    _cbPlayerController = [PlayManager shareManager].cbPlayerController;
    _cbPlayerController.view.frame = CGRectMake(0, 0, SCREEN.height, SCREEN.width);
    [self.view addSubview:_cbPlayerController.view];
    _cbPlayerController.view.backgroundColor = [UIColor redColor];
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
    [self startTimer];
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
    NSLog(@"begin timer");
    [self refreshProgress:_cbPlayerController.currentPlaybackTime totalDuration:_cbPlayerController.duration];
}
- (void)refreshProgress:(int) curTime totalDuration:(int)allSecond
{
    if (timerPause) {
        return;
    }
    
    if ([self stringToNumber:totalTime.text] <= 0) {
        totalTime.text = [self numberToString:_cbPlayerController.duration];
    }
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
    [self refreshProgress:slider.value * _cbPlayerController.duration totalDuration:_cbPlayerController.duration];
}

- (void)onDragSlideDone:(id)sender {
    float currentTIme = slider.value * _cbPlayerController.duration;
    NSLog(@"seek to %f", currentTIme);
    //实现视频播放位置切换，
    [_cbPlayerController seekTo:currentTIme];
}
- (void)onDragSlideStart:(id)sender {
    [self stopTimer];
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}


- (void)backButtonClick
{
    [_cbPlayerController stop];
    [self stopTimer];
    
    [self dismissViewControllerAnimated:YES completion:^{
        ;
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
    [playButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateSelected];
    
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
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}


@end
