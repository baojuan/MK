//
//  AboutDetaiViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-26.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "AboutDetaiViewController.h"

@interface AboutDetaiViewController ()

@end

@implementation AboutDetaiViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    UIScrollView *scrollView;
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
    scrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        scrollView.frame = RECT(0, 64, 320, SCREEN_WIDTH - 64);
    }

    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    label.text = LOCAL_LANGUAGE(@"Copyright statement");
    label.numberOfLines = 0;
    label.font = FONTSIZE(12);
    label.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:label];
    
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 2000)];
    scrollView.contentSize = size;
    CGRect rect = label.frame;
    rect.size = size;
    label.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
