//
//  PartCellBottomView.m
//  MKProject
//
//  Created by baojuan on 14-7-15.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "PartCellBottomView.h"

@implementation PartCellBottomView
{
    NSString *commentId;
}

- (id)initWithSimple:(BOOL)simple
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = RECT(0, 0, SCREEN_WIDTH, 74 / 2.0);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.frame = RECT(0, 0, 470, 74 / 2.0);

        }
        if (simple) {
            self.frame = RECT(0, 0, 320, 74 / 2.0);
        }
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, self.frame.size.width, 0.5)];
        view.backgroundColor = RGBCOLOR(224, 224, 224);
        [self addSubview:view];
        
        
        CGFloat width1 = 77.5 / 320 * self.frame.size.width;
        CGFloat width2 = 55.0 / 320 * self.frame.size.width;
        
        
        
        self.goodButton = [self buttonForPartWithSelector:@selector(buttonClick:) imagename:@"partgood" title:@"0"];
        [self.goodButton setImage:IMAGENAMED(@"icon_good_down") forState:UIControlStateSelected];
        self.goodButton.frame = RECT(0, 0, width1, self.frame.size.height);
//        if (!simple) {
            [self addSubview:self.goodButton];;

//        }
        
        
        self.talkButton = [self buttonForPartWithSelector:@selector(buttonClick:) imagename:@"partcomment" title:@"0"];
        self.talkButton.frame = RECT(width1, 0, width1, self.frame.size.height);
//        if (!simple) {
            [self addSubview:self.talkButton];
            
//        }
        
        
        
        self.reportButton = [self buttonWithSelector:@selector(buttonClick:) imagename:@"newsReportButton" title:nil];
        self.reportButton.frame = RECT(width1 * 2, 0, width2, self.frame.size.height);
        [self addSubview:self.reportButton];
        
        
        

        
        
        self.collectButton = [self buttonWithSelector:@selector(buttonClick:) imagename:@"partheart" title:nil];
        [self.collectButton setImage:IMAGENAMED(@"partheartS") forState:UIControlStateSelected];
        self.collectButton.frame = RECT(width1 * 2 + width2, 0, width2, self.frame.size.height);
        [self addSubview:self.collectButton];
        
        
        
        
        self.shareButton = [self buttonWithSelector:@selector(buttonClick:) imagename:@"partshare" title:nil];
        self.shareButton.frame = RECT(width1 * 2 + width2 * 2, 3, width2, 30);
        [self addSubview:self.shareButton];
        
        UIView *view1 = [[UIView alloc] initWithFrame:RECT(self.goodButton.frame.size.width + self.goodButton.frame.origin.x - 0.5, 6, 0.5, self.frame.size.height-12)];
        view1.backgroundColor = RGBCOLOR(224, 224, 224);
        //        if (!simple) {
        [self addSubview:view1];
        
        //        }
        
        UIView *view2 = [[UIView alloc] initWithFrame:RECT(self.talkButton.frame.size.width + self.talkButton.frame.origin.x - 0.5, 6, 0.5, self.frame.size.height-12)];
        view2.backgroundColor = RGBCOLOR(224, 224, 224);
        //        if (!simple) {
        [self addSubview:view2];
        //        }
        

        
        UIView *view5 = [[UIView alloc] initWithFrame:RECT(self.reportButton.frame.size.width + self.reportButton.frame.origin.x - 0.5, 6, 0.5, self.frame.size.height-12)];
        view5.backgroundColor = RGBCOLOR(224, 224, 224);;
        [self addSubview:view5];
        
        
        UIView *view3 = [[UIView alloc] initWithFrame:RECT(self.collectButton.frame.size.width + self.collectButton.frame.origin.x - 0.5, 6, 0.5, self.frame.size.height-12)];
        view3.backgroundColor = RGBCOLOR(224, 224, 224);;
        [self addSubview:view3];
        
        
//        UIView *view4 = [[UIView alloc] initWithFrame:RECT(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
//        view4.backgroundColor = RGBCOLOR(224, 224, 224);
//        [self addSubview:view4];
    }
    return self;

}

- (id)init
{
    return [self initWithSimple:NO];
}

- (UIButton *)buttonWithSelector:(SEL)selector imagename:(NSString *)imagename title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor: RGBCOLOR(167, 167, 167) forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE(13);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    return button;
}


- (PartBottomButton *)buttonForPartWithSelector:(SEL)selector imagename:(NSString *)imagename title:(NSString *)title
{
    PartBottomButton *button = [PartBottomButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor: RGBCOLOR(167, 167, 167) forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE(13);
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    return button;
}



- (void)insertIntoDataGoodNumber:(NSString *)goodNumber commentNumber:(NSString *)commentNumber isCollect:(BOOL)isCollect
{
    [self.goodButton setTitle:goodNumber forState:UIControlStateNormal];
    [self.talkButton setTitle:commentNumber forState:UIControlStateNormal];
    self.collectButton.selected = isCollect;
}

- (void)buttonClick:(UIButton *)button
{
    if (button == self.shareButton) {
        [self.delegate partCellBottomButtonShareButtonClick:button];
    }
    if (button == self.goodButton) {
        button.selected = YES;
        [self.delegate partCellBottomButtonGoodButtonClick:button];
        return;
    }
    if (button == self.collectButton) {
        [self.delegate partCellBottomButtonCollectButtonClick:button];
    }
    if (button == self.talkButton) {
        [self.delegate partCellBottomButtonTalkClick:button];
    }
    if (button == self.reportButton) {
        [self.delegate partCellBottomButtonReportButtonClick:button];
    }

    button.selected = !button.selected;
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
