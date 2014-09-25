//
//  DownloadViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadFinishedManager.h"
#import "DownloadCell.h"
#import "M3U8Manager.h"
#import "PlayViewController.h"

@interface DownloadViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SegmentView *segView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) NSMutableArray *dataArray;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation DownloadViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    UIView *cachingTableHeadView;
    UIView *cachedTableHeadView;
    UISegmentedControl *segmentController;
    UIImageView *noImageView;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        self.screenName = @"下载缓存";


    }
    return self;
}
- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:Nil rightButtonImage:IMAGENAMED(@"downloadDelete") ForPad:NO ForPadFullScreen:NO];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView.rightButton addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationView];
    
    
    segmentController = [[UISegmentedControl alloc] initWithItems:@[@"完成缓存",@"正在缓存"]];
    segmentController.frame = RECT((SCREEN_WIDTH - 190) / 2.0, 22, 190, 40);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        segmentController.frame = RECT((320 - 190) / 2.0, 22, 190, 40);
    }

    segmentController.backgroundColor = [UIColor clearColor];
    segmentController.tintColor = [UIColor whiteColor];
    segmentController.selectedSegmentIndex = 0;
    [segmentController addTarget:self action:@selector(segmentButtonClick) forControlEvents:UIControlEventValueChanged];
    [navigationView addSubview:segmentController];

}

- (void)segmentButtonClick
{
    if (segmentController.selectedSegmentIndex == 0) {
        if ([[DownloadFinishedManager shareManager].finishedArray count] == 0) {
            noImageView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else {
            noImageView.hidden = YES;
            self.tableView.hidden = NO;
        }
    }
    else {
        if ([[M3U8Manager sharedManager].allTaskArray count] == 0) {
            noImageView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else {
            noImageView.hidden = YES;
            self.tableView.hidden = NO;
        }
    }

    
    self.tableView.editing = NO;
    [_tableView reloadData];
}

- (void)deleteBtnClicked
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}


- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [MobClick event:[NSString stringWithFormat:@"正在查看下载"]];

    [self beginTimer];

    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self addObjectToDataArray];
    [self setHeadView];
    [self setTableViewProperty];
    
    
    cachingTableHeadView = [self cachingView];
    cachedTableHeadView = [self cachedView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinished) name:@"DownLoadFinished" object:Nil];
    if ([[DownloadFinishedManager shareManager].finishedArray count] == 0) {
        noImageView.hidden = NO;
        self.tableView.hidden = YES;
    }
    else {
        noImageView.hidden = YES;
        self.tableView.hidden = NO;
    }

}

- (void)downloadFinished
{
    [self performSelectorOnMainThread:@selector(downloadFinishedForMainThread) withObject:Nil waitUntilDone:NO];
}

- (void)downloadFinishedForMainThread
{
    _dataArray = [M3U8Manager sharedManager].allTaskArray;
    if ([_dataArray count] == 0) {
        [_timer invalidate];
        segmentController.selectedSegmentIndex = 0;
    }
    [_tableView reloadData];

    if (segmentController.selectedSegmentIndex == 0) {
        if ([[DownloadFinishedManager shareManager].finishedArray count] == 0) {
            noImageView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else {
            noImageView.hidden = YES;
            self.tableView.hidden = NO;
        }
    }
    else {
        if ([[M3U8Manager sharedManager].allTaskArray count] == 0) {
            noImageView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else {
            noImageView.hidden = YES;
            self.tableView.hidden = NO;
        }
    }

}


- (void)addObjectToDataArray
{
    _dataArray = [M3U8Manager sharedManager].allTaskArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self beginTimer];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self beginTimer];
}


- (UIView *)cachingView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(10, 7, 67, 33);
    [button setTitle:@"全部开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    [button addTarget:self action:@selector(beginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor whiteColor];
    button2.frame = CGRectMake(170 / 2.0, 7, 67, 33);
    [button2 setTitle:@"全部暂停" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(stopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    [view addSubview:button2];
    
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor whiteColor];
    [button3 setTitle:@"清空" forState:UIControlStateNormal];
    button3.frame = CGRectMake(520 / 2.0, 7, 104 / 2.0, 33);
    [button3 setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(cleanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button3.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    [view addSubview:button3];
    
    
    return view;
    
}

- (UIView *)cachedView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    label.textColor = [UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.text = [self freeAndTotalSpace];
    [view addSubview:label];
    return view;
    
}

- (NSString *)freeAndTotalSpace
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    
    NSString *total = [NSString stringWithFormat:@"总空间为:%0.1fG",([totalSpace doubleValue])/1024.0/1024.0/1024.0];
    NSString *free = [NSString stringWithFormat:@"可用空间:%0.1fG",([freeSpace doubleValue])/1024.0/1024.0/1024.0];
    return [NSString stringWithFormat:@"您的储存空间：%@ %@",total,free];
}



- (void)beginButtonClick
{
    
    for (NSString *url in [M3U8Manager sharedManager].allTaskArray) {
        
        NSMutableDictionary *dict = [[M3U8Manager sharedManager] getDictionaryFromDownloadDictionaryBasedUrl:url];
        [dict setObject:@"0" forKey:@"state"];
        [[M3U8Manager sharedManager].downloadDictionary setObject:dict forKey:url];
        
        
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:Nil waitUntilDone:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *url = [[M3U8Manager sharedManager] startTask];
        
        [[M3U8Manager sharedManager] OnClickStartDownload:url];
        [self performSelectorOnMainThread:@selector(beginTimer) withObject:Nil waitUntilDone:NO];
        
        
    });
}


- (void)beginTimer
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeNumber) userInfo:Nil repeats:YES];
}

- (void)changeNumber
{
    
    if ([self.dataArray count]) {
        
        NSInteger nowDownloadIndex = [[M3U8Manager sharedManager] getNowDownloadingIndex];
        DownloadCell *cell = (DownloadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nowDownloadIndex inSection:0]];
        [self changeCellui:cell isTimerRefresh:YES];
    }
}


- (void)stopButtonClick
{
    [_timer invalidate];
    _timer = Nil;
    for (NSString *url in [M3U8Manager sharedManager].allTaskArray) {
        NSMutableDictionary *dict = [[M3U8Manager sharedManager] getDictionaryFromDownloadDictionaryBasedUrl:url];
        [dict setObject:@"1" forKey:@"state"];
        [[M3U8Manager sharedManager].downloadDictionary setObject:dict forKey:url];
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:Nil waitUntilDone:NO];
    //    [self.tableView reloadData];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[M3U8Manager sharedManager] OnClickStopDownload:[M3U8Manager sharedManager].nowDownloading.url];
        [M3U8Manager sharedManager].nowDownloading = Nil;
    });
}


- (void)cleanButtonClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"真的要清除吗？" message:Nil delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self cleanMethod];
    }
}

- (void)cleanMethod
{
    [[M3U8Manager sharedManager].deleteArray addObjectsFromArray:[M3U8Manager sharedManager].allTaskArray];
    
    for (NSString *url in [M3U8Manager sharedManager].allTaskArray) {
        NSMutableDictionary *dict = [[M3U8Manager sharedManager] getDictionaryFromDownloadDictionaryBasedUrl:url];
        [dict setObject:@"1" forKey:@"state"];
    }
    [[M3U8Manager sharedManager].allTaskArray removeAllObjects];
    [self.tableView reloadData];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[M3U8Manager sharedManager] OnClickStopDownload:[M3U8Manager sharedManager].nowDownloading.url];
        [M3U8Manager sharedManager].nowDownloading = Nil;
        [M3U8Manager sharedManager].finishNumber = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBegin" object:Nil];
    });
    
}


- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, navigationView.frame.size.height + navigationView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - (navigationView.frame.size.height + navigationView.frame.origin.y + 15)) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(0, navigationView.frame.size.height + navigationView.frame.origin.y, 320, SCREEN_WIDTH - (navigationView.frame.size.height + navigationView.frame.origin.y + 15));
    }

    
    noImageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    noImageView.hidden = YES;
    
    noImageView.image = IMAGENAMED(@"nodownload");
    noImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:noImageView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    [self.view addSubview:self.tableView];
    UIView *tempFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 1)];
    tempFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tempFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (segmentController.selectedSegmentIndex == 0) {
        return [[DownloadFinishedManager shareManager].finishedArray count];
    }
    if (segmentController.selectedSegmentIndex == 1) {
        return [_dataArray count];
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (segmentController.selectedSegmentIndex == 0) {
        return [self cachedView];
    }
    if (segmentController.selectedSegmentIndex == 1) {
        return [self cachingView];
    }
    return Nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (segmentController.selectedSegmentIndex == 0) {
        NSString *url = [[DownloadFinishedManager shareManager].finishedArray objectAtIndex:indexPath.row];
        
        [[DownloadFinishedManager shareManager] deleteVideo:url];
        [tableView reloadData];
    }
    else
    {
        NSString *url = [[M3U8Manager sharedManager].allTaskArray objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            [M3U8Manager sharedManager].finishNumber = 0;
        }
        [[M3U8Manager sharedManager].deleteArray addObject:url];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBegin" object:Nil];
        [[M3U8Manager sharedManager].allTaskArray removeObject:url];
        //        [self addObjectToDataArray];
        [tableView reloadData];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LOCAL_LANGUAGE(@"Delete");
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentController.selectedSegmentIndex == 0) {
        return 65.0f;
    }
    if (segmentController.selectedSegmentIndex == 1) {
        return 76.0f;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"downloadCellName";
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[DownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (segmentController.selectedSegmentIndex == 0) {
        [cell stateFirstButtonClick];
        NSString *url = [[DownloadFinishedManager shareManager].finishedArray objectAtIndex:indexPath.row];
        NSDictionary *dict = [[DownloadFinishedManager shareManager].finishedInfoDictionary objectForKey:url];
        VideoInfoModel *item = [dict objectForKey:@"infoItem"];
        cell.titleLabel.text = item.name;
        cell.detailLabel.text = item.category;
        //        cell.totalCacheLabel.text = [dict objectForKey:@"totalCached"];
    }
    else {
        [cell stateSecondButtonClick];
        
        NSString *url = [[M3U8Manager sharedManager].allTaskArray objectAtIndex:indexPath.row];
        cell.url = url;
        NSDictionary *dict = [[M3U8Manager sharedManager].downloadDictionary objectForKey:url];
        VideoInfoModel *item = [dict objectForKey:@"infoItem"];
        cell.titleLabel.text = item.name;
        cell.detailLabel.text = item.category;
        
        if ([[[[M3U8Manager sharedManager].downloadDictionary objectForKey:url] objectForKey:@"state"] isEqualToString:@"1"]) {
            cell.beginStopButton.selected = NO;
        }
        else
        {
            cell.beginStopButton.selected = YES;
        }
        
        cell.beginStopButton.tag = BaseCellButtonTAG + indexPath.row;
        [cell.beginStopButton addTarget:self action:@selector(beginStopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self changeCellui:cell isTimerRefresh:NO];
        
    }
    
    return cell;

}



- (void)beginStopButtonClick:(UIButton *)button
{
    NSString *url = [[M3U8Manager sharedManager].allTaskArray objectAtIndex:(button.tag - BaseCellButtonTAG)];
    
    if (button.selected) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableDictionary *dict = [[M3U8Manager sharedManager] getDictionaryFromDownloadDictionaryBasedUrl:url];
            [dict setObject:@"1" forKey:@"state"];
            [[M3U8Manager sharedManager].downloadDictionary setObject:dict forKey:url];
            if ([url isEqualToString:[M3U8Manager sharedManager].nowDownloading.url]) {
                [M3U8Manager sharedManager].nowDownloading = Nil;
                NSString *uu = [[M3U8Manager sharedManager] startTask];
                [[M3U8Manager sharedManager] OnClickStartDownload:uu];
                [[M3U8Manager sharedManager] OnClickStopDownload:url];
                
                if ([M3U8Manager sharedManager].nowDownloading) {
                    [self beginTimer];
                }
            }
        });
        
    }
    else {
        if (!_timer) {
            [self beginTimer];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *url = [[M3U8Manager sharedManager].allTaskArray objectAtIndex:button.tag - BaseCellButtonTAG];
            NSMutableDictionary *dict = [[M3U8Manager sharedManager] getDictionaryFromDownloadDictionaryBasedUrl:url];
            [dict setObject:@"0" forKey:@"state"];
            [[M3U8Manager sharedManager].downloadDictionary setObject:dict forKey:url];
            [[M3U8Manager sharedManager] OnClickStartDownload:url];
        });
        
    }
    button.selected = !button.selected;
}


- (void)changeCellui:(DownloadCell *)cell isTimerRefresh:(BOOL)isTimerRefresh
{
    if (isTimerRefresh) {
        M3U8VideoDownloader *downloader = [M3U8Manager sharedManager].nowDownloading;
        if (cell.beginStopButton.selected) {
            CGFloat speed = [[M3U8Manager sharedManager] getSpeedFromUrl:downloader.url];
            cell.downloadStateLabel.text = [NSString stringWithFormat:@"正在下载:%@/S",[self changeSpeed:speed]];
        }
        else {
            cell.downloadStateLabel.text = @"已暂停";
        }
        CGFloat progress = ([[M3U8Manager sharedManager] getProgress:downloader.url]) / 100;
        if (progress * 100 > 100) {
            return;
        }
        if (progress * 100 >= [cell.progressLabel.text integerValue]) {
            cell.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress * 100)];
            cell.progressView.progress = progress;
        }
        
        
    }
    else
    {
        M3U8VideoDownloader *downloader = [[[M3U8Manager sharedManager].downloadDictionary objectForKey:cell.url] objectForKey:@"downloader"];
        if (cell.beginStopButton.selected) {
            CGFloat speed = [[M3U8Manager sharedManager] getSpeedFromUrl:downloader.url];
            cell.downloadStateLabel.text = [NSString stringWithFormat:@"正在下载:%@/S",[self changeSpeed:speed]];
        }
        else {
            cell.downloadStateLabel.text = @"已暂停";
        }
        CGFloat progress = ([[M3U8Manager sharedManager] getProgress:downloader.url]) / 100;
        if (progress * 100 >= [cell.progressLabel.text integerValue]) {
            cell.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress * 100)];
            cell.progressView.progress = progress;
        }
        
    }
}

- (NSString *)changeSpeed:(CGFloat)speed
{
    if (speed > 1024) {
        speed = speed / 1024;
        if (speed > 1024) {
            speed = speed / 1024;
            return [NSString stringWithFormat:@"%dMB",(int)speed];
        }
        else
        {
            return [NSString stringWithFormat:@"%dKB",(int)speed];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%dB",(int)speed];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentController.selectedSegmentIndex == 0) {
        NSString *url = [[DownloadFinishedManager shareManager].finishedArray objectAtIndex:indexPath.row];
        NSDictionary *dict = [[DownloadFinishedManager shareManager].finishedInfoDictionary objectForKey:url];
        
        VideoInfoModel *item = [dict objectForKey:@"infoItem"];
        ArticleModel *model = [[ArticleModel alloc] init];
        model.title = item.name;
        model.link = item.url;
        PlayViewController *browser = [[PlayViewController alloc] initWithUrlArray:@[item.url] isLocal:YES list:Nil item:model page:0 nowNumber:0 isCollect:0 category:@""];
        [self presentViewController:browser animated:YES completion:^{
            ;
        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
