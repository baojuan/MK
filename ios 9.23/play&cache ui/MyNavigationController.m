//
//  MyNavigationController.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-10.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
////    if ([self.topViewController isKindOfClass:[UITabBarController class]]) {
//        return UIInterfaceOrientationMaskPortrait;
////    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return UIInterfaceOrientationMaskAll;
    }
    return self.topViewController.supportedInterfaceOrientations;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        return UIInterfaceOrientationPortrait;
//    }
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}


@end
