//
//  ScanPictureView.m
//  ImageScanViewController
//
//  Created by 鲍娟 on 14-7-2.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "ScanPictureView.h"
#import "GDataXMLNode.h"
#import "MKNavigationView.h"
#import "PictureToolBar.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"
@implementation ScanPictureView
{
    AppDelegate *appdelegate;
    BOOL getDataComplete;
    BOOL viewAppearComplete;
    ArticleModel *item;
    PictureToolBar *toolBar;
}

- (id)initWithUrl:(NSString *)string rect:(CGRect)rect ArticleModel:(ArticleModel *)model
{
    if (self = [super init]) {
        item = model;
        self.frame = rect;
        appdelegate = APPDELEGATE;
        self.url = string;
        self.dataArray = [[NSMutableArray alloc] init];
        [self getData];
        self.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        [self changyan];
    }
    return self;
}

- (void)getData
{
    UrlRequest *request = [[UrlRequest alloc] init];
    [request urlRequestWithGetUrl:self.url delegate:self finishMethod:@"finishMethod:" failMethod:@"failMethod:"];
}

- (void)finishMethod:(NSData *)data
{
    GDataXMLDocument *pagedoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:Nil];
    
    NSArray *employees = [pagedoc nodesForXPath:@"//article" error:NULL];
    
    for (GDataXMLElement *employe in employees) {
        NSString *String = [[employe attributeForName:@"p"] stringValue];
        [self.dataArray addObject:String];
    }
    getDataComplete = YES;
    [self setScrollViewProperty];
}
- (void)failMethod:(NSError *)error
{
    MKLog(@"error:%@",error);
}


- (void)tap
{
    _navigationView.hidden = !_navigationView.hidden;
    toolBar.hidden = !toolBar.hidden;

    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
}

- (void)viewAnimationComplete
{
    viewAppearComplete = YES;
    if (getDataComplete) {
        _navigationView.hidden = NO;
        _scrollView.hidden = NO;
        toolBar.hidden = NO;
    }
}


- (void)setHeadView
{
    
    BOOL iscollect = [self isCollectOrNot:item.articleId];

    
    _navigationView = [[MKNavigationView alloc] initWithTitle:LOCAL_LANGUAGE(@"content") rightButtonImage:IMAGENAMED(@"articleCollect") ForPad:NO ForPadFullScreen:NO];
    if (!viewAppearComplete) {
        self.scrollView.hidden = YES;
    }
    [_navigationView.rightButton setImage:IMAGENAMED(@"articleCollectSelect") forState:UIControlStateSelected];
    _navigationView.rightButton.selected = iscollect;
    [_navigationView.rightButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_navigationView];
    
}


- (BOOL)isCollectOrNot:(NSString *)articleId
{
    NSArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT] objectForKey:LOCAL_LANGUAGE(@"picture")];
    BOOL isCollect = NO;
    for (NSDictionary *dd in arr) {
        if ([item.articleId isEqualToString:[dd objectForKey:@"articleId"]]) {
            isCollect = YES;
        }
    }
    return isCollect;
}


- (void)backButtonClick
{
    [self removeFromSuperview];
}


- (void)collectionButtonClick:(UIButton *)button
{
    if (button.selected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已收藏";
        [hud hide:YES afterDelay:1];
        return;
    }
    button.selected = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:LOCAL_LANGUAGE(@"picture")]];;
    
    [array addObject:[ModelExChangeDictionary modelChangeToDictionary:item]];
    [dict setObject:array forKey:LOCAL_LANGUAGE(@"picture")];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:COLLECT_USERDEFAULT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"收藏成功";
    [hud hide:YES afterDelay:1];
}



- (void)setScrollViewProperty
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (!viewAppearComplete) {
        self.scrollView.hidden = YES;
    }
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = SIZE(self.scrollView.frame.size.width * [_dataArray count], self.scrollView.frame.size.height);
    for (int i = 0; i < [_dataArray count]; i ++) {
        NSString *string = [_dataArray objectAtIndex:i];
         UIImageView * imageView = [[UIImageView alloc] initWithFrame:RECT(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        __weak UIImageView * anotherImageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        [imageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:IMAGENAMED(@"placeholderImage") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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
            CGFloat scaleNumber = (image.size.width > image.size.height) ? (SCREEN_WIDTH - space) * 1.0 / image.size.width : SCREEN_HEIGHT * 1.0 / image.size.height;

            anotherImageView.frame = RECT(anotherImageView.frame.origin.x + space / 2.0 + (self.scrollView.frame.size.width - space - image.size.width * scaleNumber) / 2.0, (self.scrollView.frame.size.height - image.size.height * scaleNumber) / 2.0, image.size.width * scaleNumber, image.size.height * scaleNumber);
        }];
        
        [self.scrollView addSubview:imageView];
    }
    [self addSubview:self.scrollView];
    [self setHeadView];
    [self setBottomView];

}


- (void)setBottomView
{
    toolBar = [[PictureToolBar alloc] initWithState:NO delegate:self];
    if (!viewAppearComplete) {
        toolBar.hidden = YES;
    }
    toolBar.centerLabel.text = [NSString stringWithFormat:@"1/%d",[self.dataArray count]];
    [self addSubview:toolBar];
    [self getCommentNumber];
}

- (void)shareButtonClick:(UIButton *)button
{
    
}

- (void)talkButtonClick:(UIButton *)button
{
    CommentListViewController *comment = [[CommentListViewController alloc] initWithArticle:item articleId:self.changyanId];
    [self.delegate presentViewController:comment animated:YES completion:^{
    }];

}

- (void)editButtonClick:(UIButton *)button
{
    CommentViewController * comment = [[CommentViewController alloc] initWithArticle:item articleId:self.changyanId];
//    [self presentViewController:comment animated:YES completion:^{
//        ;
//    }];

}

- (void)downloadButtonClick:(UIButton *)button
{
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int number = (scrollView.contentOffset.x / scrollView.frame.size.width);
    toolBar.centerLabel.text = [NSString stringWithFormat:@"%d/%d",number + 1, [self.dataArray count]];
}


#pragma mark - changyan

- (void)changyan
{
    NSString *topicid = [NSString stringWithFormat:@"2_%@",item.articleId];

    [ChangyanSDK loadTopic:@"" topicTitle:@"" topicSourceID:topicid pageSize:@"0" hotSize:@"0" completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
     {
         if (statusCode != CYSuccess) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             hud.removeFromSuperViewOnHide = YES;
             [hud hide:YES afterDelay:1];
             return ;

         }

         MKLog(@"%@",responseStr);
         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         self.changyanId = [[dict objectForKey:@"topic_id"] stringValue];
     }];
}


- (void)getCommentNumber
{
    [ChangyanSDK getCommentCountTopicUrl:@"" topicSourceID:@"" topicID:self.changyanId completeBlock:^(CYStatusCode statusCode,NSString *responseStr)
     {
         if (statusCode != CYSuccess) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"获取失败";
             hud.removeFromSuperViewOnHide = YES;
             [hud hide:YES afterDelay:1];
             return ;

         }

         NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         toolBar.talkLabel.text = [[[[dict objectForKey:@"result"] objectForKey:self.changyanId] objectForKey:@"comments"] stringValue];
     }];
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
