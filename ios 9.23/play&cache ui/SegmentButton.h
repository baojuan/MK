//
//  SegmentButton.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-4.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentButton : UIButton
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect textFrame;

- (id)initWithTextButtonTitle:(NSString *)title Delegate:(id)delegate Selector:(SEL)selector;
- (id)initWithImageButtonImage:(UIImage *)image  Delegate:(id)delegate Selector:(SEL)selector;
- (id)initWithImageAndTextUpDownTitle:(NSString *)title Image:(UIImage *)image  Delegate:(id)delegate Selector:(SEL)selector;
- (id)initWithImageAndTextLeftRightTitle:(NSString *)title Image:(UIImage *)image  Delegate:(id)delegate Selector:(SEL)selector;
@end
