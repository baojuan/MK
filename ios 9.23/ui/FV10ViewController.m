//
//  FV10ViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "FV10ViewController.h"
#import "GDataXMLNode.h"
#import "ArticleModel.h"
#import "MJRefresh.h"
#import "PartCell.h"
#import "PartDetailViewController.h"
#import "PartCellBottomButtonClickMethod.h"
#import "SimplerWebViewController.h"
#import "ScanPictureForPartViewController.h"
#import "CommentViewControllerForPad.h"
#import "CommentListViewControllerForPad.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"

@interface FV10ViewController ()<UITableViewDataSource,UITableViewDelegate, MJRefreshBaseViewDelegate,PartCellBottomButtonClickMethod>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *changyanId;

@end

@implementation FV10ViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    ShareView *shareView;
    
    __weak UIButton *goodButton;

    
    CommentListViewControllerForPad *controller;
    CommentViewControllerForPad *commentView;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        _page = 1;
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}
+ (NSString *)getTypeId
{
    return @"6";
}

- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationView = [[MKNavigationView alloc] initWithTitle:self.navTitle leftButtonImage:IMAGENAMED(@"navleft") rightButtonImage:IMAGENAMED(@"navright") ForPad:YES ForPadFullScreen:NO];
        
    }
    
    else {
        navigationView = [[MKNavigationView alloc] initWithTitle:self.navTitle leftButtonImage:IMAGENAMED(@"navleft") rightButtonImage:IMAGENAMED(@"navright") ForPad:NO ForPadFullScreen:NO];
        
    }
    [self.view addSubview:navigationView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [navigationView.rightButton addTarget:self action:@selector(openLeftDrawer) forControlEvents:UIControlEventTouchUpInside];
        [navigationView.leftButton setImage:Nil forState:UIControlStateNormal];
        [navigationView.rightButton setImage:IMAGENAMED(@"navleft") forState:UIControlStateNormal];
    }
    else {
        [navigationView.leftButton addTarget:self action:@selector(openLeftDrawer) forControlEvents:UIControlEventTouchUpInside];
        [navigationView.rightButton addTarget:self action:@selector(openRightDrawer) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)openLeftDrawer
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [appdelegate addLeftViewToViewForPadAnimated:YES];
    }
    else {
        [appdelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
    }
}
- (void)openRightDrawer
{
    [appdelegate.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(appdelegate.padBackgroundImageName)];
    }
    else
    {
        if (appdelegate.navigationStyle) {
            self.view.backgroundColor = appdelegate.navigationBackgroundImageColor;
        }
        else {
            self.view.backgroundColor = appdelegate.navigationBackgroundColor;
        }
    }
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
        [appdelegate addLeftViewToViewForPadAnimated:YES Appear:YES];
        [appdelegate resetTabbarFrame];
    }
}

- (void)getCenterViewData:(NSString *)title
{
    if (self.page == 1)
    {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
    self.navTitle = title;
    navigationView.titleLabel.text = self.navTitle;
    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *string = [NSString stringWithFormat:@"%@/flashinterface/getpartbypage.ashx?page=%d&pagesize=10&classes=%@&sort=1",HOST,self.page,title];
    [request urlRequestWithGetUrl:string delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
}

- (void)finishMethod:(NSData *)data
{
    if (self.page == 1) {
        [_dataArray removeAllObjects];
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_dataArray];
    NSError *error;
    GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
    NSArray *employees = [pagedoc nodesForXPath:@"//article" error:NULL];
    BOOL flag = NO;
    
    for (GDataXMLElement *employe in employees) {
        ArticleModel *model = [[ArticleModel alloc] init];
        model.title = [[employe attributeForName:@"t"] stringValue];
        model.image = [[employe attributeForName:@"p"] stringValue];
        model.articleId = [[employe attributeForName:@"id"] stringValue];
        model.date = [[employe attributeForName:@"date"] stringValue];
        model.fromUrl = [[employe attributeForName:@"fromurl"] stringValue];
        model.fromUrlName = [[employe attributeForName:@"form"] stringValue];
        model.field1 = [[employe attributeForName:@"field1"] stringValue];
        model.field2 = [[employe attributeForName:@"field2"] stringValue];
        model.field3 = [[employe attributeForName:@"field3"] stringValue];
        model.goodNumber = [[employe attributeForName:@"ding"] stringValue];
        model.commentNumber = [[employe attributeForName:@"collect"] stringValue];
        [array addObject:model];
        flag = YES;
    }
    self.dataArray = array;
    
    
    if (!flag && [_footer isRefreshing])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已经到底啦！";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    [_header endRefreshing];
    [_footer endRefreshing];
    
    self.page ++;
}

- (void)failMethod:(NSError *)error
{
    MKLog(@"error :%@",error);
    [_header endRefreshing];
    [_footer endRefreshing];
    
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}



- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, navigationView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - navigationView.frame.size.height - 49) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.frame = RECT(60, 64, 470, SCREEN_WIDTH - 64);
    }
    else {
        self.tableView.backgroundColor = [UIColor clearColor];
        
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    UIView *tempFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 1)];
    tempFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tempFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"partForIphone";
    PartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cell = [[PartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName ForBig:YES];

        }
        else {
            cell = [[PartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName ForBig:NO];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ArticleModel *item = [_dataArray objectAtIndex:indexPath.row];
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

- (void)partCellBottomButtonReportButtonClick:(UIButton *)button
{
    ArticleModel *item = _dataArray[button.tag - 1000];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
    });

    [self.view appearReportView];
}

- (void)partCellBottomButtonTalkClick:(UIButton *)button
{
//    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 1000 inSection:0]];
    
    ArticleModel *item = _dataArray[button.tag - 1000];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
    });

    [self changyan:item];
    
    
    
}

- (void)partCellBottomButtonShareButtonClick:(UIButton *)button
{
    ArticleModel *item = [_dataArray objectAtIndex:button.tag - 1000];
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

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
    });

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
    
    ArticleModel *item = [_dataArray objectAtIndex:button.tag - 1000];

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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
    });

}

- (void)finishGoodButtonMethod:(NSData *)data
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"顶一下成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    ArticleModel *item = [_dataArray objectAtIndex:goodButton.tag - 1000];
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
    ArticleModel *item = [_dataArray objectAtIndex:button.tag - 1000];

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

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
    });

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *item = [_dataArray objectAtIndex:indexPath.row];
    CGSize size = [item.title sizeWithFont:FONTSIZE(15) constrainedToSize:CGSizeMake(320 - 12 * 2, 500)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat height = [item.field3 floatValue] / 320 * 470;
        height = MAX(height, 20);
        return height + 30 + size.height + 20 + 10 + 74 / 2.0;
    }
    else {
        CGFloat height = MIN([item.field3 floatValue] / 320 * 320, 800);
        height = MAX(height, 20);
        
        
        return height + 30 + 74 / 2.0 + size.height + 20 + 10;
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((PartCell *)cell).backgroundImageView.image = nil;
    ((PartCell *)cell).iconImageView.image = nil;
    ((PartCell *)cell).placeholderImageView.hidden = NO;
    ((PartCell *)cell).iconImageView.image = nil;
    ((PartCell *)cell).picstateImageView.image = nil;



}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *item = [_dataArray objectAtIndex:indexPath.row];

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
//        PartDetailViewController *part = [[PartDetailViewController alloc] initWithArticle:item];
//        [appdelegate.mainNavigationController pushViewController:part animated:YES];
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
        [ModelExChangeDictionary modelIntoUserDefaultToHistory:item Typeid:[[self class] getTypeId]];
    });

}

#pragma mark - refresh delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) {
        self.page = 1;
        [self getCenterViewData:self.navTitle];
    }
    else {
        [self getCenterViewData:self.navTitle];
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
