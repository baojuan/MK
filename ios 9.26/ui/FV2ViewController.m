//
//  FV2ViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "FV2ViewController.h"
#import "ImageiPhoneCell.h"
#import "GDataXMLNode.h"
#import "ArticleModel.h"
#import "ScanPictureView.h"
#import "MJRefresh.h"

#import "ScanPictureViewController.h"

@interface FV2ViewController ()<UITableViewDataSource,UITableViewDelegate, MJRefreshBaseViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation FV2ViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ScanPictureViewController *controller;
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
    return @"2";
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
    NSString *string = [NSString stringWithFormat:@"%@/flashinterface/getpicturesbypage.ashx?page=%d&pagesize=10&classes=%@&sort=1",HOST,self.page,title];
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
        model.image = [[employe attributeForName:@"url"] stringValue];
        model.articleId = [[employe attributeForName:@"id"] stringValue];
        model.date = [[employe attributeForName:@"date"] stringValue];
        model.isRead = [ModelExChangeDictionary modelIsInUserDefaultToRead:model.articleId Typeid:[[self class] getTypeId]];
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
    static NSString *cellName = @"imageForIphone";
    ImageiPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[ImageiPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ArticleModel *item = [_dataArray objectAtIndex:indexPath.row];
    if (item.isRead) {
        cell.titleLabel.textColor = RGBCOLOR(183, 183, 183);
    }
    else {
        cell.titleLabel.textColor = appdelegate.h1Color;
    }

    cell.titleLabel.text = item.title;
    [cell.cellImageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:IMAGENAMED(appdelegate.placeholderName) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image == nil) {
            return ;
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 176.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageiPhoneCell *cell = (ImageiPhoneCell *)[tableView cellForRowAtIndexPath:indexPath];
    ArticleModel *item = [_dataArray objectAtIndex:indexPath.row];
    item.isRead = YES;
    cell.titleLabel.textColor = RGBCOLOR(183, 183, 183);
    NSString *url = [NSString stringWithFormat:@"%@/flashinterface/GetPicturesDetails.ashx?picID=%@",HOST,item.articleId];
    CGRect rect = [cell.cellImageView convertRect:cell.cellImageView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    
//    ScanPictureView *view = [[ScanPictureView alloc] initWithUrl:url rect:rect ArticleModel:item];
//    [[UIApplication sharedApplication].keyWindow addSubview:view];
//    [UIView animateWithDuration:0.5 animations:^{
//        view.frame = RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        [view viewAnimationComplete];
//    }];
    
    
    ScanPictureViewController *viewController = [[ScanPictureViewController alloc] initWithUrl:url rect:rect ArticleModel:item];
//    [UIView animateWithDuration:0.5 animations:^{
//        view.frame = RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        [view viewAnimationComplete];
//    }];

    [self presentViewController:viewController animated:YES completion:^{
        ;
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ModelExChangeDictionary modelIntoUserDefaultToRead:item Typeid:[[self class] getTypeId]];
    });

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
