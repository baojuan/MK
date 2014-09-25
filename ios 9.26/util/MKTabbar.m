//
//  MKTabbar.m
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "MKTabbar.h"
#import "MKButton.h"
@implementation MKTabbar
{
    AppDelegate *appdelegate;
    NSMutableArray *buttonArray;
    UIView *redView;

}

- (id)init
{
    if (self = [super init]) {
        appdelegate = APPDELEGATE;
        buttonArray = [[NSMutableArray alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.frame = RECT(0, 0, 60, SCREEN_WIDTH);
            self.backgroundColor = [UIColor blackColor];
            [self setSelectionIndicatorImage:IMAGENAMED(@"cleanImage")];
            [self setBarTintColor:[UIColor blackColor]];
            [self setTintColor:[UIColor whiteColor]];
            
            
            redView = [[UIView alloc] initWithFrame:RECT(0, 80, 5, 45)];
            redView.backgroundColor = appdelegate.navigationColor;
            [self addSubview:redView];

        }
        else {
            self.frame = RECT(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
            self.backgroundColor = appdelegate.navigationColor;
            [self setSelectionIndicatorImage:IMAGENAMED(@"cleanImage")];
            [self setBarTintColor:appdelegate.navigationColor];
            [self setTintColor:[UIColor whiteColor]];
        }
        
        
        
    }
    return self;
}


- (void)setViewControllers:(NSArray *)array
{
    NSMutableArray *aa = [[NSMutableArray alloc] initWithArray:array];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.title = @"";
        [aa insertObject:controller atIndex:0];
        
        UIViewController *controller1 = [[UIViewController alloc] init];
        controller1.title = @"search";
        [aa addObject:controller1];
        
        UIViewController *controller2 = [[UIViewController alloc] init];
        controller2.title = @"setting";
        [aa addObject:controller2];
    }
    else {
        
    }
    CGFloat width = SCREEN_WIDTH * 1.0 / [aa count];
    CGFloat height = 60.0;
    for (int i = 0; i < [aa count]; i ++) {
        UIViewController *controller = [aa objectAtIndex:i];
        
        if ([controller.title isEqualToString:@""]) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(appdelegate.appIconName)];
            imageView.frame = RECT(5, 25, 43, 43);
            [self addSubview:imageView];
            continue;
        }
        
        MKButton *button = [MKButton buttonWithType:UIButtonTypeCustom];
        button.title = controller.title;
        button.tag = 100 + i;
        NSString *imagename;
        
        NSString *imageSelectname;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            imagename = [NSString stringWithFormat:@"tab%@_ipad",controller.title];
            imageSelectname = [NSString stringWithFormat:@"tab%@S_ipad",controller.title];
        }
       
        else {
            imagename = [NSString stringWithFormat:@"tab%@",controller.title];
            imageSelectname = [NSString stringWithFormat:@"tab%@S",controller.title];
        }

        
        [button setImage:IMAGENAMED(imagename) forState:UIControlStateNormal];
        [button setImage:IMAGENAMED(imageSelectname) forState:UIControlStateSelected];
        
        [button setTitle:LOCAL_LANGUAGE(controller.title) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE(10);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            button.frame = RECT(0, 20 + height * i, 60, height);
        }
        else {
            button.frame = RECT(width * i, 0, width, 49);
            
        }
        [self addSubview:button];
        [buttonArray addObject:button];
        if (i == 0) {
            button.selected = YES;
        }
    }

}

- (void)tabbarButtonClick:(UIButton *)button
{
    [self.tabbarDelegate tabbarButtonClick:button];
    if (!button.selected) {
        for (UIButton * bb in buttonArray) {
            bb.selected = NO;
        }
        button.selected = YES;
        [UIView beginAnimations:nil context:nil];
        CGRect rect = redView.frame;
        rect.origin.y = button.frame.origin.y;
        redView.frame = rect;
        [UIView commitAnimations];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
