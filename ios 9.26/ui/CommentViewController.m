//
//  CommentViewController.m
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "CommentViewController.h"
#import "RatingView.h"
#import "GAI.h"

@interface CommentViewController ()<RatingViewDelegate>
@property (nonatomic, strong) ArticleModel *item;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *articleId;
@end

@implementation CommentViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    int score;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        self.screenName = @"发布评论";

    }
    return self;
}

- (id)initWithArticle:(ArticleModel *)item articleId:(NSString *)articleId
{
    if (self = [super init]) {
        self.item = item;
        self.articleId = articleId;
    }
    return self;
}

- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:self.title leftButtonImage:IMAGENAMED(@"commentCancel") rightButtonImage:IMAGENAMED(@"commentConfirm") ForPad:NO ForPadFullScreen:YES];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView.rightButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    RatingView *rating = [[RatingView alloc] initWithFrame:RECT((navigationView.frame.size.width - 80) / 2.0, 35, 80, 14)];
        [navigationView addSubview:rating];
    [rating setImagesDeselected:@"commentstar3" partlySelected:@"" fullSelected:@"commentstar2" andDelegate:self];
    [self.view addSubview:navigationView];
}

- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)comfirmButtonClick
{
    [self islogin];
}



-(void)ratingChanged:(float)newRating
{
    score = newRating;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [MobClick event:[NSString stringWithFormat:@"正在发布评论%@",self.item.title]];


    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setTextViewProperty];
}

- (void)setTextViewProperty
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"commentTextViewBackground")];
    imageView.frame = RECT(10, 64 + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - 20);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageView.frame = RECT(10, 64 + 10, SCREEN_HEIGHT - 20, SCREEN_WIDTH - 64 - 20);
    }
    [self.view addSubview:imageView];
    
    
    self.textView = [[UITextView alloc] initWithFrame:RECT(imageView.frame.origin.x + 10, imageView.frame.origin.y + 10, imageView.frame.size.width - 20, imageView.frame.size.height - 20)];
    self.textView.font = FONTSIZE(15);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.textView.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(@"cy_shuiyinipad")];
        
    }
    else {
        self.textView.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(@"cy_shuiyin")];
        
    }
    [self.view addSubview:self.textView];
    
    
}

- (void)islogin
{
    [self.textView resignFirstResponder];
    if (![ChangyanSDK isLogin]) {
        
        if ([appdelegate.haveType length] != 0) {
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评论提交成功" message:@"审核成功后会显示您的评论" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:^{
                    ;
                }];
                
            
            return;
        }

        
        [ChangyanSDK authorize:@"039e9ede3fc96ebf427de87e624119c6" redirectURI:@"http://www.hbook.us" platform:2 completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
            
            if (statusCode != CYSuccess) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"登录失败";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                return ;
                
            }
            
            
            [self commentPublish];
        }];
    }
    else {
        
        [self commentPublish];

    }
}

- (void)commentPublish
{
    NSInteger appType;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        appType = 41;
    }
    else {
        appType = 40;
        
    }
    [ChangyanSDK submitCommentTopic:self.articleId content:self.textView.text replyID:@"0" score:[NSString stringWithFormat:@"%d",score] appType:appType picUrls:Nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        
        if (statusCode != CYSuccess) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"评论失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            return ;
            
        }
        
        
        NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"评论成功";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"commentFinished" object:nil];
        [self backButtonClick];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    else {
        return UIInterfaceOrientationPortrait;
    }
}


@end
