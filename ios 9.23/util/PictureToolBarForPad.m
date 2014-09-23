//
//  PictureToolBarForPad.m
//  MKProject
//
//  Created by baojuan on 14-7-10.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "PictureToolBarForPad.h"

@implementation PictureToolBarForPad

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
            self.frame = CGRectMake(0, SCREEN_WIDTH - 35, SCREEN_HEIGHT, 35);
        }
        
        CGFloat width = self.frame.size.width / 7.0;
        CGFloat height = self.frame.size.height;
        
        
        self.allbackButton = [self buttonWithSelector:@selector(backButtonClick) imagename:@"webbackButton"];
        self.allbackButton.frame = CGRectMake(0, 0, width, height);
        [self addSubview:self.allbackButton];
        
        self.editButton = [self buttonWithSelector:@selector(editButtonClick:) imagename:@"webedit"];
        self.editButton.frame = CGRectMake(width * 1, 0, width, height);
        [self addSubview:self.editButton];
        
        
        self.talkButton = [self buttonWithSelector:@selector(talkButtonClick:) imagename:@"webtalk"];
        self.talkButton.frame = CGRectMake(width * 2, 0, width, height);
        [self addSubview:self.talkButton];
        
        self.talkLabel = [[UILabel alloc] initWithFrame:RECT(self.talkButton.frame.origin.x + self.talkButton.frame.size.width / 2.0, 5, 22, 10)];
        self.talkLabel.textColor = [UIColor whiteColor];
        self.talkLabel.backgroundColor = [UIColor redColor];
        self.talkLabel.textAlignment = NSTextAlignmentCenter;
        self.talkLabel.font = FONTSIZE(7);
        self.talkLabel.text = @"0";
        [self addSubview:self.talkLabel];
        
        self.centerLabel = [[UILabel alloc] initWithFrame:RECT(width * 3, 0, width, height)];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        self.centerLabel.backgroundColor = [UIColor clearColor];
        self.centerLabel.textColor = [UIColor whiteColor];
        self.centerLabel.font = FONTSIZE(14);
        [self addSubview:self.centerLabel];
        
        
        self.shareButton = [self buttonWithSelector:@selector(shareButtonClick:) imagename:@"webshare"];
        self.shareButton.frame = CGRectMake(width * 5, 0, width, height);
        [self addSubview:self.shareButton];
        
        self.collectButton = [self buttonWithSelector:@selector(collectionButtonClick:) imagename:@"articleCollect"];
        self.collectButton.frame = CGRectMake(width * 4, 0, width, height);
        [self.collectButton setImage:IMAGENAMED(@"articleCollectSelect") forState:UIControlStateSelected];
        
        [self addSubview:self.collectButton];
        
        
        self.downloadButton = [self buttonWithSelector:@selector(downloadButtonClick:) imagename:@"downloadPlay"];
        self.downloadButton.frame = CGRectMake(width * 6, 0, width, height);
        [self addSubview:self.downloadButton];
        
    }
    return self;
}


- (UIButton *)buttonWithSelector:(SEL)selector imagename:(NSString *)imagename
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self.delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    return button;
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
