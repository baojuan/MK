//
//  MKTabbarViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-17.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "MKTabbarViewController.h"
@interface MKTabbarViewController ()
@end

@implementation MKTabbarViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBar.hidden = YES;
    self.tabBar.superview.backgroundColor = [UIColor greenColor];
    self.mkTabbar = [[MKTabbar alloc] init];
    self.mkTabbar.tabbarDelegate = self;
    [self.view addSubview:self.mkTabbar];
    self.mkTabbar.translucent = NO;
	// Do any additional setup after loading the view.
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        self.tabBar.frame = RECT(0, 0, 49, SCREEN_HEIGHT);
//    }
}

- (void)tabbarButtonClick:(UIButton *)button
{
    NSInteger a = button.tag - 100;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        a --;
    }
    self.selectedIndex = a;
    if (a == [self.viewControllers count]) {
        if (!button.selected) {
            [appdelegate addSearchViewToViewForPadAnimated:YES Appear:YES];
        }
        else {
            [appdelegate addSearchViewToViewForPadAnimated:YES];
        }
        return;
    }
    if (a == [self.viewControllers count] + 1) {
        if (!button.selected) {
            [appdelegate addRightViewToViewForPadAnimated:YES Appear:YES];
        }
        else {
            [appdelegate addRightViewToViewForPadAnimated:YES];

        }
        return;
    }
    
    UIViewController *controller = ((UINavigationController *)[self.viewControllers objectAtIndex:a]).topViewController;
    [[NSNotificationCenter defaultCenter] postNotificationName:TABBAR_SELECT object:controller];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
