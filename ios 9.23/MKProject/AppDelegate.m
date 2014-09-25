//
//  AppDelegate.m
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "AppDelegate.h"
#import "GDataXMLNode.h"
#import "LeftModel.h"

#import "DDTTYLogger.h"
#import "M3U8Manager.h"
#define kPathDownload @"Downloads"
#import "GAIDictionaryBuilder.h"
#import "Reachability.h"
#import "BPush.h"

#import "GetVideoUrlAndPresentViewPlayViewController.h"
#import "ScanPictureViewController.h"
#import "WebViewController.h"
#import "PartDetailViewController.h"
#import "SimplerWebViewController.h"
#import "ScanPictureForPartViewController.h"

#import "ArticleModel.h"

static NSString *const kTrackingId = @"UA-48608884-3";   //14 快播电影  13 电竞梦想  12 合集系列
static NSString *const DeviceToken = @"UA-48608884-3";

@implementation AppDelegate
{
    BOOL leftAddForPad;
    BOOL rightAddForPad;
    BOOL searchAddForPad;
    
    BOOL enterToBackground;
}
/* */



- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    
    
    
    NSLog(@"res= %@", [data objectForKey:@"app_id"]);
    
    
    NSString* getURLsr = self.appUrl;
    
    //NSString* getURLsrful = [getURLsr stringByAppendingString:@"/GetPicturesByPage.ashx?page=%@&pagesize=%@&classes=%@"];
    
    NSString* getURLsrful = [getURLsr stringByAppendingString:@"/addBaiduCloudInfo.ashx?TopicID=%@&AppId=%@&ChannelId=%@&UserId=%@&DeviceToken=%@&TypeId=1"];
    
    NSString* CallWebServer = [[NSString alloc] initWithFormat:getURLsrful,self.topicId,[data objectForKey:@"app_id"],[data objectForKey:@"channel_id"],[data objectForKey:@"user_id"],_DeviceToken];
    
    NSLog(CallWebServer);
    
    
    CallWebServer = [CallWebServer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    __block __typeof__(self) blockSelf = self;
    __block ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:CallWebServer]];
    [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    
    [request setCompletionBlock:^
     {
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
         
         
     }];
    
    [request setFailedBlock:^
     {
         [blockSelf handleError:[request error]];
     }];
    
}
- (void)handleError:(NSError*)error
{
    NSLog(@"网络连接错误");
}
-(void)callNotifi:(NSString *)title alertType:(NSString *)title2 alertIds:(NSString *)title3{
    
    NSString *alertName = title;
    
    NSString *alertType = title2;
    NSString *alertIds = title3;
    ArticleModel *item = [[ArticleModel alloc] init];
    item.articleId = alertIds;
    item.title = alertName;
    CGRect rect;
    NSString *url;
    if ([alertType isEqualToString:@"4"]) {
        GetVideoUrlAndPresentViewPlayViewController *play = [[GetVideoUrlAndPresentViewPlayViewController alloc] init];
        [play getItem:item nowNumber:0 page:0 listArray:nil isLocal:YES delegate:self.mainNavigationController category:nil];
    }
    if ([alertType isEqualToString:@"2"]) {
        url = [NSString stringWithFormat:@"%@/flashinterface/GetPicturesDetails.ashx?picID=%@",HOST,item.articleId];
        ScanPictureViewController *viewController = [[ScanPictureViewController alloc] initWithUrl:url rect:rect ArticleModel:item];
        [self.mainNavigationController presentViewController:viewController animated:YES completion:^{
            ;
        }];
    }
    if ([alertType isEqualToString:@"1"]) {
        NSString *string = [NSString stringWithFormat:@"%@/m/detail/newsdetails.aspx?id=%@&frame=no",self.appUrl, item.articleId];
        WebViewController *web = [[WebViewController alloc] initWithUrl:string articleId:item.articleId title:item.title ArticleModel:item];
        [self.mainNavigationController pushViewController:web animated:YES];
        
    }
    if ([alertType isEqualToString:@"10"]) {
        SimplerWebViewController *webview = [[SimplerWebViewController alloc] initWithUrl:item.articleId title:item.title];
        [self.mainNavigationController pushViewController:webview animated:YES];
    }
    
    
    //[alertType isEqualToString:@"4"]
};

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    
    
    if (enterToBackground == YES) {
        
        NSString *alertName = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSString *alertType = [userInfo objectForKey:@"type"];
        NSString *alertIds = [userInfo objectForKey:@"ids"];
        
        //[userInfo objectForKey:@"ids"];
        
        [self callNotifi:alertName alertType:alertType alertIds:alertIds];
        
        [application setApplicationIconBadgeNumber:0];
        
        
        NSLog(@"来到了这里 类型: %@ IDS:%@ ",alertType,alertIds);
        
        
        [BPush handleNotification:userInfo];
        
        //self.viewController.textView.text = [self.viewController.textView.text stringByAppendingFormat:@"Receive notification:\n%@", [userInfo JSONString]];
        
        enterToBackground = NO;
    }
    
    
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",newDeviceToken];
    
    
    //modify the token, remove the  "<, >"
    
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
    
    self.DeviceToken = deviceTokenStr;
    
    //使用BPush推送到百度服务器
    
    [BPush registerDeviceToken: newDeviceToken];
    [BPush bindChannel];
}


- (void)settingSth//cloud
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL *pathURL= [NSURL fileURLWithPath:documentsDirectory];
    [self addSkipBackupAttributeToItemAtURL:pathURL];
}


- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    double currSysVer =[[[UIDevice currentDevice] systemVersion] doubleValue];
    if (currSysVer>=5.1) {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    } else {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0); return result == 0;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        
        [BPush setupChannel:launchOptions];
        [BPush setDelegate:self];
        
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
        
        
        enterToBackground = NO;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self settingSth];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Override point for customization after application launch.
        self.window.backgroundColor = [UIColor whiteColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self adstage];
        [ChangyanSDK registerApp:@"cyr1QbB5a"];
        [self beginHttpServer];
        [self buildSetting];
        [self getLeftData];
        int aa = 0;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"openCount"]) {
            aa = 0;
        }
        else {
            aa = [[[NSUserDefaults standardUserDefaults] objectForKey:@"openCount"] intValue];
        }
        
        NSNumber *number = [NSNumber numberWithInt:(++aa)];
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"openCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        //[self.window makeKeyAndVisible];
        
        if(launchOptions != nil){
            
            NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            NSString *alertName = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            
            NSString *alertType = [userInfo objectForKey:@"type"];
            NSString *alertIds = [userInfo objectForKey:@"ids"];
            [self callNotifi:alertName alertType:alertType alertIds:alertIds];
            
            
        }else{
            
        }
        
        
        
        return YES;
    }
    
    
    - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        if (alertView.tag == 10000) {
            if (buttonIndex == 1) {
                [self gotoStore];
            }
            return;
        }
    }
    
    
    
    - (void)adstage
    {
        [[MobiSageManager getInstance]setPublisherID:MS_Test_PublishID deployChannel:@"mobisage"];
        
        [[MobiSageManager getInstance] setEnableLocation:NO];//关闭地理位置获取
        
        NSString* imgName = @"Default";
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            imgName = @"Default-Landscape";
        } else {
            if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
                imgName = @"Default-568h";
            }
        }
        
        UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
        
        BOOL  isTRSplash = YES;
        
        if (isTRSplash) {
            self.mobiSageSplash = [[MobiSageRTSplash alloc] initWithOrientation:MS_Orientation_Portrait
                                                                     background:bgColor
                                                                   withDelegate:self
                                                                      slotToken:MS_Test_SlotToken_Splash];
        }else{
            self.mobiSageSplash = [[MobiSageSplash alloc] initWithOrientation:MS_Orientation_Portrait
                                                                   background:bgColor
                                                                 withDelegate:self
                                                                    slotToken:MS_Test_SlotToken_Splash];
        }
        [self.mobiSageSplash startSplash];
        
        
    }
    
    
    /**
     *  Splash展示成功
     *  @param adSplash
     */
    //开屏广告展示成功时,回调此方法
    - (void)mobiSageSplashSuccessToShow:(MobiSageSplash*)adSplash{
        NSLog(@"MobiSageSplashSuccessToShow");
    }
    
    /**
     *  Splash展示失败
     *  @param adSplash
     */
    //开屏广告展示失败时,回调此方法,在此回调方法中,需释放广告,且在此时弹出应用的界面
    - (void)mobiSageSplashFaildToRequest:(MobiSageSplash*)adSplash withError:(NSError *)error{
        [self.window makeKeyAndVisible];
        NSLog(@"MobiSageSplashFaildToRequest error = %@", [error description]);
        self.mobiSageSplash = nil;
    }
    
    /**
     *  Splash被关闭
     *  @param adSplash
     */
    //开屏广告失败时,回调此方法,需释放广告,且在此时弹出应用的界面
    - (void)mobiSageSplashClose:(MobiSageSplash*)adSplash{
        [self.window makeKeyAndVisible];
        NSLog(@"SplashClose");
        self.mobiSageSplash = nil;
    }
    
    
    - (void)beginHttpServer;
    {
        //启动一个轻量级得httpserver
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        _httpServer=[[HTTPServer alloc]init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:12345];
        
        //设定存储路径/Document/Downloads
//        NSString *pathPrefix=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *pathPrefix=[NSHomeDirectory() stringByAppendingPathComponent:@"library"];

        NSString *filePath=[pathPrefix stringByAppendingPathComponent:kPathDownload];
        [_httpServer setDocumentRoot:filePath];
        
        NSError *error;
        if(![_httpServer start:&error]){
            NSLog(@"Errro starting HTTP Server: %@",error);
        }
    }
    
    
    - (void)setWindowRootViewController
    {
        self.mainNavigationController = [[MainNavigationViewController alloc] initWithRootViewController:self.drawerController];
        self.mainNavigationController.navigationBarHidden = YES;
        
        self.window.rootViewController = self.mainNavigationController;
    }
    
    - (void)buildSetting
    {
        [WXApi registerApp:@"wxa269806e5c1fa80f"];
        [WeiboSDK registerApp:@"3593672030"];
        
        [GAI sharedInstance].dispatchInterval = 20;
        [GAI sharedInstance].trackUncaughtExceptions = NO;
        self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
        
        [MobClick startWithAppkey:@"5395575556240b2eff158bfe" reportPolicy:BATCH channelId:@"app store"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT]) {
            [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:COLLECT_USERDEFAULT];
        }
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:READ_USERDEFAULT]) {
            [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:READ_USERDEFAULT];
        }
        
        //quick替换 序列
        self.appUrl = @"http://yp.hbook.us";
        self.appName = @"YP吐槽视频";
        self.str_Solgon = @"不要这么认真~";
        self.appNameColor = [UIColor colorWithHexValue:0xffffff];
        self.str_SolgonColor = [UIColor colorWithHexValue:0xdcdcdc];
        self.appstoreId = @"906446150";
        self.topicId = @"51";
        self.leftButtonBackground = [UIColor colorWithHexValue:0x202b3a];
        self.navigationColor = [UIColor colorWithHexValue:0x202b3a];
        
        
        self.navigationStyle = 0;
        self.navigationTitleColor = [UIColor colorWithHexValue:0xffffff];
        self.navigationBackgroundImageColor = [UIColor colorWithPatternImage:IMAGENAMED(@"NavbackgroundImage")];
        self.navigationBackgroundColor = [UIColor colorWithHexValue:0xffffff];
        self.navigationTitleFontSize = 15;
        self.drawLeftAndRightViewBackgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(@"leftBack")];
        
        self.h1Color = RGBCOLOR(79, 79, 79);
        self.h1FontSize = 15;
        self.descriptionColor = RGBCOLOR(121, 121, 121);
        self.descriptionFontSize = 12;
        
        self.s1Color = [UIColor colorWithHexValue:0xd9d9d9];
        self.s1FontSize = 14;
        self.s2Color = [UIColor colorWithHexValue:0xffffff];
        self.s2FontSize = 12;
        self.s3Color = [UIColor colorWithHexValue:0xffffff];
        self.s3FontSize = 12;
        self.s4Color = [UIColor colorWithHexValue:0xffffff];
        self.s4FontSize = 12;
        
        self.cellSelectedColor = [UIColor colorWithHexValue:0xf9f9f9];
        
        
        
        self.padBackgroundImageName = @"padBackgroundImageName";
        self.haveBanner = 0;
        
        self.placeholderName = @"placeholderName";
        self.appIconName = @"appIcon80";
        self.aboutUsBackgroundImage = @"aboutusBackground";
        self.version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    }
    
    
    - (void)resetTabbarFrame
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.tabBarController.mkTabbar.frame = RECT(0, 0, 60, SCREEN_WIDTH);
            [self.tabBarController.mkTabbar setSelectionIndicatorImage:IMAGENAMED(@"cleanImage")];
            [self.tabBarController.mkTabbar setBarTintColor:[UIColor blackColor]];
            [self.tabBarController.mkTabbar setTintColor:[UIColor whiteColor]];
        }
    }
    
    - (void)getLeftData
    {
        UrlRequest *request = [[UrlRequest alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/flashinterface/GetCategoryByTopicID.ashx?testVersion=%@&testType=1&topicid=%@",HOST,self.version,self.topicId];
        //    NSString *url = [NSString stringWithFormat:@"%@/flashinterface/GetCategoryByTopicID.ashx?testVersion=1.20&testType=1&topicid=50",HOST];
        
        NSLog(url);
        [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
    }
    
    - (void)finishMethod:(NSData *)data
    {
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        NSMutableArray *array6 = [[NSMutableArray alloc] init];
        NSMutableArray *array10 = [[NSMutableArray alloc] init];
        NSMutableArray *array11 = [[NSMutableArray alloc] init];
        
        GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:Nil];
        
        self.haveType = [[pagedoc.rootElement attributeForName:@"type"] stringValue];
        [self.rightViewController setType];
        [self.fv1 reloadData];
        NSArray *employees = [pagedoc nodesForXPath:@"//category" error:NULL];
        
        for (GDataXMLElement *employe in employees) {
            LeftModel *model = [[LeftModel alloc] init];
            model.typeId = [[employe attributeForName:@"typeid"] stringValue];//解析属性
            model.title = [[employe attributeForName:@"title"] stringValue];//解析属性
            model.image = [[employe attributeForName:@"image"] stringValue];
            model.link = [[employe attributeForName:@"link"] stringValue];
            switch ([model.typeId integerValue]) {
                case 1:
                    [array1 addObject:model];
                    break;
                case 2:
                    [array2 addObject:model];
                    break;
                case 4:
                    [array4 addObject:model];
                    break;
                case 6:
                    [array6 addObject:model];
                    break;
                case 10:
                    [array10 addObject:model];
                    break;
                case 11:
                    [array11 addObject:model];
                    break;
                default:
                    break;
            }
        }
        
        NSDictionary *dict = @{@"1": array1,@"2":array2,@"4":array4,@"6":array6,@"10":array10,@"11":array11};
        
        dispatch_queue_t serialQueue = dispatch_queue_create("QueueName",NULL);
        dispatch_async(serialQueue, ^{
            [[DataBase sharedDataBase] insertData:array1];
        });
        dispatch_async(serialQueue, ^{
            [[DataBase sharedDataBase] insertData:array2];
        });
        dispatch_async(serialQueue, ^{
            [[DataBase sharedDataBase] insertData:array4];
        });
        dispatch_async(serialQueue, ^{
            [[DataBase sharedDataBase] insertData:array6];
        });
        dispatch_async(serialQueue, ^{
            [[DataBase sharedDataBase] insertData:array10];
        });
        dispatch_async(serialQueue, ^{
            [[DataBase sharedDataBase] insertData:array11];
        });
        dispatch_async(serialQueue, ^{
            dispatch_barrier_async(serialQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setWindowRootViewController];
                    [self.leftViewController firstGetDataArray:dict];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"rightgood"]) {
                            int a = [[[NSUserDefaults standardUserDefaults] objectForKey:@"openCount"] intValue];
                            if (a%5 == 0) {
                                [self performSelector:@selector(showAlert) withObject:nil];
                                NSLog(@"aaaa = %d",a);
                            }
                        }
                    });
                });
            });
            
        });
        
    }
    
    - (void)showAlert
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的建议是我们继续的动力，他能督促我们做的更好。" message:@"" delegate:self cancelButtonTitle:@"下次考虑" otherButtonTitles:@"评论支持", nil];
        alert.tag = 10000;
        alert.delegate = self;
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    
    - (void)failMethod:(NSError *)error
    {
        MKLog(@"error:%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setWindowRootViewController];
            
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"rightgood"]) {
                    int a = [[[NSUserDefaults standardUserDefaults] objectForKey:@"openCount"] intValue];
                    if (a%5 == 0) {
                        [self performSelector:@selector(showAlert) withObject:nil];
                        NSLog(@"aaaa = %d",a);
                    }
                }
            });
            if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == kNotReachable)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请检查网络连接" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                return ;
            }
            
            [self.leftViewController firstGetDataArray:nil];
            
        });
        
    }
    
    - (MMDrawerController *)drawerController
    {
        if (!_drawerController) {
            _leftMainNavigationController = [[self addNavigation:@[self.leftViewController]] lastObject];
            _rightMainNavigationController = [[self addNavigation:@[self.rightViewController]] lastObject];
            _drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.tabBarController leftDrawerViewController:_leftMainNavigationController rightDrawerViewController:_rightMainNavigationController];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
            }
            else {
                [_drawerController setMaximumRightDrawerWidth:SCREEN_WIDTH - 45];
                [_drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH - 45];
                [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
                [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView |MMCloseDrawerGestureModeTapCenterView];
            }
            
        }
        return _drawerController;
    }
    
    - (LeftViewController *)leftViewController
    {
        if (!_leftViewController) {
            _leftViewController = [[LeftViewController alloc] init];
            
        }
        return _leftViewController;
    }
    
    - (RightViewController *)rightViewController
    {
        if (!_rightViewController) {
            _rightViewController = [[RightViewController alloc] init];
            
        }
        return _rightViewController;
    }
    
    - (MKTabbarViewController *)tabBarController
    {
        if (!_tabBarController) {
            _tabBarController = [[MKTabbarViewController alloc] init];
            _tabBarController.viewControllers = [self createTabbarViewControllers];
            [_tabBarController.mkTabbar setViewControllers:_tabBarController.viewControllers];
            
            //        [_tabBarController.tabBar setSelectionIndicatorImage:IMAGENAMED(@"cleanImage")];
            //        [_tabBarController.tabBar setBarTintColor:self.navigationColor];
            //        [_tabBarController.tabBar setTintColor:[UIColor whiteColor]];
            
        }
        return _tabBarController;
    }
    
    - (NSArray *)createTabbarViewControllers
    {
        //    NSArray *array = @[self.fv1,self.fv2,self.fv3,self.fv4,self.fv5];
        //NSArray *array = @[self.fv1,self.fv2,self.fv3,self.fv10];
        //quick替换 序列
        
        
        
        
        
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
        
				
				
				
				//Laurus Master Start
                NSArray *array;
                if ([self.haveType length] > 0) {
                    array = @[self.fv1,self.fv3];
                }else{
                    array = @[self.fv1,self.fv3,self.fv10,self.fv4];
                }
				//Laurus Master End
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
        
        
        
        
        
        
        
        self.itemArray = [self getItemArray:array];
        if (!UI_USER_INTERFACE_IDIOM()) {
            return [self addNavigation:array];
        }
        else {
            return [self addNavigation:array];
        }
    }
    
    - (NSArray *)getItemArray:(NSArray *)array
    {
        NSMutableArray *aa = [[NSMutableArray alloc] init];
        for (UIViewController *controller in array) {
            if ([controller isKindOfClass:[FV1ViewController class]]) {
                [aa addObject:LOCAL_LANGUAGE(@"video")];
            }
            if ([controller isKindOfClass:[FV2ViewController class]]) {
                [aa addObject:LOCAL_LANGUAGE(@"picture")];
            }
            if ([controller isKindOfClass:[FV3ViewController class]]) {
                [aa addObject:LOCAL_LANGUAGE(@"news")];
            }
            if ([controller isKindOfClass:[FV10ViewController class]]) {
                [aa addObject:LOCAL_LANGUAGE(@"part")];
            }
            //        if ([controller isKindOfClass:[FV1ViewController class]]) {
            //            [aa addObject:LOCAL_LANGUAGE(@"video")];
            //        }
            //        if ([controller isKindOfClass:[FV1ViewController class]]) {
            //            [aa addObject:LOCAL_LANGUAGE(@"video")];
            //        }
        }
        return [NSArray arrayWithArray:aa];
    }
    
    - (NSArray *)addNavigation:(NSArray *)array
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (UIViewController *controller in array) {
            [resultArray addObject:[[MainNavigationViewController alloc] initWithRootViewController:controller]];
        }
        return resultArray;
    }
    
    - (FV1ViewController *)fv1
    {
        if (!_fv1) {
            _fv1 = [[FV1ViewController alloc] init];
            _fv1.title = @"video";
            //        [_fv1.tabBarItem setFinishedSelectedImage:IMAGENAMED(@"tabvideoS") withFinishedUnselectedImage:IMAGENAMED(@"tabvideo")];
            //        _fv1.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            //        _fv1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
        return _fv1;
    }
    
    - (FV2ViewController *)fv2
    {
        if (!_fv2) {
            _fv2 = [[FV2ViewController alloc] init];
            _fv2.title = @"picture";
            //        [_fv2.tabBarItem setFinishedSelectedImage:IMAGENAMED(@"tabpicture") withFinishedUnselectedImage:IMAGENAMED(@"tabpicture")];
            //        _fv2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            
        }
        return _fv2;
    }
    
    - (FV3ViewController *)fv3
    {
        if (!_fv3) {
            _fv3 = [[FV3ViewController alloc] init];
            _fv3.title = @"news";
            //        [_fv3.tabBarItem setFinishedSelectedImage:IMAGENAMED(@"tabnews") withFinishedUnselectedImage:IMAGENAMED(@"tabnews")];
            //        _fv3.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
        return _fv3;
    }
    
    - (FV4ViewController *)fv4
    {
        if (!_fv4) {
            _fv4 = [[FV4ViewController alloc] initWithUrl:@"http://www.taobao.com"];
            _fv4.title =@"tao";
            //        [_fv4.tabBarItem setFinishedSelectedImage:IMAGENAMED(@"tabnews") withFinishedUnselectedImage:IMAGENAMED(@"tabnews")];
            //        _fv4.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            
        }
        return _fv4;
    }
    
    - (FV5ViewController *)fv5
    {
        if (!_fv5) {
            _fv5 = [[FV5ViewController alloc] initWithUrl:@"http://www.weibo.com"];
            _fv5.title = @"blog";
            //        [_fv5.tabBarItem setFinishedSelectedImage:IMAGENAMED(@"tabnews") withFinishedUnselectedImage:IMAGENAMED(@"tabnews")];
            //        _fv5.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
        return _fv5;
    }
    
    - (FV6ViewController *)fv6
    {
        if (!_fv6) {
            _fv6 = [[FV6ViewController alloc] init];
        }
        return _fv6;
    }
    
    - (FV7ViewController *)fv7
    {
        if (!_fv7) {
            _fv7 = [[FV7ViewController alloc] init];
        }
        return _fv7;
    }
    
    - (FV8ViewController *)fv8
    {
        if (!_fv8) {
            _fv8 = [[FV8ViewController alloc] init];
        }
        return _fv8;
    }
    
    - (FV9ViewController *)fv9
    {
        if (!_fv9) {
            _fv9 = [[FV9ViewController alloc] init];
        }
        return _fv9;
    }
    
    - (FV10ViewController *)fv10
    {
        if (!_fv10) {
            _fv10 = [[FV10ViewController alloc] init];
            _fv10.title = @"part";
        }
        return _fv10;
    }
    
    
    - (void)addLeftViewToViewForPadAnimated:(BOOL)animate
    {
        [self addLeftViewToViewForPadAnimated:animate Appear:!leftAddForPad];
    }
    
    - (void)addLeftViewToViewForPadAnimated:(BOOL)animate Appear:(BOOL)appear
    {
        if (appear) {
            if (leftAddForPad) {
                return;
            }
            if (rightAddForPad) {
                [self addRightViewToViewForPadAnimated:YES];
            }
            self.leftMainNavigationController.view.frame = RECT(1024, 0, 320, SCREEN_WIDTH);
            [self.tabBarController.view addSubview:self.leftMainNavigationController.view];
            NSTimeInterval duration = 0.3;
            [UIView animateWithDuration:(animate?duration:0) animations:^{
                self.leftMainNavigationController.view.frame = RECT(60 + 470 + 5, 0, 320, SCREEN_WIDTH);
            }];
            
            leftAddForPad = YES;
        }
        else {
            if (!leftAddForPad) {
                return;
            }
            NSTimeInterval duration = 0.3;
            [UIView animateWithDuration:(animate?duration:0) animations:^{
                self.leftMainNavigationController.view.frame = RECT(1024 + 5, 0, 320, SCREEN_WIDTH);
            } completion:^(BOOL finished) {
                [self.leftMainNavigationController.view removeFromSuperview];
            }];
            leftAddForPad = NO;
        }
    }
    
    - (void)addRightViewToViewForPadAnimated:(BOOL)animate
    {
        [self addRightViewToViewForPadAnimated:animate Appear:!rightAddForPad];
    }
    
    - (void)addRightViewToViewForPadAnimated:(BOOL)animate Appear:(BOOL)appear
    {
        if (appear) {
            if (rightAddForPad) {
                [self addSearchViewToViewForPadAnimated:animate Appear:NO];
                return;
            }
            if (leftAddForPad) {
                [self addLeftViewToViewForPadAnimated:YES];
            }
            self.rightMainNavigationController.view.frame = RECT(1024 + 50, 0, 320, SCREEN_WIDTH);
            [self.tabBarController.view addSubview:self.rightMainNavigationController.view];
            NSTimeInterval duration = 0.3;
            [UIView animateWithDuration:(animate?duration:0) animations:^{
                self.rightMainNavigationController.view.frame = RECT(60 + 470 + 5, 0, 320, SCREEN_WIDTH);
            }];
            rightAddForPad = YES;
        }
        else {
            if (!rightAddForPad) {
                return;
            }
            NSTimeInterval duration = 0.3;
            [UIView animateWithDuration:(animate?duration:0) animations:^{
                self.rightMainNavigationController.view.frame = RECT(1024 + 50, 0, 320, SCREEN_WIDTH);
            } completion:^(BOOL finished) {
                [self.rightMainNavigationController.view removeFromSuperview];
            }];
            rightAddForPad = NO;
        }
    }
    
    
    - (void)addSearchViewToViewForPadAnimated:(BOOL)animate
    {
        [self addSearchViewToViewForPadAnimated:animate Appear:!searchAddForPad];
    }
    - (void)addSearchViewToViewForPadAnimated:(BOOL)animate Appear:(BOOL)appear
    {
        if (appear) {
            if (searchAddForPad) {
                return;
            }
            if (!rightAddForPad) {
                [self addRightViewToViewForPadAnimated:YES Appear:YES];
            }
            [self.rightViewController tableViewSelectWhichViewControllerIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            searchAddForPad = YES;
        }
        else {
            if (!searchAddForPad) {
                return;
            }
            [self.rightMainNavigationController popViewControllerAnimated:YES];
            searchAddForPad = NO;
        }
    }
    
    
    
    
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
    {
        NSString *string = [url absoluteString];
        if ([string hasPrefix:@"wx"]) {
            return [WXApi handleOpenURL:url delegate:self];
        }
        if ([string hasPrefix:@"wb"]) {
            return [WeiboSDK handleOpenURL:url delegate:self];
        }
        return YES;
    }
    
    
    
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
        NSString *string = [url absoluteString];
        if ([string hasPrefix:@"wx"]) {
            return [WXApi handleOpenURL:url delegate:self];
        }
        if ([string hasPrefix:@"wb"]) {
            return [WeiboSDK handleOpenURL:url delegate:self];
        }
        return YES;
    }
    
    
#pragma mark - weixin
    
    
    - (void)onResp:(BaseResp *)resp
    {
        if([resp isKindOfClass:[SendMessageToWXResp class]])
        {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            if (resp.errCode == 0) {
                hud.labelText = @"分享成功";
                
            }else {
                hud.labelText = @"分享失败";
                
            }
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            
        }
        
    }
    
    
#pragma mark - weibo
    
    - (void)didReceiveWeiboResponse:(WBBaseResponse *)response
    {
        if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
                hud.labelText = @"分享成功";
                
            }else {
                hud.labelText = @"分享失败";
                
            }
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            
        }
    }
    
    
    
    
    - (void)ad
    {
        self.floatWindow = [[MobiSageFloatWindow alloc] initWithAdSize:Float_size_3
                                                              delegate:self
                                                             slotToken:MS_Test_SlotToken_Poster];
        
    }
    
    
#pragma mark - MobiSageFloatWindowDelegate
#pragma mark
    
    - (void)mobiSageFloatClick:(MobiSageFloatWindow*)adFloat
    {
        NSLog(@"mobiSageFloatClick");
    }
    
    - (void)mobiSageFloatClose:(MobiSageFloatWindow*)adFloat
    {
        NSLog(@"mobiSageFloatClose");
        self.floatWindow.delegate = nil;
        self.floatWindow = nil;
        
    }
    
    - (void)mobiSageFloatSuccessToRequest:(MobiSageFloatWindow*)adFloat
    {
        NSLog(@"mobiSageFloatSuccessToRequest");
        [self.floatWindow showAdvView];
        //    [self performSelector:@selector(mobiSageFloatClose:) withObject:self.floatWindow afterDelay:2];
        
    }
    
    - (void)mobiSageFloatFaildToRequest:(MobiSageFloatWindow*)adFloat withError:(NSError *)error
    {
        NSLog(@"mobiSageFloatFaildToRequest error = %@", [error description]);
        
    }
    
    
    
    
    
    
    - (void)gotoStore
    {
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                         self.appstoreId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"rightgood"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    
    
    - (void)applicationWillResignActive:(UIApplication *)application
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    - (void)applicationDidEnterBackground:(UIApplication *)application
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        enterToBackground = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playPause" object:nil];
        
    }
    
    - (void)applicationWillEnterForeground:(UIApplication *)application
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playNow" object:nil];
    }
    
    - (void)applicationDidBecomeActive:(UIApplication *)application
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        enterToBackground = NO;
    }
    
    - (void)applicationWillTerminate:(UIApplication *)application
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @end
