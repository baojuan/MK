//
//  PictureToolBarForPad.h
//  MKProject
//
//  Created by baojuan on 14-7-10.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureToolBarForPad : UIView
@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) UIButton *allbackButton;
@property (nonatomic, strong) UIButton *collectButton;


@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *talkButton;
@property (nonatomic, strong) UILabel *talkLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIButton *downloadButton;

- (id)initWithState:(BOOL)isSimple delegate:(id)delegate;
@end
