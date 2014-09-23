//
//  ShareView.m
//  MKProject
//
//  Created by baojuan on 14-7-10.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ShareView.h"
#import "UpDownButton.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "iTellAFriend.h"
@implementation ShareView
{
    UIView *backgroundView;
    UpDownButton *weixinBtn;
    UpDownButton *weixinFriendsBtn;
    UpDownButton *weiboBtn;
    UpDownButton *qqBtn;
    
    UpDownButton *emailBtn;
    
    ArticleModel *item;
    AppDelegate *appdelegate;
}


- (id)init
{
    return [self initForHorizontal:YES];
}
- (id)initForHorizontal:(BOOL)Horizontal
{
    self = [super init];
    if (self) {
        // Initialization code
        appdelegate = APPDELEGATE;
        self.backgroundColor = [UIColor clearColor];
        backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        if (Horizontal) {
            self.frame = RECT(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                backgroundView.frame = RECT(0, SCREEN_WIDTH - 80, SCREEN_HEIGHT, 80);
            }
            else {
                backgroundView.frame = RECT(0, SCREEN_WIDTH - 60, SCREEN_HEIGHT, 60);
            }

        }
        else {
            self.frame = RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                backgroundView.frame = RECT(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80);
            }
            else {
                backgroundView.frame = RECT(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60);
            }

        }
        
        UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, self.frame.size.width, self.frame.size.height)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        [self addSubview:view];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [view addGestureRecognizer:ges];
        
        
        [self addSubview:backgroundView];
        
        if ([[appdelegate haveType] length] != 0) {
            emailBtn = [self buttonCreateBaseProperty];
            emailBtn.frame = RECT(0, 0, self.frame.size.width / 3.0, backgroundView.frame.size.height);
            [emailBtn setImage:IMAGENAMED(@"sns_icon_email") forState:UIControlStateNormal];
            emailBtn.tag = SHARE_BUTTON_EMAIL;
            [emailBtn setTitle:@"邮件" forState:UIControlStateNormal];
            [backgroundView addSubview:emailBtn];
        }
        else {
            CGFloat width = self.frame.size.width / 3.0;
            weixinBtn = [self buttonCreateBaseProperty];
            weixinBtn.frame = RECT(0, 0, width, backgroundView.frame.size.height);
            [weixinBtn setImage:IMAGENAMED(@"sns_icon_22") forState:UIControlStateNormal];
            weixinBtn.tag = SHARE_BUTTON_WEIXIN;
            [weixinBtn setTitle:@"微信" forState:UIControlStateNormal];
            [backgroundView addSubview:weixinBtn];
            
            
            weixinFriendsBtn = [self buttonCreateBaseProperty];
            weixinFriendsBtn.frame = RECT(width, 0, width, backgroundView.frame.size.height);
            weixinFriendsBtn.tag = SHARE_BUTTON_WX_FRIEND;
            
            [weixinFriendsBtn setImage:IMAGENAMED(@"sns_icon_23") forState:UIControlStateNormal];
            [weixinFriendsBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
            [backgroundView addSubview:weixinFriendsBtn];
            
            
            
            weiboBtn = [self buttonCreateBaseProperty];
            weiboBtn.frame = RECT(width * 2, 0, width, backgroundView.frame.size.height);
            weiboBtn.tag = SHARE_BUTTON_WEIBO;
            [weiboBtn setImage:IMAGENAMED(@"sns_icon_1") forState:UIControlStateNormal];
            [weiboBtn setTitle:@"新浪微博" forState:UIControlStateNormal];
            [backgroundView addSubview:weiboBtn];

        }
        
        
        
    }
    return self;
}

- (void)sendEmailClick
{
    [iTellAFriend sharedInstance].appStoreURL = [NSURL URLWithString:[[item.link componentsSeparatedByString:@"&frame=no"] componentsJoinedByString:@""]];

    UINavigationController* tellAFriendController = [[iTellAFriend sharedInstance] tellAFriendController];
    [appdelegate.mainNavigationController presentModalViewController:tellAFriendController animated:YES];
}

- (UpDownButton *)buttonCreateBaseProperty;
{
    UpDownButton *button = [UpDownButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = FONTSIZE(14);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == SHARE_BUTTON_WEIXIN) {
        [self sendTextContent];
    }
    else if (button.tag == SHARE_BUTTON_WX_FRIEND) {
        [self sendTextContentToFriends];

    }
    else if (button.tag == SHARE_BUTTON_WEIBO) {
        [self shareButtonPressed];
    }
    else if (button.tag == SHARE_BUTTON_EMAIL) {
        [self sendEmailClick];
    }
    [self tap];
}

- (void)tap
{
    if ([self.delegate respondsToSelector:@selector(hiddenShareButton)]) {
        [self.delegate performSelector:@selector(hiddenShareButton) withObject:nil];
    }

}

- (void)getArticleModel:(ArticleModel *)model
{
    item = model;
}




- (void) sendTextContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = item.title;
    message.description = [NSString stringWithFormat:@"我发了一个很有趣的东西，%@，快来跟我一起看看吧！",item.title];
    [message setThumbImage:[UIImage imageNamed:appdelegate.appIconName]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = [[item.link componentsSeparatedByString:@"&frame=no"] componentsJoinedByString:@""];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void) sendTextContentToFriends
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = item.title;
    message.description = [NSString stringWithFormat:@"我发了一个很有趣的东西，%@，快来跟我一起看看吧！",item.title];
    [message setThumbImage:[UIImage imageNamed:appdelegate.appIconName]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = [[item.link componentsSeparatedByString:@"&frame=no"] componentsJoinedByString:@""];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}




- (void)shareButtonPressed
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = item.articleId;
    webpage.title = item.title;
    webpage.description = [NSString stringWithFormat:@"我发了一个很有趣的东西，%@，快来跟我一起看看吧！",item.title];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:appdelegate.appIconName ofType:@"png"]];
    webpage.webpageUrl = [[item.link componentsSeparatedByString:@"&frame=no"] componentsJoinedByString:@""];
    
    message.mediaObject = webpage;
    
    return message;
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
