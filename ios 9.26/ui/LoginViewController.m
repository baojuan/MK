//
//  LoginViewController.m
//  MKProject
//
//  Created by baojuan on 14-8-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "LoginViewController.h"
#import "BlurView.h"
@interface LoginViewController ()
@property (nonatomic, strong) UIButton *leftButton;

@end

@implementation LoginViewController
{
    AppDelegate *appdelegate;

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
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton setImage:IMAGENAMED(@"navback") forState:UIControlStateNormal];
    self.leftButton.frame = RECT(10, 20 + (44 - 28) / 2.0, 49, 28);
    [self.view addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self setViewInThisView];
    

}

- (void)setViewInThisView
{
    
    UIImageView *imageViewShadow = [[UIImageView alloc] initWithImage:IMAGENAMED(@"login_shadow")];
    imageViewShadow.frame = RECT((SCREEN_WIDTH - 86) / 2.0, (SCREEN_WIDTH - 86) / 2.0, imageViewShadow.frame.size.width, imageViewShadow.frame.size.height);
    [self.view addSubview:imageViewShadow];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT((self.view.frame.size.width - 86) / 2.0, (self.view.frame.size.width - 86) / 2.0, 86, 86)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageView.frame = RECT((320 - 86) / 2.0, (320 - 86) / 2.0, 86, 86);
    }
    
    imageView.image = IMAGENAMED(appdelegate.appIconName);
    imageView.layer.shadowOffset = SIZE(1, 1);
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    
    
    
    
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:RECT(0, imageView.frame.origin.y + imageView.frame.size.height + 5, self.view.frame.size.width, 30)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        appNameLabel.frame = RECT(0, imageView.frame.origin.y + imageView.frame.size.height + 5, 320, 30);
    }
    appNameLabel.backgroundColor = [UIColor clearColor];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.textColor = [UIColor whiteColor];
    appNameLabel.text = appdelegate.appName;
    appNameLabel.font = FONTBOLDSIZE(16);
    [self.view addSubview:appNameLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = RECT((self.view.frame.size.width - 360 / 2.0) / 2.0, self.view.frame.size.height - 200 - 80 / 2.0, 360 / 2.0, 80 / 2.0);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        button.frame = RECT((320 - 360 / 2.0) / 2.0, SCREEN_WIDTH - 300 - 80 / 2.0, 360 / 2.0, 80 / 2.0);
    }
    
    [button setBackgroundImage:IMAGENAMED(@"login_weibo") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = RECT((self.view.frame.size.width - 360 / 2.0) / 2.0, self.view.frame.size.height - 140 - 80 / 2.0, 360 / 2.0, 80 / 2.0);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        button1.frame = RECT((320 - 360 / 2.0) / 2.0, SCREEN_WIDTH - 240 - 80 / 2.0, 360 / 2.0, 80 / 2.0);
    }
    
    [button1 setBackgroundImage:IMAGENAMED(@"login_QQ") forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = RECT(0, self.view.frame.size.height - 50 - 98 / 2.0, 320, 98 / 2.0);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        backButton.frame = RECT(0, self.view.frame.size.width - 50 - 98 / 2.0, 320, 98 / 2.0);
    }
    
    [backButton setBackgroundImage:IMAGENAMED(@"login_gotosee") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    
}

- (void)buttonClick
{
    [self islogin:2];
}

- (void)button1Click
{
    [self islogin:3];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)islogin:(NSInteger)platform
{
    if (![ChangyanSDK isLogin]) {
        [ChangyanSDK authorize:@"039e9ede3fc96ebf427de87e624119c6" redirectURI:@"http://www.hbook.us" platform:platform completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
            
            if (statusCode != CYSuccess) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"登录失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                return ;
                
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUserInfo" object:nil];
                [self leftButtonClick];
            }
            
        }];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
