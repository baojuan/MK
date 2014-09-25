//
//  DownloadCell.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-8.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UILabel *downloadStateLabel;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UIButton *beginStopButton;
@property (nonatomic, strong)UIImageView *backimageView;
//@property (nonatomic, strong)UILabel *totalCacheLabel;
@property (nonatomic, strong)NSString *url;
- (void)stateFirstButtonClick;
- (void)stateSecondButtonClick;


@end
