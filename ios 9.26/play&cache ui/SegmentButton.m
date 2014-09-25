//
//  SegmentButton.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-4.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "SegmentButton.h"
#import "AppDelegate.h"
@implementation SegmentButton
{
    BOOL isLeftRightButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTextButtonTitle:(NSString *)title Delegate:(id)delegate Selector:(SEL)selector
{
    if (self = [super init]) {
        [self addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:((AppDelegate *)[UIApplication sharedApplication].delegate).navigationColor forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
        self.textFrame = self.titleLabel.bounds;
    }
    return self;
}

- (id)initWithImageButtonImage:(UIImage *)image Delegate:(id)delegate Selector:(SEL)selector
{
    if (self = [super init]) {
        [self addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        [self setImage:image forState:UIControlStateNormal];
        self.imageFrame = self.imageView.frame;
    }
    return self;
}

- (id)initWithImageAndTextUpDownTitle:(NSString *)title Image:(UIImage *)image Delegate:(id)delegate Selector:(SEL)selector
{
    if (self = [super init]) {
        [self addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
        self.imageFrame = self.imageView.frame;
        self.textFrame = self.titleLabel.frame;
    }
    return self;
}

- (id)initWithImageAndTextLeftRightTitle:(NSString *)title Image:(UIImage *)image Delegate:(id)delegate Selector:(SEL)selector
{
    if (self = [super init]) {
        [self addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
        isLeftRightButton = YES;
        self.imageFrame = self.imageView.frame;
        self.textFrame = self.titleLabel.frame;

    }
    return self;
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    if (isLeftRightButton) {
//        return CGRectMake((self.frame.size.width - self.imageView.frame.size.width) / 2.0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
//    }
//    
//    return self.imageFrame;
//}

//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    if (isLeftRightButton) {
//        return CGRectMake((self.frame.size.width - self.titleLabel.frame.size.width) / 2.0, self.frame.size.height - self.titleLabel.frame.size.height, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
//    }
//    return self.textFrame;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
