//
//  CommentListViewController.m
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#import "CommentViewController.h"
#import "GAI.h"

@interface CommentListViewController () <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ArticleModel *item;
@property (nonatomic, strong) NSString *articleId;
@end

@implementation CommentListViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    int page;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    UIImageView *noImageView;


}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isPresent = NO;
        appdelegate = APPDELEGATE;
        _dataArray = [[NSMutableArray alloc] init];
        page = 1;
        self.screenName = @"查看评论";

    }
    return self;
}

- (id)initWithArticle:(ArticleModel *)item articleId:(NSString *)articleId
{
    if (self = [super init]) {
        self.item = item;
        self.articleId = articleId;
        self.title = item.title;
    }
    return self;
}

- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:self.title rightButtonImage:IMAGENAMED(@"commentRightButton") ForPad:NO ForPadFullScreen:YES];
    [navigationView.rightButton setBackgroundImage:IMAGENAMED(@"commentRightButton") forState:UIControlStateNormal];
    [navigationView.rightButton setImage:Nil forState:UIControlStateNormal];
    [navigationView.rightButton setTitle:@"0" forState:UIControlStateNormal];
    [navigationView.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navigationView.rightButton.titleLabel.font = FONTSIZE(12);    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationView];
    [self getCommentNumber];
}

- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentFinished" object:nil];;
    }];
}

- (void)setBottomView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"commentBottom")];
    imageView.userInteractionEnabled = YES;
    imageView.frame = RECT(0, SCREEN_HEIGHT - 95 / 2.0, SCREEN_WIDTH, 95 / 2.0);
    if (IS_IOS8 && self.isPresent) {
        imageView.frame = RECT(0, SCREEN_WIDTH - 95 / 2.0, SCREEN_HEIGHT, 95 / 2.0);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(15, 13, imageView.frame.size.width - 26, 95 / 2.0 - 26)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageView.frame = RECT(0, SCREEN_WIDTH - 95 / 2.0, SCREEN_HEIGHT, 95 / 2.0);
        label.frame = RECT(50, 13, imageView.frame.size.width - 26, 95 / 2.0 - 26);
    }
    
    label.backgroundColor = [UIColor clearColor];
    label.text = @"我来说两句";
    label.textColor = RGBCOLOR(196, 196, 196);
    [imageView addSubview:label];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentButtonClick)];
    [imageView addGestureRecognizer:tap];
    
}

- (void)commentButtonClick
{
    CommentViewController * comment = [[CommentViewController alloc] initWithArticle:self.item articleId:self.articleId];
    [self presentViewController:comment animated:YES completion:^{
        ;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([_dataArray count] == 0) {
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
    
    
    [MobClick event:[NSString stringWithFormat:@"正在查看评论%@",self.item.title]];

    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setTableViewProperty];
    [self setBottomView];
    [self getCommentForPage:page];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentFinished) name:@"commentFinished" object:nil];
}

- (void)commentFinished
{
    [self postCommentNumber];
    [self refreshViewBeginRefreshing:_header];
}

- (void)postCommentNumber
{
    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/flashinterface/AdditionalOperation.ashx?typeid=6&operation=4&targetid=%@",HOST,self.item.articleId];
    [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finish:" failMethod:@"fail:"];
}

- (void)finish:(NSData *)data
{
    
}

- (void)fail:(NSError *)error
{
    
}

- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 95 / 2.0) style:UITableViewStylePlain];
    if (IS_IOS8 && self.isPresent) {
        self.tableView = [[UITableView alloc] initWithFrame:RECT(0, 64, SCREEN_HEIGHT, SCREEN_WIDTH - 64 - 95 / 2.0) style:UITableViewStylePlain];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(0, 64, SCREEN_HEIGHT, SCREEN_WIDTH - 64 - 95 / 2.0);
    }
    noImageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    noImageView.hidden = YES;

    noImageView.image = IMAGENAMED(@"nocomment");
    noImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:noImageView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
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
    if (refreshView == _header) {
        page = 1;
    }
    [self getCommentForPage:page];
    [self getCommentNumber];
}



#pragma mark - changyan

- (void)changyan
{
    [ChangyanSDK loadTopic:nil topicTitle:nil topicSourceID:self.item.articleId pageSize:@"0" hotSize:@"0" completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
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
     }];
}


- (void)getCommentNumber
{
    [ChangyanSDK getCommentCountTopicUrl:nil topicSourceID:Nil topicID:self.articleId completeBlock:^(CYStatusCode statusCode,NSString *responseStr)
     {
         [_footer endRefreshing];
         [_header endRefreshing];
         if (statusCode != CYSuccess) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             hud.removeFromSuperViewOnHide = YES;
             [hud hide:YES afterDelay:1];
             return ;
         }

         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [navigationView.rightButton setTitle:[[[[dict objectForKey:@"result"] objectForKey:self.articleId] objectForKey:@"comments"] stringValue] forState:UIControlStateNormal];
         
     }];
}


- (void)getCommentForPage:(int)p
{
    NSString *ss = [NSString stringWithFormat:@"%d",p];
    [ChangyanSDK getTopicComments:self.articleId pageSize:@"20" pageNo:ss completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        [_footer endRefreshing];
        [_header endRefreshing];
        if (statusCode != CYSuccess) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败";
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
        [_header endRefreshing];
        [_footer endRefreshing];
        if ([Array count] == 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"已经到底啦！";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            if ([_dataArray count] == 0) {
                noImageView.hidden = NO;
                self.tableView.hidden = YES;
            }
            else {
                noImageView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }

            return;
        }
        [_dataArray addObjectsFromArray:Array];
        page ++;
        [self.tableView reloadData];
        if ([_dataArray count] == 0) {
            noImageView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else {
            noImageView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
    }];
}


- (void)commendGood:(NSString *)commentId
{
    [ChangyanSDK commentAction:1 topicID:self.articleId commentID:commentId completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    else {
        return UIInterfaceOrientationPortrait;
    }
}

@end
