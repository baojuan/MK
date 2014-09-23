//
//  WebViewToolBar.m
//  猫咪物语
//
//  Created by 鲍娟 on 14-4-23.
//  Copyright (c) 2014年 et. All rights reserved.
//

#import "WebViewToolBar.h"
#import "AppDelegate.h"
#define EXTRA_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7?20.0f:0.0f)

@implementation WebViewToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithState:(BOOL)isSimple delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.backgroundColor = [UIColor blackColor];
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 35, SCREEN_WIDTH, 35);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.frame = CGRectMake(475 + 60, SCREEN_WIDTH - 35, SCREEN_HEIGHT - 475 - 60, 35);
        }

        
        CGFloat width = self.frame.size.width / 6.0;
        if (isSimple) {
            width = self.frame.size.width / 4.0;
        }
        CGFloat height = self.frame.size.height;
        
        CGFloat ww = 0;
        if (!isSimple) {
            self.backButton = [self buttonWithSelector:@selector(webBackButtonClick) imagename:@"webback_day"];
            self.backButton.frame = CGRectMake(ww, 0, width, height);
            [self addSubview:self.backButton];
            ww += width;
            self.forwardButton = [self buttonWithSelector:@selector(webForwardButtonClick) imagename:@"webforward_day"];
            self.forwardButton.frame = CGRectMake(ww, 0, width, height);
            [self addSubview:self.forwardButton];
            ww += width;

        }
        
        else
        {
        }
        
            self.editButton = [self buttonWithSelector:@selector(webEditButtonClick) imagename:@"webedit"];
            self.editButton.frame = CGRectMake(ww, 0, width, height);
            [self addSubview:self.editButton];
            ww += width;

            
            self.talkButton = [self buttonWithSelector:@selector(webTalkButtonClick) imagename:@"webtalk"];
            self.talkButton.frame = CGRectMake(ww, 0, width, height);
            [self addSubview:self.talkButton];
            ww += width;

            self.talkLabel = [[UILabel alloc] initWithFrame:RECT(self.talkButton.frame.origin.x + self.talkButton.frame.size.width / 2.0, 5, 22, 10)];
            self.talkLabel.textColor = [UIColor whiteColor];
            self.talkLabel.backgroundColor = [UIColor redColor];
            self.talkLabel.textAlignment = NSTextAlignmentCenter;
            self.talkLabel.font = FONTSIZE(7);
            self.talkLabel.text = @"0";
            [self addSubview:self.talkLabel];
            
            
            self.shareButton = [self buttonWithSelector:@selector(webShareButtonClick:) imagename:@"webshare"];
            self.shareButton.frame = CGRectMake(ww, 0, width, height);
            [self addSubview:self.shareButton];
            ww += width;

            self.refreshButton = [self buttonWithSelector:@selector(webRefreshButtonClick) imagename:@"report_article"];
            self.refreshButton.frame = CGRectMake(ww, 0, width, height);
            [self addSubview:self.refreshButton];
            ww += width;

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIButton *)buttonWithSelector:(SEL)selector imagename:(NSString *)imagename
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self.delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    return button;
}


@end
