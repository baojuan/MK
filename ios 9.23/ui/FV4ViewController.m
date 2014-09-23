//
//  FV4ViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "FV4ViewController.h"

@interface FV4ViewController ()

@end

@implementation FV4ViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    UIWebView *webView;
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

- (id)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}


+ (NSString *)getTypeId
{
    return @"10";
}

- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    navigationView.titleLabel.text = _navTitle;
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
    [self setWebViewProperty];
    [self setBackWebViewButton];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [appdelegate addLeftViewToViewForPadAnimated:YES Appear:YES];
        [appdelegate resetTabbarFrame];
    }
}

- (void)setBackWebViewButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGENAMED(@"main_web_view_back") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backWebViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = RECT(webView.frame.size.width - 34 - 7, webView.frame.size.height - 34 - 7, 34, 34);
    [webView addSubview:button];
}
- (void)backWebViewButtonClick
{
    [webView goBack];
}

- (void)getCenterViewUrl:(NSString *)url
{
    self.url = url;

}

- (void)setWebViewProperty
{
    webView = [[UIWebView alloc] initWithFrame:RECT(0, navigationView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - navigationView.frame.size.height - 49)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        webView.backgroundColor = [UIColor whiteColor];
        webView.frame = RECT(60, 64, 470, SCREEN_WIDTH - 64);
    }
    else {
        webView.backgroundColor = [UIColor clearColor];
        
    }

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:webView];
}
- (void)setUrl:(NSString *)url
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:url];
    [string replaceOccurrencesOfString:@"^1^" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    _url = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"加载失败";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
