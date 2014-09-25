//
//  VideoDefinitionChooseButton.h
//  猫咪物语
//
//  Created by 鲍娟 on 14-6-25.
//  Copyright (c) 2014年 et. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDefinitionChooseButton : UIView
@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) id delegate;
- (id)initWithFrame:(CGRect)frame Delegate:(id)delegate buttonFrame:(CGRect)rect;
- (void)backgroundViewHiddenOrNot:(BOOL)hidden;
@end
