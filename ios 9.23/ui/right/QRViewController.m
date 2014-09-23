//
//  QRViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "QRViewController.h"

@interface QRViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation QRViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
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
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setCenterView];
}

- (void)setCenterView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:RECT(0, (navigationView.frame.origin.y + navigationView.frame.size.height), SCREEN_WIDTH, SCREEN_HEIGHT - navigationView.frame.origin.y - navigationView.frame.size.height)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.scrollView.frame = RECT(0, (navigationView.frame.origin.y + navigationView.frame.size.height), 320, SCREEN_WIDTH -  navigationView.frame.origin.y - navigationView.frame.size.height);
    }

    
    [self.view addSubview:self.scrollView];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:IMAGENAMED(@"QR")];
    backgroundImage.frame = RECT((self.scrollView.frame.size.width - backgroundImage.frame.size.width) / 2.0, 15, backgroundImage.frame.size.width, backgroundImage.frame.size.height);
    [self.scrollView addSubview:backgroundImage];
    
    UIImageView *appIcon = [[UIImageView alloc] initWithImage:IMAGENAMED(appdelegate.appIconName)];
    appIcon.frame = RECT((backgroundImage.frame.size.width - 52) / 2.0, (backgroundImage.frame.size.height - 52) / 2.0, 52, 52);
    [backgroundImage addSubview:appIcon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(0, backgroundImage.frame.origin.y + backgroundImage.frame.size.height, self.scrollView.frame.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = LOCAL_LANGUAGE(@"QR introduction");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONTSIZE(12);
    label.textColor = RGBCOLOR(90, 90, 90);
    [self.scrollView addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:IMAGENAMED(@"QRScan") forState:UIControlStateNormal];
    button.frame = RECT((label.frame.size.width - 540 / 2.0) / 2.0, label.frame.size.height + label.frame.origin.y + 15, 540 / 2.0, 98 / 2.0);
    [button addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    self.scrollView.contentSize = SIZE(self.scrollView.frame.size.width, button.frame.size.height + button.frame.origin.y + 50);
}

- (void)scanButtonClick
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
