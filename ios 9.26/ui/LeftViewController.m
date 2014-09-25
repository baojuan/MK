//
//  LeftViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-17.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftModel.h"
#import "ConfirmViewController.h"
#import "BlurView.h"
#import "LeftBottomView.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "CollectViewController.h"
#import "HistoryViewController.h"


static int count = 0;

@interface LeftViewController ()<UITabBarControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) LeftBottomView *leftBottomView;
@end

@implementation LeftViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    
    
    BOOL isModify;
    BOOL isFirst;
    UIImageView * avatarImageView;
    UILabel *userLabel;
    BOOL isLogin;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        appdelegate.tabBarController.delegate = self;
        _dataArray = [[NSMutableArray alloc] init];
        isFirst = YES;
        isLogin = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarDidSelectViewController:) name:TABBAR_SELECT object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:@"GetUserInfo" object:nil];
        
    }
    return self;
}

- (void)tabbarDidSelectViewController:(NSNotification *)notification
{
    UIViewController *controller = notification.object;
    [self getDataArrayViewControllerTypeId:controller];
}


//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    UIViewController * Controller = ((UINavigationController *)viewController).topViewController;
//    [self getDataArrayViewControllerTypeId:Controller];
//}

- (NSString *)getTypeId:(UIViewController *)Controller
{
    NSString *typeId = @"";
    
    if ([Controller isKindOfClass:[FV1ViewController class]]) {
        typeId = [FV1ViewController getTypeId];
    }
    if ([Controller isKindOfClass:[FV2ViewController class]]) {
        typeId = [FV2ViewController getTypeId];
    }
    if ([Controller isKindOfClass:[FV3ViewController class]]) {
        typeId = [FV3ViewController getTypeId];
    }
    if ([Controller isKindOfClass:[FV4ViewController class]]) {
        typeId = [FV4ViewController getTypeId];
    }
    if ([Controller isKindOfClass:[FV5ViewController class]]) {
        typeId = [FV5ViewController getTypeId];
    }
    if ([Controller isKindOfClass:[FV10ViewController class]]) {
        typeId = [FV10ViewController getTypeId];
    }
    return typeId;
}

- (void)getDataArrayViewControllerTypeId:(UIViewController *)Controller
{
    NSString *typeId = @"";
    typeId = [self getTypeId:Controller];
    if ([self.typeId isEqualToString:typeId]) {
        return;
    }
    self.typeId = typeId;
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    self.dataArray = [self readDataFromDB:typeId];
    if ([self.dataArray count] > 0) {
        [self makeCenterViewGetDataFirst:self.dataArray[0] typeId:self.typeId];
    }
    
    
    //NSLog(@"不需要这里吧 %@",appdelegate.fv10.navTitle);
    //    });
}



- (NSMutableArray *)readDataFromDB:(NSString *)typeId
{
    if ([typeId isEqualToString:@""]) {
        return Nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[DataBase sharedDataBase]readLeftTableFromTypeId:typeId]];
    return array;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dataArray];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:Nil waitUntilDone:NO];
}

- (void)setHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, 64)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view.frame = RECT(0, 0, 320, 64);
    }
    view.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:view];
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.backgroundColor = appdelegate.leftButtonBackground;
    [self.leftButton setTitle:LOCAL_LANGUAGE(@"subscribe") forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = FONTSIZE(12);
    self.leftButton.frame = RECT(20, 20 + (44 - 28) / 2.0, 49, 28);
    [view addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setBackgroundImage:IMAGENAMED(@"leftedit") forState:UIControlStateNormal];
    [self.rightButton setTitle:LOCAL_LANGUAGE(@"edit") forState:UIControlStateNormal];
    [self.rightButton setTitle:LOCAL_LANGUAGE(@"confirm") forState:UIControlStateSelected];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = FONTSIZE(12);
    
    self.rightButton.frame = RECT(view.frame.size.width - 54 - 20 - 49, 20 + (44 - 28) / 2.0, 49, 28);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.rightButton.frame = RECT(view.frame.size.width - 20 - 49, 20 + (44 - 28) / 2.0, 49, 28);
    }
    [view addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)leftButtonClick
{
    ConfirmViewController *confirmViewController = [[ConfirmViewController alloc] initWithTypeId:self.typeId];
    confirmViewController.title = LOCAL_LANGUAGE(@"Management");
    confirmViewController.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController pushViewController:confirmViewController animated:YES];
    }
    else {
        [appdelegate.mainNavigationController pushViewController:confirmViewController animated:YES];
    }
}

- (void)rightButtonClick
{
    if (self.rightButton.selected) {
        self.tableView.editing = NO;
        if (isModify) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[DataBase sharedDataBase] updateDataIntoLeftTable:_dataArray];
            });
            isModify = NO;
        }
    }
    else {
        self.tableView.editing = YES;
    }
    self.rightButton.selected = !self.rightButton.selected;
    [self.leftBottomView sortButtonState:self.rightButton.selected];
    
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
    [self setHeadView];
    [self setTableViewProperty];
    [self firstDataArray];
    [self setBottomView];
    
    //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.selected = YES;
    //    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    //        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)setBottomView
{
    self.leftBottomView = [[LeftBottomView alloc] init];
    self.leftBottomView.delegate = self;
    [self.view addSubview:self.leftBottomView];
}

- (void)historyButtonClick:(UIButton *)button
{
    HistoryViewController *viewController = [[HistoryViewController alloc] init];
    viewController.title = @"历史记录";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [appdelegate.mainNavigationController pushViewController:viewController animated:YES];
    }
    
}

- (void)collectionButtonClick:(UIButton *)button
{
    CollectViewController *viewController = [[CollectViewController alloc] init];
    viewController.title = @"我的收藏";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [appdelegate.mainNavigationController pushViewController:viewController animated:YES];
    }
    
}


- (void)subscriptionButtonClick:(UIButton *)button
{
    [self leftButtonClick];
}


- (void)sortButtonClick:(UIButton *)button
{
    [self rightButtonClick];
}


- (void)searchButtonClick:(UIButton *)button
{
    SearchViewController *viewController = [[SearchViewController alloc] init];
    viewController.title = @"我的搜索";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [appdelegate.mainNavigationController pushViewController:viewController animated:YES];
    }
    
}


- (void)firstDataArray
{
    __weak UIViewController * Controller = ((UINavigationController *)[appdelegate.tabBarController.viewControllers objectAtIndex:0]).topViewController;
    [self getDataArrayViewControllerTypeId:Controller];
    
}

- (void)firstGetDataArray:(NSDictionary *)dict
{
    
    if (dict) {
        UIViewController *viewController = appdelegate.tabBarController.viewControllers[0];
        __weak UIViewController * Controller = ((UINavigationController *)viewController).topViewController;
        NSString *typeId = [self getTypeId:Controller];
        [self makeCenterViewGetData:[dict[typeId] objectAtIndex:0] typeId:typeId];
    }
    else {
        for (UIViewController *viewController in appdelegate.tabBarController.viewControllers) {
            __weak UIViewController * Controller = ((UINavigationController *)viewController).topViewController;
            NSString *typeId = [self getTypeId:Controller];
            NSArray *array = [self readDataFromDB:typeId];
            if ([array count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据发生异常，请重新启动" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            
            [self makeCenterViewGetData:[array objectAtIndex:0] typeId:typeId];
        }
        
    }
}

- (UIView *)setTableViewHeadView
{
    if ([appdelegate.haveType length] != 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH - 54 - 8, 70)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    avatarImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"login")];
    avatarImageView.userInteractionEnabled = NO;
    avatarImageView.frame = RECT(10, 8, avatarImageView.frame.size.width, avatarImageView.frame.size.height);
    avatarImageView.layer.cornerRadius = 25;
    avatarImageView.layer.masksToBounds = YES;
    [view addSubview:avatarImageView];
    userLabel = [[UILabel alloc] initWithFrame:RECT(avatarImageView.frame.size.width + avatarImageView.frame.origin.x + 10, 0, view.frame.size.width - avatarImageView.frame.size.width - avatarImageView.frame.origin.x, view.frame.size.height)];
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.font = FONTSIZE(17);
    userLabel.userInteractionEnabled = NO;
    userLabel.textColor = [UIColor whiteColor];
    [view addSubview:userLabel];
    userLabel.text = @"点击登录";
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeaderViewClick)];
    [view addGestureRecognizer:tap];
    return view;
    
}

- (void)getUserInfo
{
    [ChangyanSDK getUserInfoCompleteBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (dict[@"nickname"] == nil) {
            isLogin = NO;
        }
        else {
            userLabel.text = dict[@"nickname"];
            [avatarImageView setImageWithURL:dict[@"img_url"]];
            isLogin = YES;
        }
        
    }];
}


- (void)tableHeaderViewClick
{
    if (isLogin) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        [alert show];
    }
    else {
        //
        LoginViewController *login = [[LoginViewController alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.navigationController pushViewController:login animated:YES];
        }
        else {
            [appdelegate.mainNavigationController pushViewController:login animated:YES];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self logout];
    }
}

- (void)logout
{
    [ChangyanSDK logout];
    avatarImageView.image = IMAGENAMED(@"login");
    userLabel.text = @"点击登录";
    isLogin = NO;
    
    
}

- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(4, 20, SCREEN_WIDTH - 54 - 8, SCREEN_HEIGHT - 20 - 49) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(4, 20, 320 - 8, SCREEN_WIDTH - 64);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    self.tableView.separatorColor = RGBCOLOR(70, 72, 81);
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.tableView.separatorStyle = NO;
    }
    
    self.tableView.tableHeaderView = [self setTableViewHeadView];
    [self.view addSubview:self.tableView];
    
    UIView *tempFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 1)];
    tempFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tempFooterView;
    [self getUserInfo];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"leftCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.backgroundColor = [UIColor clearColor];
        
        /*
         UIView *selectView = [[UIView alloc] initWithFrame:RECT(0, 0,5, 44)];
         selectView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255.0 alpha:0.2];
         selectView.alpha = 0.1;
         */
        
        
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            UIView* separatorLineView = [[UIView alloc] init];
            
            
            separatorLineView.frame = CGRectMake(10, 49, 240, 1);
            separatorLineView.backgroundColor = [UIColor whiteColor];
            separatorLineView.alpha = 0.2;
            
            [cell.contentView addSubview:separatorLineView];
            
            UIView *selectView = [[UIView alloc] init];
            selectView.backgroundColor = [UIColor clearColor];
            
            CALayer *sublayer = [CALayer layer];
            sublayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
            sublayer.frame = CGRectMake(0, 2,2, 47);
            
            CALayer *sublayerBg = [CALayer layer];
            sublayerBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                sublayerBg.frame = CGRectMake(10, 50, 240, 0.5);
            }else{
                sublayerBg.frame = CGRectMake(10, 47, 295, 0.5);
            }
            
            [selectView.layer addSublayer:sublayer];
            [selectView.layer addSublayer:sublayerBg];
            
            cell.selectedBackgroundView = selectView;
        }else{
            UIView *selectView = [[UIView alloc] initWithFrame:RECT(0, 0,5, 44)];
            selectView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255.0 alpha:0.2];
            selectView.alpha = 0.1;
            cell.selectedBackgroundView = selectView;
        }
        
    }
    LeftModel *item = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = appdelegate.s1Color;
    cell.textLabel.font = FONTSIZE(appdelegate.s1FontSize);
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (!self.rightButton.selected) {
//        return YES;
//    }
//    return NO;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (!self.rightButton.selected) {
//        return YES;
//    }
//    return NO;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LeftModel *model = [_dataArray objectAtIndex:indexPath.row];
        [[DataBase sharedDataBase] deleteDataIntoLeftTable:model];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"view"
                                            action:@"正在移动左侧列表"
                                             label:@"正在移动左侧列表"
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
    
    [MobClick event:[NSString stringWithFormat:@"正在移动左侧列表"]];
    
    
    if (destinationIndexPath == sourceIndexPath) {
        return;
    }
    [_dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    isModify = YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LOCAL_LANGUAGE(@"cancelConfirm");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftModel *item = [_dataArray objectAtIndex:indexPath.row];
    [self makeCenterViewGetData:item typeId:self.typeId];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
    }
    else {
        [appdelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            ;
        }];
    }
    
}

- (void)makeCenterViewGetDataFirst:(LeftModel *)item typeId:(NSString *)typeId
{
    
    switch ([typeId integerValue]) {
        case 1:
            
            if (!appdelegate.fv3.navTitle) {
                appdelegate.fv3.page = 1;
                [appdelegate.fv3 getCenterViewData:item.title];
            }
            
            break;
        case 2:
            if (!appdelegate.fv2.navTitle) {
                appdelegate.fv2.page = 1;
                [appdelegate.fv2 getCenterViewData:item.title];
            }
            
            break;
        case 4:
            if (!appdelegate.fv1.navTitle) {
                appdelegate.fv1.page = 1;
                [appdelegate.fv1 getCenterViewData:item.title];
            }
            
            break;
        case 6:
            if (!appdelegate.fv10.navTitle) {
                appdelegate.fv10.page = 1;
                [appdelegate.fv10 getCenterViewData:item.title];
            }
            
            break;
        case 10:
            if (!appdelegate.fv4.navTitle) {
                
                appdelegate.fv4.navTitle = item.title;
                [appdelegate.fv4 getCenterViewUrl:item.link];
            }
            
            break;
        case 11:
            if (!appdelegate.fv5.navTitle) {
                appdelegate.fv5.navTitle = item.title;
                [appdelegate.fv5 getCenterViewUrl:item.link];
            }
            
            break;
        default:
            break;
    }
    
}
- (void)makeCenterViewGetData:(LeftModel *)item typeId:(NSString *)typeId
{
    
    switch ([typeId integerValue]) {
        case 1:
            appdelegate.fv3.page = 1;
            [appdelegate.fv3 getCenterViewData:item.title];
            break;
        case 2:
            appdelegate.fv2.page = 1;
            [appdelegate.fv2 getCenterViewData:item.title];
            break;
        case 4:
            appdelegate.fv1.page = 1;
            [appdelegate.fv1 getCenterViewData:item.title];
            break;
        case 6:
            appdelegate.fv10.page = 1;
            [appdelegate.fv10 getCenterViewData:item.title];
            break;
        case 10:
            appdelegate.fv4.navTitle = item.title;
            [appdelegate.fv4 getCenterViewUrl:item.link];
            break;
        case 11:
            appdelegate.fv5.navTitle = item.title;
            [appdelegate.fv5 getCenterViewUrl:item.link];
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
