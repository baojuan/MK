//
//  MKNavigationView.h
//  MKProject
//
//  Created by baojuan on 14-6-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKNavigationView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

/**
 *  导航条 默认左侧是返回按钮
 *
 *  @param title      title
 *  @param rightImage 右侧图片
 *  @param Forpad pad
 *  @param ForPadFullScreen 全屏
 *
 *  @return return
 */
- (id)initWithTitle:(NSString *)title rightButtonImage:(UIImage *)rightImage ForPad:(BOOL)ForPad ForPadFullScreen:(BOOL)fullScreen;

/**
 *  导航条
 *
 *  @param title      title
 *  @param leftImage  左侧图片
 *  @param rightImage 右侧图片
 *  @param Forpad pad
 *  @param ForPadFullScreen 全屏
 *
 *  @return return
 */
- (id)initWithTitle:(NSString *)title leftButtonImage:(UIImage *)leftImage rightButtonImage:(UIImage *)rightImage ForPad:(BOOL)ForPad ForPadFullScreen:(BOOL)fullScreen;

/**
 *  导航条 左侧返回 右侧无
 *
 *  @param title title
 *  @param Forpad pad
 *  @param ForPadFullScreen 全屏
 *
 *  @return return
 */
- (id)initWithTitle:(NSString *)title ForPad:(BOOL)ForPad ForPadFullScreen:(BOOL)fullScreen;


@end
