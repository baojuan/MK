//
//  ScanPictureForPartViewController.m
//  MKProject
//
//  Created by baojuan on 14-7-15.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ScanPictureForPartViewController.h"
#import "GDataXMLNode.h"
#import "MKNavigationView.h"
#import "PictureToolBar.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "PictureToolBarForPad.h"
#import "CommentViewControllerForPad.h"
#import "CommentListViewControllerForPad.h"
#import <AssetsLibrary/AssetsLibrary.h>



@interface ScanPictureForPartViewController ()<MobiSageBannerDelegate>
@property(nonatomic, strong) MobiSageBanner* mobiSageBanner;

@end

@implementation ScanPictureForPartViewController
{
    AppDelegate *appdelegate;
    BOOL getDataComplete;
    PictureToolBar *toolBar;
    NSMutableArray *imageViewArray;
    PictureToolBarForPad *toolBarForPad;
    UILabel *titleViewForPad;
    
    UIImageView *nowImageView;
    UIScrollView *nowScrollView;
    
    NSMutableArray *scrollViewArray;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithArray:(NSArray *)array title:(NSString *)title
{
    if (self = [super init]) {
        //        self.frame = rect;
        self.title = title;
        imageViewArray = [[NSMutableArray alloc] init];
        scrollViewArray = [[NSMutableArray alloc] init];
        appdelegate = APPDELEGATE;
        self.dataArray = [[NSMutableArray alloc] initWithArray:array];
        self.view.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self setScrollViewProperty];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"查看图片"
                                            action:@"正在查看图片"
                                             label:[NSString stringWithFormat:@"正在查看图片%@",self.title]
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
    
    [MobClick event:[NSString stringWithFormat:@"正在查看图片%@",self.title]];
    
}

- (void)tap
{
    
    self.mobiSageBanner.hidden = !self.mobiSageBanner.hidden;
    _navigationView.hidden = !_navigationView.hidden;
    toolBar.hidden = !toolBar.hidden;
    toolBarForPad.hidden = !toolBarForPad.hidden;
    titleViewForPad.hidden = !titleViewForPad.hidden;
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
}



- (void)setHeadView
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    
    _navigationView = [[MKNavigationView alloc] initWithTitle:@"图片" rightButtonImage:nil ForPad:NO ForPadFullScreen:YES];
    [_navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationView];
    
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - banner id
- (void)bannerId
{
    //创建MobiSage横幅广告
    self.mobiSageBanner = [[MobiSageBanner alloc] initWithDelegate:self
                                                            adSize:Default_size
                                                         slotToken:MS_Test_SlotToken_Banner];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_WIDTH - 320) / 2.0, SCREEN_HEIGHT - 35 - 50, 320, 50);
    } else {
        self.mobiSageBanner.frame = CGRectMake((SCREEN_HEIGHT - 728) / 2.0, 20, 728, 90);
    }
    [self.view addSubview:self.mobiSageBanner];
}



//横幅广告被点击时,触发此回调方法,用于统计广告点击数
- (void)mobiSageBannerClick:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerClick");
}

//横幅广告成功展示时,触发此回调方法,用于统计广告展示数
- (void)mobiSageBannerSuccessToShowAd:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerSuccessToShowAd");
}

//横幅广告展示失败时,触发此回调方法
- (void)mobiSageBannerFaildToShowAd:(MobiSageBanner*)adBanner withError:(NSError *)error
{
    NSLog(@"mobiSageBannerFaildToShowAd, error = %@", [error description]);
}

//横幅广告点击后,打开 LandingSite 时,触发此回调方法,请勿释放横幅广告
- (void)mobiSageBannerPopADWindow:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerPopADWindow");
}

//关闭 LandingSite 回到应用界面时,触发此回调方法
- (void)mobiSageBannerHideADWindow:(MobiSageBanner*)adBanner
{
    NSLog(@"mobiSageBannerHideADWindow");
}







- (void)setScrollViewProperty
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.tag = 100;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.scrollView.frame = RECT(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = SIZE(self.scrollView.frame.size.width * [_dataArray count], self.scrollView.frame.size.height);
    for (int i = 0; i < [_dataArray count]; i ++) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:RECT(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        scroll.tag = 1000 + i;
        scroll.maximumZoomScale = 2.0f                            ;
        scroll.minimumZoomScale = 1.0f;
        scroll.delegate = self;
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:RECT((scroll.frame.size.width - 361 / 2.0) / 2.0, (scroll.frame.size.height - 344 / 2.0) / 2.0, 361 / 2.0, 344 / 2.0)];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, scroll.frame.size.width, scroll.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = IMAGENAMED(@"picloadwait");
        
        // Add gesture,double tap zoom imageView.
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [imageView addGestureRecognizer:doubleTapGesture];
        
        [imageViewArray addObject:imageView];
        [scroll addSubview:imageView];
        scroll.contentSize = imageView.frame.size;
        [scrollViewArray addObject:scroll];
        [self.scrollView addSubview:scroll];
        if (i == 0) {
            nowImageView = imageView;
        }
    }
    [self.view addSubview:self.scrollView];
    [self setHeadView];
    [self setBottomView];
    [self bannerId];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getImages];
    });
}


- (void)getImages
{
    for (int i = 0; i < [_dataArray count]; i ++) {
        
        NSString *string = [_dataArray objectAtIndex:i];
        __weak UIScrollView *scrollView = [scrollViewArray objectAtIndex:i];
        __weak UIImageView *imageView = [imageViewArray objectAtIndex:i];
        NSMutableString *imageUrl = [[NSMutableString alloc] initWithString:string];
        [imageUrl replaceOccurrencesOfString:@"app." withString:@"t1." options:NSLiteralSearch range:NSMakeRange(0, [imageUrl length])];
        [imageUrl appendString:@"/2000"];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMAGENAMED(@"picloadwait") options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image == nil) {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    imageView.image = IMAGENAMED(@"noimageipa");
                    imageView.frame = RECT(0,0,1024,768);
                }else{
                    imageView.image = IMAGENAMED(@"noimage");
                    imageView.frame = RECT(0,0,320,161);
                }
                return ;
            }
            CGFloat space = 10;
            CGFloat scaleNumber;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                scaleNumber = ((image.size.width * 1.0 / SCREEN_HEIGHT) >= (image.size.height * 1.0 / SCREEN_WIDTH)) ? (SCREEN_HEIGHT - space) * 1.0 / image.size.width : SCREEN_WIDTH * 1.0 / image.size.height;
            }
            else {
                scaleNumber = ((image.size.width * 1.0 / SCREEN_WIDTH) >= (image.size.height * 1.0 / SCREEN_HEIGHT)) ? (SCREEN_WIDTH - space) * 1.0 / image.size.width : SCREEN_HEIGHT * 1.0 / image.size.height;
            }
//            imageView.frame = RECT(space / 2.0 + (self.scrollView.frame.size.width - space - image.size.width * scaleNumber) / 2.0, (self.scrollView.frame.size.height - image.size.height * scaleNumber) / 2.0, image.size.width * scaleNumber, image.size.height * scaleNumber);
//            CGRect rect = scrollView.frame;
//            rect.size.height = imageView.frame.size.height;
//            rect.origin.y = imageView.frame.origin.y;
//            scrollView.frame = rect;
        }];
    }
}


- (void)setBottomView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        titleViewForPad = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - 35 - 227 / 2.0, SCREEN_HEIGHT, 227 / 2.0)];
        titleViewForPad.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(@"pictureTitleBackgroundImageForPad")];
        titleViewForPad.textAlignment = NSTextAlignmentCenter;
        titleViewForPad.numberOfLines = 2;
        titleViewForPad.textColor = [UIColor whiteColor];
        titleViewForPad.font = FONTBOLDSIZE(24);
        titleViewForPad.text = self.title;
        [self.view addSubview:titleViewForPad];
        
        toolBarForPad = [[PictureToolBarForPad alloc] initWithState:NO delegate:self];
        
        toolBarForPad.centerLabel.text = [NSString stringWithFormat:@"1/%d",[self.dataArray count]];
        toolBarForPad.editButton.hidden = YES;
        toolBarForPad.talkButton.hidden = YES;
        toolBarForPad.shareButton.hidden = YES;
        toolBarForPad.talkLabel.hidden = YES;
        toolBarForPad.collectButton.hidden = YES;
        [self.view addSubview:toolBarForPad];
    }
    else {
        toolBar = [[PictureToolBar alloc] initWithState:NO delegate:self];
        
        toolBar.centerLabel.text = [NSString stringWithFormat:@"1/%d",[self.dataArray count]];
        toolBar.editButton.hidden = YES;
        toolBar.talkButton.hidden = YES;
        toolBar.shareButton.hidden = YES;
        toolBar.talkLabel.hidden = YES;
        [self.view addSubview:toolBar];
    }
    
}






- (void)downloadButtonClick:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在保存";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    int a = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    __weak UIImageView *imageView = [imageViewArray objectAtIndex:a];
    UIImage *Image = [[UIImage alloc]initWithData:UIImagePNGRepresentation(imageView.image)];
    
//    NSData *gifData = [[NSData alloc]initWithData:UIImagePNGRepresentation(imageView.image)];
//    ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
//    NSDate *date = [NSDate date];
//    [al writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//        if (error) {
//            MBProgressHUD *hhud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            hhud.mode = MBProgressHUDModeText;
//            hhud.labelText = @"保存失败";
//            hhud.removeFromSuperViewOnHide = YES;
//            [hhud hide:YES afterDelay:1];
//            return ;
//        }
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"保存成功";
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:1];
//    }];
    
    
    
    UIImageWriteToSavedPhotosAlbum(Image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    NSString *msg = nil;
    
    if(error != NULL) {
        msg = @"保存图片失败";
        NSMutableDictionary *event =
        [[GAIDictionaryBuilder createEventWithCategory:@"报错"
                                                action:@"保存图片失败"
                                                 label:[NSString stringWithFormat:@"保存图片失败%@",self.title]
                                                 value:nil] build];
        [[GAI sharedInstance].defaultTracker send:event];
        [[GAI sharedInstance] dispatch];
        [MobClick event:[NSString stringWithFormat:@"保存图片失败%@",self.title]];
        
        
    }
    else {
        msg = @"保存图片成功";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) {
        nowScrollView.zoomScale = 1.0;
        int number = (scrollView.contentOffset.x / scrollView.frame.size.width);
        nowImageView = [imageViewArray objectAtIndex:number];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            toolBarForPad.centerLabel.text = [NSString stringWithFormat:@"%d/%d",number + 1, [self.dataArray count]];
        }
        else {
            toolBar.centerLabel.text = [NSString stringWithFormat:@"%d/%d",number + 1, [self.dataArray count]];
            
        }
    }
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    if (scrollView.tag >= 1000) {
        
        //NSLog(@"scrollViewDidEndZooming");
        CGFloat zs = scrollView.zoomScale;
        zs = MAX(zs, 1.0);                // 捏合最小
        zs = MIN(zs, 2.0);                // 捏合最大
        
        scrollView.zoomScale = zs;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    //NSLog(@"viewForZoomingInScrollView");
    if (scrollView.tag >= 1000) {
        nowScrollView = scrollView;
        return nowImageView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [[UIApplication sharedApplication] statusBarOrientation];
    }
    else {
        return UIInterfaceOrientationPortrait;
    }
}


@end
