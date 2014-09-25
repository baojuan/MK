//
//  AboutusViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "AboutusViewController.h"
#import "AboutDetaiViewController.h"
#import "GAI.h"

@interface AboutusViewController ()

@end

@implementation AboutusViewController
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
        self.screenName = @"关于我们";


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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(appdelegate.aboutUsBackgroundImage)];
    [self setHeadView];
    [self setViewInThisView];
}

- (void)setViewInThisView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT((SCREEN_WIDTH - 86) / 2.0, (SCREEN_WIDTH - 86) / 2.0, 86, 86)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageView.frame = RECT((320 - 86) / 2.0, (320 - 86) / 2.0, 86, 86);
    }

    imageView.image = IMAGENAMED(appdelegate.appIconName);
    imageView.layer.shadowOffset = SIZE(1, 1);
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:RECT(0, imageView.frame.origin.y + imageView.frame.size.height + 5, SCREEN_WIDTH, 30)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        appNameLabel.frame = RECT(0, imageView.frame.origin.y + imageView.frame.size.height + 5, 320, 30);
    }
    appNameLabel.backgroundColor = [UIColor clearColor];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.textColor = [UIColor whiteColor];
    appNameLabel.text = appdelegate.appName;
    appNameLabel.font = FONTBOLDSIZE(16);
    [self.view addSubview:appNameLabel];
    
    UILabel *solgonLabel = [[UILabel alloc] initWithFrame:RECT(0, appNameLabel.frame.origin.y + appNameLabel.frame.size.height + 0, SCREEN_WIDTH, 15)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        solgonLabel.frame = RECT(0, appNameLabel.frame.origin.y + appNameLabel.frame.size.height + 0, 320, 15);
    }
    solgonLabel.textAlignment = NSTextAlignmentCenter;
    solgonLabel.textColor = RGBCOLOR(178, 178, 178);
    solgonLabel.text = appdelegate.str_Solgon;
    solgonLabel.font = FONTBOLDSIZE(12);
    [self.view addSubview:solgonLabel];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = RECT((SCREEN_WIDTH - 350 / 2.0) / 2.0, SCREEN_HEIGHT - 60 - 98 / 2.0, 350 / 2.0, 98 / 2.0);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        button.frame = RECT((320 - 350 / 2.0) / 2.0, SCREEN_WIDTH - 60 - 98 / 2.0, 350 / 2.0, 98 / 2.0);
    }

    [button setBackgroundImage:IMAGENAMED(@"aboutUsButton") forState:UIControlStateNormal];
    [button setTitle:LOCAL_LANGUAGE(@"Copr") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = FONTSIZE(15);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    UILabel *versionLabel = [[UILabel alloc] initWithFrame:RECT(0, button.frame.size.height + button.frame.origin.y + 20, SCREEN_WIDTH, 15)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        versionLabel.frame = RECT(0, button.frame.size.height + button.frame.origin.y + 20, 320, 15);
    }

    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = RGBCOLOR(120, 120, 120);
    versionLabel.text = [NSString stringWithFormat:@"v%@",appdelegate.version];
    versionLabel.font = FONTBOLDSIZE(12);
    [self.view addSubview:versionLabel];
    
}

- (void)buttonClick
{
    AboutDetaiViewController *detailViewController = [[AboutDetaiViewController alloc] init];
    detailViewController.title = LOCAL_LANGUAGE(@"Copy Right");
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
