//
//  AppDelegate.h
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

#import "FV1ViewController.h"
#import "FV2ViewController.h"
#import "FV3ViewController.h"
#import "FV4ViewController.h"
#import "FV5ViewController.h"
#import "FV6ViewController.h"
#import "FV7ViewController.h"
#import "FV8ViewController.h"
#import "FV9ViewController.h"
#import "FV10ViewController.h"

#import "MKTabbarViewController.h"
#import "MainNavigationViewController.h"

#import "HTTPServer.h"



#import "WeiboSDK.h"
#import "WXApi.h"

#import "GAI.h"
#import "MobiSageSDK.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate,MobiSageSplashDelegate,MobiSageFloatWindowDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MMDrawerController *drawerController;
@property (strong, nonatomic) MKTabbarViewController *tabBarController;
@property (strong, nonatomic) MainNavigationViewController *mainNavigationController;

@property (strong, nonatomic) LeftViewController *leftViewController;
@property (strong, nonatomic) RightViewController *rightViewController;

@property (strong, nonatomic) MainNavigationViewController *leftMainNavigationController;
@property (strong, nonatomic) MainNavigationViewController *rightMainNavigationController;

@property (strong, nonatomic) NSArray *itemArray;//获得播放历史里面应该有几个button

@property (strong, nonatomic) HTTPServer *httpServer;
@property (nonatomic,strong) MobiSageSplash* mobiSageSplash;
@property(nonatomic, strong) MobiSageFloatWindow *floatWindow;


@property (strong, nonatomic) FV1ViewController *fv1;
@property (strong, nonatomic) FV2ViewController *fv2;
@property (strong, nonatomic) FV3ViewController *fv3;
@property (strong, nonatomic) FV4ViewController *fv4;
@property (strong, nonatomic) FV5ViewController *fv5;
@property (strong, nonatomic) FV6ViewController *fv6;
@property (strong, nonatomic) FV7ViewController *fv7;
@property (strong, nonatomic) FV8ViewController *fv8;
@property (strong, nonatomic) FV9ViewController *fv9;
@property (strong, nonatomic) FV10ViewController *fv10;


@property (strong, nonatomic) UIColor *drawLeftAndRightViewBackgroundColor;//左右侧边栏背景颜色

@property (assign, nonatomic) NSInteger navigationTitleFontSize;//导航字体大小
@property (strong, nonatomic) UIColor *navigationColor;//导航背景颜色
@property (strong, nonatomic) UIColor *navigationTitleColor;//导航字体颜色
@property (strong, nonatomic) UIColor *navigationBackgroundColor;//view背景颜色
@property (strong, nonatomic) UIColor *navigationBackgroundImageColor;//导航背景图片
@property (assign, nonatomic) BOOL *navigationStyle;//0是使用颜色 1是使用背景

@property (strong, nonatomic) UIColor *leftButtonBackground;//左侧订阅button背景颜色

@property (strong, nonatomic) NSString *padBackgroundImageName;//pad背景图片


//字体颜色&大小
@property (strong, nonatomic) UIColor *h1Color;
@property (assign, nonatomic) NSInteger h1FontSize;
@property (strong, nonatomic) UIColor *descriptionColor;
@property (assign, nonatomic) NSInteger descriptionFontSize;
@property (strong, nonatomic) UIColor *s1Color;//左侧
@property (assign, nonatomic) NSInteger s1FontSize;
@property (strong, nonatomic) UIColor *s2Color;
@property (assign, nonatomic) NSInteger s2FontSize;
@property (strong, nonatomic) UIColor *s3Color;
@property (assign, nonatomic) NSInteger s3FontSize;
@property (strong, nonatomic) UIColor *s4Color;
@property (assign, nonatomic) NSInteger s4FontSize;


@property (strong, nonatomic) UIColor *cellSelectedColor;//cell选中颜色


@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) UIColor *appNameColor;
@property (strong, nonatomic) NSString *str_Solgon;
@property (strong, nonatomic) UIColor *str_SolgonColor;
@property (strong, nonatomic) NSString *appIconName;
@property (strong, nonatomic) NSString *placeholderName;
@property (strong, nonatomic) NSString *aboutUsBackgroundImage;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *topicId;
@property (strong, nonatomic) NSString *appUrl;
@property (assign, nonatomic) BOOL haveBanner;//1有 0没有
@property (strong, nonatomic) NSString *haveType;
@property (strong, nonatomic) NSString *appstoreId;
@property (strong, nonatomic) NSString *DeviceToken;

@property(nonatomic, strong) id<GAITracker> tracker;


- (void)addLeftViewToViewForPadAnimated:(BOOL)animate;

- (void)addLeftViewToViewForPadAnimated:(BOOL)animate Appear:(BOOL)appear;//将左侧列表加到view上

- (void)addRightViewToViewForPadAnimated:(BOOL)animate;
- (void)addRightViewToViewForPadAnimated:(BOOL)animate Appear:(BOOL)appear;//将右侧列表加到view上

- (void)addSearchViewToViewForPadAnimated:(BOOL)animate;
- (void)addSearchViewToViewForPadAnimated:(BOOL)animate Appear:(BOOL)appear;//将搜索加到view上
//全屏广告
- (void)ad;

//评分
- (void)gotoStore;


- (void)resetTabbarFrame;

@end
