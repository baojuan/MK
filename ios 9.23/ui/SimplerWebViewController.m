//
//  SimplerWebViewController.m
//  MKProject
//
//  Created by baojuan on 14-7-11.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "SimplerWebViewController.h"
#import "WebViewToolBarForPad.h"

@interface SimplerWebViewController ()<UIWebViewDelegate>

@end

@implementation SimplerWebViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    UIWebView *webView;
    
    WebViewToolBarForPad *toolBarForPad;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        self.screenName = @"网页";

    }
    return self;
}

- (id)initWithUrl:(NSString *)url title:(NSString *)title
{
    if (self = [super init]) {
        self.url = url;
        self.navTitle = title;
    }
    return self;
}





- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    navigationView = [[MKNavigationView alloc] initWithTitle:self.navTitle rightButtonImage:nil ForPad:YES ForPadFullScreen:YES];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationView];
    
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [MobClick event:[NSString stringWithFormat:@"正在访问页面%@",self.url]];
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setWebViewProperty];
    [self setBottomView];
    [self setBackWebViewButton];
    
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



- (void)setWebViewProperty
{
    webView = [[UIWebView alloc] initWithFrame:RECT(0, navigationView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - navigationView.frame.size.height)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        webView.frame = RECT(0, navigationView.frame.size.height, SCREEN_HEIGHT, SCREEN_WIDTH - navigationView.frame.size.height - 35);
    }
    webView.backgroundColor = [UIColor clearColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    webView.delegate = self;
    [webView setScalesPageToFit:YES]; 
    [self.view addSubview:webView];
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)setBottomView
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        toolBarForPad = [[WebViewToolBarForPad alloc] initWithState:NO delegate:self];
        toolBarForPad.shareButton.hidden = YES;
        toolBarForPad.collectButton.hidden = YES;
        toolBarForPad.backButton.hidden = YES;
        toolBarForPad.forwardButton.hidden = YES;
        toolBarForPad.refreshButton.hidden = YES;
        toolBarForPad.editButton.hidden = YES;
        toolBarForPad.talkButton.hidden = YES;
        toolBarForPad.talkLabel.hidden = YES;
        [self.view addSubview:toolBarForPad];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
