//
//  DownloadViewController.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-4.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "DownloadViewController.h"
#import "SegmentButton.h"
#import "SegmentView.h"
#import "AppDelegate.h"
#import "DownloadCell.h"
#import "M3U8Manager.h"
#import "DownloadFinishedManager.h"
#import "NewPlayViewController.h"
#define BaseSegmentButtonTAG 100
#define BaseCellButtonTAG 1000

@interface DownloadViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) SegmentView *segView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) NSMutableArray *dataArray;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation DownloadViewController
{
    UIView *cachingTableHeadView;
    UIView *cachedTableHeadView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setHeadView
{
    _appDelegate = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBarHidden = YES;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44 + EXTRA_IOS7)];
    view.backgroundColor = _appDelegate.navigationColor;

    self.segView = [[SegmentView alloc] initWithFrame:CGRectMake((320 - 190) / 2.0, EXTRA_IOS7 + 2, 190, 44 - 4) buttonArray:[self setSegButtonArray]];
    [view addSubview:self.segView];
    
   
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15 - 5 - 3, (view.frame.size.height - 25) / 2.0 + EXTRA_IOS7/2.0, 19 + 6, 25);
    [backButton setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(toolbarClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backButton];
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(320 - 15 - 17 - 5 - 3, (view.frame.size.height - 18) / 2.0 + EXTRA_IOS7/2.0 - 3, 17 + 6, 18 + 6);
    [deleteButton setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteButton];


    [self.view addSubview:view];
}

- (NSArray *)setSegButtonArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    SegmentButton *button = [[SegmentButton alloc] initWithTextButtonTitle:@"完成缓存" Delegate:self Selector:@selector(segmentButtonClick:)];
    button.tag = BaseSegmentButtonTAG + 1;
    button.selected = YES;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"normalButtonSelected"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"buttonSelected"] forState:UIControlStateSelected];
    [array addObject:button];
    SegmentButton *button2 = [[SegmentButton alloc] initWithTextButtonTitle:@"正在缓存" Delegate:self Selector:@selector(segmentButtonClick:)];
    button2.tag = BaseSegmentButtonTAG + 2;
    button2.layer.cornerRadius = 5;
    button2.layer.masksToBounds = YES;
    [button2 setBackgroundImage:[UIImage imageNamed:@"normalButtonSelected"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"buttonSelected"] forState:UIControlStateSelected];
    [array addObject:button2];
    
    
    return array;
}

- (void)segmentButtonClick:(UIButton *)button
{
    self.tableView.editing = NO;
    for (UIButton *button in self.segView.buttonArray) {
        button.selected = NO;
    }
    button.selected = YES;
    [_tableView reloadData];
}

- (void)deleteBtnClicked:(UIButton *)button
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (void)toolbarClicked
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer *Swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toolbarClicked)];
    [self.view addGestureRecognizer:Swipe];
    
    [self setHeadView];
    [self addObjectToDataArray];
    [self setTableViewProperty];
    if (EXTRA_IOS7 > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:view];
    }

    cachingTableHeadView = [self cachingView];
    cachedTableHeadView = [self cachedView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinished) name:@"DownLoadFinished" object:Nil];

}

- (void)downloadFinished
{
    [self performSelectorOnMainThread:@selector(downloadFinishedForMainThread) withObject:Nil waitUntilDone:NO];
}

- (void)downloadFinishedForMainThread
{
    _dataArray = [M3U8Manager sharedManager].allTaskArray;
    [_tableView reloadData];
    if ([_dataArray count]) {
        [_timer invalidate];
        [self segmentButtonClick:[self.segView.buttonArray objectAtIndex:0]];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self beginTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


- (void)beginTimer
{
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


- (void)addObjectToDataArray
{
    _dataArray = [M3U8Manager sharedManager].allTaskArray;
}

- (void)setTableViewProperty
{
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + EXTRA_IOS7, SCREEN.width, SCREEN.height - 44 - EXTRA_IOS7) style:
                          UITableViewStylePlain];
        
        
        _tableView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
        //for adapter ios7 tableview
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
            self.edgesForExtendedLayout = UIRectEdgeBottom;
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UIButton *button = [self.segView.buttonArray objectAtIndex:0];
    if (button.selected) {
        return [[DownloadFinishedManager shareManager].finishedArray count];
    }
    else {
        return [_dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[DownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    UIButton *button = [self.segView.buttonArray objectAtIndex:0];
    if (button.selected) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = [self.segView.buttonArray objectAtIndex:0];
    if (button.selected) {
        NSString *url = [[DownloadFinishedManager shareManager].finishedArray objectAtIndex:indexPath.row];
        NSDictionary *dict = [[DownloadFinishedManager shareManager].finishedInfoDictionary objectForKey:url];
        VideoInfoModel *item = [dict objectForKey:@"infoItem"];
        NewPlayViewController *browser = [[NewPlayViewController alloc] initWithUrl:item.url isLocationPlay:YES name:item.name category:item.category dataArray:Nil];
        [self presentModalViewController:browser animated:YES];
    }
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Delete",nil);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = [self.segView.buttonArray objectAtIndex:0];
    if (button.selected) {
        return 65.0f;
    }
    else
        return 76.0f;

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = [self.segView.buttonArray objectAtIndex:0];

    if (button.selected) {
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button = [self.segView.buttonArray objectAtIndex:0];
    if (button.selected) {
        return cachedTableHeadView;
    }
    else
        return cachingTableHeadView;
}

- (UIView *)cachingView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"sectionButtonBackground"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 7, 67, 33);
    [button setTitle:@"全部开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    [button addTarget:self action:@selector(beginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[UIImage imageNamed:@"sectionButtonBackground"] forState:UIControlStateNormal];
    button2.frame = CGRectMake(170 / 2.0, 7, 67, 33);
    [button2 setTitle:@"全部暂停" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(stopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    [view addSubview:button2];
    
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setBackgroundImage:[UIImage imageNamed:@"sectionButtonBackground"] forState:UIControlStateNormal];
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
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



@end
