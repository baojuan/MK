//
//  AdviceViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "AdviceViewController.h"
#import "GAI.h"
@interface AdviceViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation AdviceViewController
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
        self.screenName = @"意见反馈";


    }
    return self;
}
- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:self.title rightButtonImage:IMAGENAMED(@"adviseConfirmButton") ForPad:NO ForPadFullScreen:NO];
    [navigationView.rightButton setBackgroundImage:IMAGENAMED(@"adviseConfirmButton") forState:UIControlStateNormal];
    [navigationView.rightButton setImage:Nil forState:UIControlStateNormal];
    [navigationView.rightButton setTitle:LOCAL_LANGUAGE(@"confirm") forState:UIControlStateNormal];
    [navigationView.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navigationView.rightButton.titleLabel.font = FONTSIZE(12);
    [navigationView.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationView];
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightButtonClick
{
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"意见"
                                            action:@"来自客户的意见"
                                             label:[NSString stringWithFormat:@"来自客户的意见%@  邮箱%@",self.textField.text, self.textField.text]
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
    
    [MobClick event:[NSString stringWithFormat:@"来自客户的意见%@  邮箱%@",self.textField.text, self.textField.text]];

    [self checkContent];
}

- (void)checkContent
{
    if ([self validateEmail:self.textField.text] && [self.textView.text length] > 0) {
        [self request];
        [self backButtonClick];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = LOCAL_LANGUAGE(@"Input content error");
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString*emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)request
{
    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@flashinterface/AddLeaveMessage.ashx?email=%@&message=%@&topicid=%@&typeid=1",HOST,self.textField,self.textView,appdelegate.topicId];
    [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
}

- (void)finishMethod:(NSData *)data
{
    
}

- (void)failMethod:(NSError *)error
{
    MKLog(@"留言fail:%@",error);
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
    [self setTextFieldAndTextView];
}
- (void)setTextFieldAndTextView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"adviseBackground")];
    imageView.frame = RECT((self.view.frame.size.width - imageView.frame.size.width) / 2.0, 10 + 64, imageView.frame.size.width, imageView.frame.size.height);
        [self.view addSubview:imageView];
    self.textField = [[UITextField alloc] initWithFrame:RECT(20, imageView.frame.size.height + imageView.frame.origin.y - 27, 280, 20)];
    self.textField.font = FONTSIZE(13);
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.placeholder = LOCAL_LANGUAGE(@"Mail optional, so we can get back to you");
    [self.view addSubview:self.textField];
    
    self.textView = [[UITextView alloc] initWithFrame:RECT(20, imageView.frame.origin.y + 5, 280, 113)];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.textView becomeFirstResponder];
    self.textView.font = FONTSIZE(13);
    [self.view addSubview:self.textView];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageView.frame = RECT((320 - imageView.frame.size.width) / 2.0, 10 + 64, imageView.frame.size.width, imageView.frame.size.height);
        
    }

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
