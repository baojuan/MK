//
//  DownloadCell.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-8.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "DownloadCell.h"

#define SCREEN ([UIScreen mainScreen].bounds.size)
#define SCREEN_EXTRA_HEIGHT (UIScreen mainScreen].bounds.size.height - 480.0f)
#define EXTRA_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7?20.0f:0.0f)



@implementation DownloadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 15)];
        self.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1];
        self.titleLabel.lineBreakMode = NSLineBreakByClipping;
        self.titleLabel.text = @"123343534565";
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 100, 13)];
        self.detailLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
        self.detailLabel.textColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
        self.detailLabel.lineBreakMode = NSLineBreakByClipping;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.text = @"123434";
        [self.contentView addSubview:self.detailLabel];
        
        self.downloadStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 38, 105, 13)];
        self.downloadStateLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
        self.downloadStateLabel.textColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
        self.downloadStateLabel.lineBreakMode = NSLineBreakByClipping;
        self.downloadStateLabel.text = @"正在下载 0KB/S";
        self.downloadStateLabel.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.downloadStateLabel];
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 38, 28, 13)];
        self.progressLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
        self.progressLabel.textColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
        self.progressLabel.lineBreakMode = NSLineBreakByClipping;
        self.progressLabel.text = @"0%";
        self.progressLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.progressLabel];

        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 60, 255, 2)];
        self.progressView.progressTintColor = [UIColor redColor];
        self.progressView.progress = 0.4f;
        [self.contentView addSubview:self.progressView];
        
        
        self.backimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DownloadButtonBackground"]];
        self.backimageView.frame = CGRectMake(275, 24 + 5, self.backimageView.frame.size.width, self.backimageView.frame.size.height);
        [self.contentView addSubview:self.backimageView];
        
        
        self.beginStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.beginStopButton.frame = self.backimageView.frame;
        self.beginStopButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.beginStopButton];
        [self.beginStopButton setImage:[UIImage imageNamed:@"downloadbeginbutton"] forState:UIControlStateNormal];
        [self.beginStopButton setImage:[UIImage imageNamed:@"downloadstopButton"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.beginStopButton];
        
        
        
//        self.totalCacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(534 / 2.0, 39, 45, 12)];
//        self.totalCacheLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
//        self.totalCacheLabel.textColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
//        self.totalCacheLabel.lineBreakMode = NSLineBreakByClipping;
//        self.totalCacheLabel.text = @"12.3M";
//        self.totalCacheLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.totalCacheLabel];
        
        
        
    }
    return self;
}

- (void)stateFirstButtonClick
{
    self.backimageView.hidden = YES;
    self.beginStopButton.hidden = YES;
    self.progressView.hidden = YES;
    self.downloadStateLabel.hidden = YES;
    self.progressLabel.hidden = YES;
//    self.totalCacheLabel.hidden = NO;
}

- (void)stateSecondButtonClick
{
    self.backimageView.hidden = NO;
    self.beginStopButton.hidden = NO;
    self.progressView.hidden = NO;
    self.downloadStateLabel.hidden = NO;
    self.progressLabel.hidden = NO;
//    self.totalCacheLabel.hidden = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
