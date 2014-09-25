//
//  WebViewToolBar.h
//  猫咪物语
//
//  Created by 鲍娟 on 14-4-23.
//  Copyright (c) 2014年 et. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewToolBar : UIView
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *talkButton;
@property (nonatomic, strong) UILabel *talkLabel;
- (id)initWithState:(BOOL)isSimple delegate:(id)delegate;

@end
