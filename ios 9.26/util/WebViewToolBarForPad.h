//
//  WebViewToolBarForPad.h
//  MKProject
//
//  Created by baojuan on 14-7-10.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewToolBarForPad : UIView
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIButton *allbackButton;
@property (nonatomic, strong) UIButton *collectButton;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *talkButton;
@property (nonatomic, strong) UILabel *talkLabel;
- (id)initWithState:(BOOL)isSimple delegate:(id)delegate;
@end
