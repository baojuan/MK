//
//  AppsViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "AppsViewController.h"

@interface AppsViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) NSString *url;

@end

@implementation AppsViewController
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
        self.screenName = @"精品应用";


    }
    return self;
}
- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:self.title rightButtonImage:Nil ForPad:NO ForPadFullScreen:NO];
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
    
    [MobClick event:[NSString stringWithFormat:@"正在访问精品应用"]];
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setWebViewProperty];
    self.url = @"http://static.hbook.us/recommand.aspx?typeid=1";
}

- (void)setWebViewProperty
{
    webView = [[UIWebView alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        webView.frame = RECT(0, navigationView.frame.size.height, 320, SCREEN_HEIGHT - navigationView.frame.size.height);
    }
    else {
        webView.frame = RECT(0, navigationView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - navigationView.frame.size.height);
    }
    webView.backgroundColor = [UIColor clearColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    webView.delegate = self;
    [self.view addSubview:webView];
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
