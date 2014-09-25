//
//  CachingView.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-11.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "CachingView.h"

#define SCREEN ([UIScreen mainScreen].bounds.size)
#define SCREEN_EXTRA_HEIGHT (UIScreen mainScreen].bounds.size.height - 480.0f)
#define EXTRA_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7?20.0f:0.0f)


@implementation CachingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake((SCREEN.height - 100) / 2.0, (SCREEN.width - 100) / 2.0, 100, 100);
        self.backgroundColor = [UIColor blackColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50) / 2.0, 15, 50, 50)];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:activity];
        [activity startAnimating];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20 - 10, self.frame.size.width, 20)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:12];
        self.label.text = @"请稍后...";
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
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

@end
