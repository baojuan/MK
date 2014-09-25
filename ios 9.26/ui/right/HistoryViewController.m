//
//  HistoryViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "HistoryViewController.h"
#import "VideoiPhoneCell.h"
#import "ImageiPhoneCell.h"
#import "NewsiPhoneCell.h"
#import "GetVideoUrlAndPresentViewPlayViewController.h"
#import "ScanPictureViewController.h"
#import "WebViewController.h"
#import "PartCell.h"
#import "PartDetailViewController.h"
#import "SimplerWebViewController.h"
#import "ScanPictureForPartViewController.h"
#import "NewsDetailViewController.h"
#import "CommentViewControllerForPad.h"
#import "CommentListViewControllerForPad.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "NewsDetailViewControllerForPad.h"
#import "WebViewControllerForPad.h"






@interface HistoryViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *changyanId;

@end

@implementation HistoryViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    UISegmentedControl *segmentController;
    NSString *type;
    ShareView *shareView;
    __weak UIButton *goodButton;
    CommentListViewControllerForPad *controller;
    CommentViewControllerForPad *commentView;
    UIImageView *noImageView;
    NewsDetailViewControllerForPad *web;
    WebViewControllerForPad *webPad;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        [self getData];
        self.screenName = @"历史记录";


    }
    return self;
}

- (void)getData
{
    _dataArray = [[NSMutableArray alloc] init];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:HISTORY_USERDEFAULT]];
    for (NSString *string in appdelegate.itemArray) {
        if (![dict objectForKey:string]) {
            [_dataArray addObject:@[]];
        }
        else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dd in [dict objectForKey:string]) {
                [array addObject:[ModelExChangeDictionary dictionaryChangeToModel:dd]];
            }
            [_dataArray addObject:array];
        }
    }
}



- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:self.title rightButtonImage:IMAGENAMED(@"downloadDelete") ForPad:NO ForPadFullScreen:NO];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView.rightButton addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationView];
    
    segmentController = [[UISegmentedControl alloc] initWithItems:appdelegate.itemArray];
    segmentController.frame = RECT(10, 15 + navigationView.frame.size.height + navigationView.frame.origin.y, SCREEN_WIDTH - 20, 30);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        segmentController.frame = RECT(10, 15 + navigationView.frame.size.height + navigationView.frame.origin.y, 320 - 20, 30);
    }
    segmentController.backgroundColor = [UIColor clearColor];
    segmentController.tintColor = appdelegate.navigationColor;
    segmentController.selectedSegmentIndex = 0;
    type = [appdelegate.itemArray objectAtIndex:0];
    [segmentController addTarget:self action:@selector(reloadTableView) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentController];
    
    
}

- (void)reloadTableView
{
    if ([[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] count] == 0) {
        noImageView.hidden = NO;
        self.tableView.hidden = YES;
    }
    else {
        noImageView.hidden = YES;
        self.tableView.hidden = NO;
    }
    
    type = [appdelegate.itemArray objectAtIndex:segmentController.selectedSegmentIndex];
    [self.tableView reloadData];
    
    [MobClick event:[NSString stringWithFormat:@"正在查看历史%@",type]];


}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteBtnClicked
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否清除历史？" message:nil delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"是", nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:HISTORY_USERDEFAULT];
        for (int i = 0; i < [_dataArray count]; i++) {
            [_dataArray replaceObjectAtIndex:i withObject:@[]];
        }
        [self.tableView reloadData];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if ([[_dataArray objectAtIndex:0] count] == 0) {
                noImageView.hidden = NO;
                self.tableView.hidden = YES;
            }
            else {
                noImageView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            
        }

    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] count] == 0) {
        noImageView.hidden = NO;
        self.tableView.hidden = YES;
    }
    else {
        noImageView.hidden = YES;
        self.tableView.hidden = NO;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setTableViewProperty];
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
    [appdelegate.mainNavigationController.view addSubview:shareView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[_dataArray objectAtIndex:0] count] == 0) {
            noImageView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else {
            noImageView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        
    }

    
}

- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, segmentController.frame.size.height + segmentController.frame.origin.y + 15 - 10, SCREEN_WIDTH, SCREEN_HEIGHT - (segmentController.frame.size.height + segmentController.frame.origin.y + 15 - 10)) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(0, segmentController.frame.size.height + segmentController.frame.origin.y + 15 - 10, 320, SCREEN_WIDTH - (segmentController.frame.size.height + segmentController.frame.origin.y + 15 - 10));
    }
    noImageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    noImageView.hidden = YES;

    noImageView.image = IMAGENAMED(@"nohistory");
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
    return [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:LOCAL_LANGUAGE(@"video")]) {
        static NSString *cellName = @"videoForIphone";
        VideoiPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[VideoiPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName ForSmall:YES ForRight:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.title;
        cell.duringLabel.text = item.video_length;
        cell.playCountLabel.text = item.video_count;
        cell.dateLabel.text = item.date;
        [cell.videoImageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:IMAGENAMED(appdelegate.placeholderName) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image == nil) {
                return ;
            }
        }];
        
        return cell;
        
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"picture")]) {
        static NSString *cellName = @"imageForIphone";
        ImageiPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[ImageiPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName ForSmall:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.title;
        [cell.cellImageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:IMAGENAMED(appdelegate.placeholderName) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image == nil) {
                return ;
            }
        }];
        return cell;
        
        
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"news")]) {
        static NSString *cellName = @"newsForIphone";
        NewsiPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[NewsiPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName ForSmall:YES ForRight:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        if (item.detail.length == 0) {
            cell.titleLabel.numberOfLines = 2;
            CGRect rect = cell.titleLabel.frame;
            rect.size.height = 40;
            cell.titleLabel.frame = rect;
            cell.descriptionLabel.hidden = YES;
        }
        else {
            cell.titleLabel.numberOfLines = 1;
            CGRect rect = cell.titleLabel.frame;
            rect.size.height = 20;
            cell.titleLabel.frame = rect;
            cell.descriptionLabel.hidden = NO;
        }

        cell.titleLabel.text = item.title;
        cell.descriptionLabel.text = item.detail;
        cell.playCountLabel.text = item.video_count;
        cell.dateLabel.text = item.date;
        [cell.videoImageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:IMAGENAMED(appdelegate.placeholderName) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image == nil) {
                return ;
            }
        }];
        return cell;
        
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"part")]) {
        static NSString *cellName = @"partForIphone";
        PartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[PartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName ForBig:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        cell.delegate = self;
        if ([item.field1 integerValue] == 2) {
            cell.playImageView.hidden = NO;
        }
        else {
            cell.playImageView.hidden = YES;
        }

        [cell setTagWithButtons:(1000 + indexPath.row)];
        [cell insertIntoDataToPartCell:item];
        return cell;
    }

    return Nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:LOCAL_LANGUAGE(@"video")]) {
        return 80.0;
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"picture")]) {
        return 176.0;
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"news")]) {
        return 80.0;
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"part")]) {
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        CGFloat height = MIN([item.field3 floatValue] / 320 * 320, 800);
        height = MAX(height, 20);
        CGSize size = [item.title sizeWithFont:FONTSIZE(15) constrainedToSize:CGSizeMake(320 - 12 * 2, 500)];
        
        return height + 30 + size.height + 20 + 10 + 74 / 2.0;
    }

    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:LOCAL_LANGUAGE(@"video")]) {
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        
        GetVideoUrlAndPresentViewPlayViewController *play = [[GetVideoUrlAndPresentViewPlayViewController alloc] init];
        [play getItem:item nowNumber:0 page:0 listArray:nil isLocal:YES delegate:self category:nil];
        
                
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"picture")]) {
        ImageiPhoneCell *cell = (ImageiPhoneCell *)[tableView cellForRowAtIndexPath:indexPath];
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@/flashinterface/GetPicturesDetails.ashx?picID=%@",HOST,item.articleId];
        CGRect rect = [cell.cellImageView convertRect:cell.cellImageView.frame toView:[UIApplication sharedApplication].keyWindow];
        ScanPictureViewController *viewController = [[ScanPictureViewController alloc] initWithUrl:url rect:rect ArticleModel:item];
        [self presentViewController:viewController animated:YES completion:^{
            ;
        }];
        
        
        
        
    }
    if ([type isEqualToString:LOCAL_LANGUAGE(@"news")]) {
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        NSString *string = [NSString stringWithFormat:@"%@/m/detail/newsdetails.aspx?id=%@&frame=no",appdelegate.appUrl, item.articleId];
        if ([item.field1 isEqualToString:@"0"] || [item.field1 length] == 0) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                web = [[NewsDetailViewControllerForPad alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
                [appdelegate.tabBarController.view addSubview:web.view];
                
            }
            else {
                NewsDetailViewController *wweb = [[NewsDetailViewController alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
                [appdelegate.mainNavigationController pushViewController:wweb animated:YES];
            }
            
        }
        else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                webPad = [[WebViewControllerForPad alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
                [appdelegate.tabBarController.view addSubview:webPad.view];
                //            [appdelegate.mainNavigationController pushViewController:web animated:YES];
                
            }
            else {
                WebViewController *wweb = [[WebViewController alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
                [appdelegate.mainNavigationController pushViewController:wweb animated:YES];
            }
            
        }
        
        
    }
    
    if ([type isEqualToString:LOCAL_LANGUAGE(@"part")]) {
        ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:indexPath.row];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if ([item.field1 integerValue] == 10) {
                SimplerWebViewController *webview = [[SimplerWebViewController alloc] initWithUrl:item.field2 title:item.title];
                [appdelegate.mainNavigationController pushViewController:webview animated:YES];
                
            }
            else {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[item.field2 componentsSeparatedByString:@"^"]];
                [array removeObject:@""];
                ScanPictureForPartViewController *controller = [[ScanPictureForPartViewController alloc] initWithArray:array title:item.title];
                [appdelegate.mainNavigationController pushViewController:controller animated:YES];
            }
            
        }
        else {
//            PartDetailViewController *part = [[PartDetailViewController alloc] initWithArticle:item];
//            [appdelegate.mainNavigationController pushViewController:part animated:YES];
            if ([item.field1 integerValue] == 10) {
                SimplerWebViewController *webview = [[SimplerWebViewController alloc] initWithUrl:item.field2 title:item.title];
                [appdelegate.mainNavigationController pushViewController:webview animated:YES];
                
            }
            else {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[item.field2 componentsSeparatedByString:@"^"]];
                [array removeObject:@""];
                ScanPictureForPartViewController *controller = [[ScanPictureForPartViewController alloc] initWithArray:array title:item.title];
                [appdelegate.mainNavigationController pushViewController:controller animated:YES];
            }
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[FV10ViewController class] getTypeId]];
        });

        
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[PartCell class]]) {
        ((PartCell *)cell).backgroundImageView.image = nil;
        ((PartCell *)cell).iconImageView.image = nil;
        ((PartCell *)cell).placeholderImageView.hidden = NO;
        ((PartCell *)cell).picstateImageView.image = nil;
    }
    
}



- (void)partCellBottomButtonReportButtonClick:(UIButton *)button
{
    ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:button.tag - 1000];
    
    [self.view appearReportView];
}

- (void)partCellBottomButtonTalkClick:(UIButton *)button
{
    //    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 1000 inSection:0]];
    
    ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:button.tag - 1000];
    [self changyan:item];
    
    
    
}

- (void)partCellBottomButtonShareButtonClick:(UIButton *)button
{
    ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:button.tag - 1000];
    item.link = [NSString stringWithFormat:@"%@/m/detail/partdetails.aspx?id=%@",appdelegate.appUrl,item.articleId];
    [shareView getArticleModel:item];
    
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



- (void)partCellBottomButtonGoodButtonClick:(UIButton *)button
{
    goodButton = button;
    
    ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:button.tag - 1000];
    
    if (item.isgood) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"顶过了";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        [goodButton setTitle:item.goodNumber forState:UIControlStateNormal];
        return;
    }
    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/flashinterface/AdditionalOperation.ashx?typeid=%@&operation=2&targetid=%@&value=1",HOST,[FV10ViewController getTypeId],item.articleId];
    [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finishGoodButtonMethod:" failMethod:@"failGoodButtonMethod:"];
    
    
}

- (void)finishGoodButtonMethod:(NSData *)data
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"顶一下成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:goodButton.tag - 1000];
    item.goodNumber = [NSString stringWithFormat:@"%d",[goodButton.titleLabel.text intValue] + 1];
    item.isgood = YES;
    goodButton.titleLabel.text = [NSString stringWithFormat:@"%d",[goodButton.titleLabel.text intValue] + 1];
    
    //    [goodButton setTitle:item.goodNumber forState:UIControlStateNormal];
    
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
    ArticleModel *item = [[_dataArray objectAtIndex:segmentController.selectedSegmentIndex] objectAtIndex:button.tag - 1000];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:LOCAL_LANGUAGE(@"part")]];;
    
    NSDictionary *nowModel = [ModelExChangeDictionary modelChangeToDictionary:item];
    if (button.selected) {
        
        NSArray *aa = [NSArray arrayWithArray:array];
        for (NSDictionary *dd in aa) {
            if ([[dd objectForKey:@"articleId"] isEqualToString:item.articleId]) {
                [array removeObject:dd];
            }
        }
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"part")];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"取消收藏";
        [hud hide:YES afterDelay:1];
    }
    else {
        [array addObject:nowModel];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"收藏成功";
        [hud hide:YES afterDelay:1];
        [dict setObject:array forKey:LOCAL_LANGUAGE(@"part")];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    
    
}

#pragma mark - changyan

- (void)changyan:(ArticleModel *)item
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
         
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             controller = [[CommentListViewControllerForPad alloc] initWithArticle:item articleId:self.changyanId];
             [appdelegate.mainNavigationController.view addSubview:controller.view];
             return;
         }
         
         CommentListViewController *comment = [[CommentListViewController alloc] initWithArticle:item articleId:self.changyanId];
         [self presentViewController:comment animated:YES completion:^{
         }];
         
         
         
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
