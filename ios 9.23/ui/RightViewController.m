//
//  RightViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-17.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "RightViewController.h"
#import "RightCell.h"

#import "SearchViewController.h"
#import "AppsViewController.h"
#import "QRViewController.h"
#import "LoveViewController.h"
#import "GoodViewController.h"
#import "HistoryViewController.h"
#import "TryViewController.h"
#import "DownloadViewController.h"
#import "AboutusViewController.h"
#import "AdviceViewController.h"
#import "CollectViewController.h"
#import "BlurView.h"

@interface RightViewController ()<UIAlertViewDelegate>

@end

@implementation RightViewController
{
    AppDelegate *appdelegate;
    NSArray *dataArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
    }
    return self;
}
- (UIView *)setTableViewHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(54, 0, SCREEN_WIDTH - 54, 135)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view.frame = RECT(0, 0, 320, 135);
    }
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT((view.frame.size.width - 54) / 2.0, 20, 54, 54)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.shadowOffset = SIZE(1, 1);
    imageView.image = IMAGENAMED(appdelegate.appIconName);
    [view addSubview:imageView];
    
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:RECT(0, imageView.frame.origin.y + imageView.frame.size.height + 10, view.frame.size.width, 15)];
    appNameLabel.backgroundColor = [UIColor clearColor];
    appNameLabel.font = FONTSIZE(15);
    appNameLabel.textColor = appdelegate.appNameColor;
    appNameLabel.text = appdelegate.appName;
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:appNameLabel];
    
    UILabel *slogonLabel = [[UILabel alloc] initWithFrame:RECT(0, appNameLabel.frame.origin.y + appNameLabel.frame.size.height + 10, view.frame.size.width, 15)];
    slogonLabel.backgroundColor = [UIColor clearColor];
    slogonLabel.font = FONTSIZE(10);
    slogonLabel.textColor = appdelegate.str_SolgonColor;
    slogonLabel.text = appdelegate.str_Solgon;
    slogonLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:slogonLabel];
    
    return view;
}

- (void)setType
{
    if ([appdelegate.haveType length] > 0) {
        dataArray = @[@"rightsearch",@"rightcollect",@"rightdownload",@"righthistory",@"rightdelete",@"rightadvise",@"rightaboutus"];
    }
    else {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            dataArray = @[@"rightApp",@"rightsearch",@"rightcollect",@"rightdownload",@"rightgood",@"rightlove",@"righthistory",@"righttry",@"rightdelete",@"rightadvise",@"rightaboutus"];
            
        }else{
            dataArray = @[@"rightApp",@"rightdownload",@"rightgood",@"rightlove",@"righttry",@"rightdelete",@"rightadvise",@"rightaboutus"];
        }
        
    }
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.navigationController.view.hidden = NO;
        self.navigationController.navigationBarHidden = YES;
        self.view.backgroundColor = [UIColor clearColor];
        
    }
    else {
        self.navigationController.navigationBarHidden = YES;
        self.view.backgroundColor = appdelegate.drawLeftAndRightViewBackgroundColor;
        
    }
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view.alpha = 0.7;
    }else{
        view.alpha = 0.0;
    }
    
    [self.view addSubview:view];
    BlurView *blurView = [[BlurView alloc] initWithFrame:RECT(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.view addSubview:blurView];
    }
    
    [self setTableViewProperty];
}

- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, 30, SCREEN_WIDTH - 54, SCREEN_HEIGHT - 30) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(0, 30, 320, SCREEN_WIDTH - 30);
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = [self setTableViewHeadView];
    self.tableView.separatorColor = RGBCOLOR(70, 72, 81);
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.tableView.separatorStyle = NO;
    }
    [self.view addSubview:self.tableView];
    UIView *tempFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 1)];
    tempFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tempFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"rightCell";
    RightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[RightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            UIView* separatorLineView = [[UIView alloc] init];
            
            
            separatorLineView.frame = CGRectMake(20, 49, 235, 1);
            separatorLineView.backgroundColor = [UIColor whiteColor];
            separatorLineView.alpha = 0.2;
            
            [cell.contentView addSubview:separatorLineView];
        }
    }
    NSString *name = [dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = LOCAL_LANGUAGE(name);
    cell.titleLabel.textColor = appdelegate.s1Color;
    cell.titleLabel.font = FONTSIZE(appdelegate.s1FontSize);
    cell.videoImageView.image = IMAGENAMED(name);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableViewSelectWhichViewControllerIndexPath:indexPath];
}


- (void)tableViewSelectWhichViewControllerIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController;
    NSString *name = [dataArray objectAtIndex:indexPath.row];
    if ([name isEqualToString:@"rightsearch"]) {
        viewController = [[SearchViewController alloc] init];
    }
    if ([name isEqualToString:@"rightApp"]) {
        viewController = [[AppsViewController alloc] init];
    }
    if ([name isEqualToString:@"rightvideo"]) {
        viewController = [[QRViewController alloc] init];
    }
    if ([name isEqualToString:@"righthistory"]) {
        viewController = [[HistoryViewController alloc] init];
    }
    if ([name isEqualToString:@"righttry"]) {
        viewController = [[TryViewController alloc] init];
        
        //        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rightgood"]) {
        //            viewController = [[TryViewController alloc] init];
        //        }
        //        else {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评分后可以使用此功能" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去评分", nil];
        //            alert.tag = 10000;
        //            alert.delegate = self;
        //            [alert show];
        //            return;
        //        }
    }
    if ([name isEqualToString:@"rightdownload"]) {
        viewController = [[DownloadViewController alloc] init];
    }
    if ([name isEqualToString:@"rightaboutus"]) {
        viewController = [[AboutusViewController alloc] init];
    }
    if ([name isEqualToString:@"rightadvise"]) {
        viewController = [[AdviceViewController alloc] init];
    }
    if ([name isEqualToString:@"rightcollect"]) {
        viewController = [[CollectViewController alloc] init];
    }
    viewController.title = LOCAL_LANGUAGE(name);
    
    
    if ([name isEqualToString:@"rightgood"]) {
        [appdelegate gotoStore];
        return;
    }
    
    
    if ([name isEqualToString:@"rightlove"])
    {
        [appdelegate ad];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载中";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
    }
    if ([name isEqualToString:@"rightdelete"]) {
        
        NSString *getCountStr;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSDirectoryEnumerator* e = [fileManager enumeratorAtPath:[paths objectAtIndex:0]];
            
            NSString *file;
            
            double totalSize = 0;
            while ((file = [e nextObject]))
            {
                NSDictionary *attributes = [e fileAttributes];
                
                NSNumber *fileSize = [attributes objectForKey:NSFileSize];
                
                totalSize += [fileSize longLongValue];
            }
            float getcount = totalSize/1000000;
            getCountStr = [NSString stringWithFormat: @"%4.2f", getcount];
            
            getCountStr = [NSString stringWithFormat:LOCAL_LANGUAGE(@"Cache %@"), getCountStr];
            
        }
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:getCountStr message:LOCAL_LANGUAGE(@"Is that's Clean UP") delegate:self cancelButtonTitle:LOCAL_LANGUAGE(@"Remind Me Later") otherButtonTitles:LOCAL_LANGUAGE(@"rightdelete"),nil];
        alert.delegate = self;
        [alert show];
        return;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [appdelegate.mainNavigationController pushViewController:viewController animated:YES];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            [appdelegate gotoStore];
        }
        return;
    }
    if(buttonIndex==1){
        //清数据库
        //        [self cleanDatas:@"VedioHistory"];
        //        [self cleanDatas:@"Vediodan"];
        //        [self cleanDatas:@"Vedio"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            
            NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Caches",[paths objectAtIndex:0]];
            
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *filename;
            while ((filename = [e nextObject])) {
                
                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            }
            
        }
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
