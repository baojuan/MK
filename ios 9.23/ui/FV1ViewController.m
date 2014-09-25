//
//  FV1ViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "FV1ViewController.h"

#import "FV1TableTableViewController.h"

@interface FV1ViewController ()

@property (nonatomic, strong) NSArray *viewControllersArray;
@property (nonatomic, strong) NSMutableArray *titleButtonsArray;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIScrollView *titleScrollView;
@end

@implementation FV1ViewController
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
        self.screenName = @"视频";
        self.titleButtonsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSString *)getTypeId
{
    return @"4";
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
    
    self.viewControllersArray = @[@{@"title":@"最新",@"controller":[self contentViewControllerWithType:@"1"]},@{@"title":@"最热",@"controller":[self contentViewControllerWithType:@"16"]}];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [appdelegate addLeftViewToViewForPadAnimated:YES Appear:YES];
        [appdelegate resetTabbarFrame];
    }

    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.contentScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)setContentScrollViewProperty
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.contentScrollView.scrollEnabled = NO;
    self.contentScrollView.directionalLockEnabled = YES;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.frame = RECT(0, navigationView.frame.size.height + 35, SCREEN_WIDTH, SCREEN_HEIGHT - navigationView.frame.size.height - 49 - 35);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.contentScrollView.backgroundColor = RGBCOLOR(243, 243, 243);
        self.contentScrollView.frame = RECT(60, 64 + 35, 470, SCREEN_WIDTH - 64 - 35);
    }
    else {
        self.contentScrollView.backgroundColor = RGBCOLOR(243, 243, 243);
        
    }
    self.contentScrollView.pagingEnabled = YES;
    [self.view addSubview:self.contentScrollView];
}
- (void)setTitleScrollViewProperty
{
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.titleScrollView.frame = RECT(0, navigationView.frame.size.height, SCREEN_WIDTH, 35);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.titleScrollView.backgroundColor = RGBCOLOR(243, 243, 243);
        self.titleScrollView.frame = RECT(60, 64, 470, 35);
    }
    else {
        self.titleScrollView.backgroundColor = RGBCOLOR(243, 243, 243);
        
    }
    [self.view addSubview:self.titleScrollView];
}

- (void)setViewControllersArray:(NSArray *)viewControllersArray
{
    _viewControllersArray = viewControllersArray;
    
    [self setContentScrollViewProperty];
    [self setTitleScrollViewProperty];
    CGFloat width = self.titleScrollView.frame.size.width / [_viewControllersArray count];
    for (int i = 0; i < [viewControllersArray count]; i++) {
        id dict = _viewControllersArray[i];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSString *titleString = dict[@"title"];
            UIViewController *controller = dict[@"controller"];
            
            //
            UIButton *button = [self titleScrollViewButtonWithTitle:titleString];
            button.frame = CGRectMake(i * width, 0, width, self.titleScrollView.frame.size.height);
            button.tag = 1000 + i;
            [self.titleButtonsArray addObject:button];
            [self.titleScrollView addSubview:button];
            
            if (i == 0) {
                [self titleButtonClick:button];
            }
            
            //
            CGRect rect = controller.view.frame;
            rect.origin.x = i * self.contentScrollView.frame.size.width;
            rect.origin.y = 0;
            controller.view.frame = rect;
            [self.contentScrollView addSubview:controller.view];
        }
    }
    self.contentScrollView.contentOffset = CGPointMake(0, 0);
}

- (UIButton *)titleScrollViewButtonWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:RGBCOLOR(114, 114, 114) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    
    UIColor *color;
    if (appdelegate.navigationStyle) {
        color = appdelegate.navigationBackgroundImageColor;
    }
    else {
        color = appdelegate.navigationColor;
    }

    
    [button setTitleColor:color forState:UIControlStateSelected];
    button.titleLabel.font = FONTSIZE(12);
    [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)titleButtonClick:(UIButton *)button
{
    for (UIButton *bb in self.titleButtonsArray) {
        bb.selected = NO;
        bb.titleLabel.font = FONTSIZE(12);
    }
    button.selected = YES;
    if (button.selected) {
        button.titleLabel.font = FONTSIZE(15);
    }
    else {
        button.titleLabel.font = FONTSIZE(12);
    }
    self.contentScrollView.contentOffset = CGPointMake((button.tag - 1000) * self.contentScrollView.frame.size.width, self.contentScrollView.contentOffset.y);
}

- (FV1TableTableViewController *)contentViewControllerWithType:(NSString *)type
{
    FV1TableTableViewController *controller = [[FV1TableTableViewController alloc] initWithType:type ClassTitle:self.navTitle Delegate:self];
    controller.page = self.page;
    return controller;
}

- (void)getCenterViewData:(NSString *)title
{
    navigationView.titleLabel.text = title;
    for (id dict in _viewControllersArray) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            FV1TableTableViewController *controller = dict[@"controller"];
            if ([controller isKindOfClass:[FV1TableTableViewController class]]) {
                controller.classTitle = title;
                [controller getCenterViewData];
            }
        }
    }
}


- (void)reloadData
{
    [self getCenterViewData:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
