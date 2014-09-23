//
//  VideoDefinitionChooseButton.m
//  猫咪物语
//
//  Created by 鲍娟 on 14-6-25.
//  Copyright (c) 2014年 et. All rights reserved.
//

#import "VideoDefinitionChooseButton.h"

@implementation VideoDefinitionChooseButton

- (id)initWithFrame:(CGRect)frame Delegate:(id)delegate buttonFrame:(CGRect)rect
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chooseButton.frame = CGRectMake(0, frame.size.height - rect.size.height, rect.size.width, rect.size.height);
        [self.chooseButton setTitle:@"高清" forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1] forState:UIControlStateNormal];
        self.chooseButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self setBackgroundImage:[UIImage imageNamed:@"definition"] forState:UIControlStateNormal];
        [self.chooseButton addTarget:self action:@selector(chooseButtonControlBackgroundHidden) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.chooseButton];
        
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 45) / 2.0, 0, 45, 148)];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        self.backgroundView.hidden = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volumnBackgroundPlay"]];
        imageView.transform = CGAffineTransformMakeRotation(180 * (M_PI / 180.0));
        imageView.frame = CGRectMake(0, rect.size.height, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
        [self.backgroundView addSubview:imageView];
        
        
        CGFloat height = 138 / 3.0;
        
        self.button3 = [self setButton:self.button3 title:@"超清" tag:102 delegate:delegate];
        self.button3.frame = CGRectMake(0, rect.size.height, self.backgroundView.frame.size.width, height);
        [self.backgroundView addSubview:self.button3];
    
        self.button2 = [self setButton:self.button2 title:@"高清" tag:101 delegate:delegate];
        self.button2.selected = YES;
        self.button2.frame = CGRectMake(0, rect.size.height + height, self.backgroundView.frame.size.width, height);
        [self.backgroundView addSubview:self.button2];
        
        self.button1 = [self setButton:self.button1 title:@"标清" tag:100 delegate:delegate];
        self.button1.frame = CGRectMake(0, rect.size.height + height * 2, self.backgroundView.frame.size.width, height);
        [self.backgroundView addSubview:self.button1];
    }
    return self;
}

- (UIButton *)setButton:(UIButton *)button title:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:255 / 255.0 green:138 / 255.0 blue:0 alpha:1] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.tag = tag;
    [button addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)chooseButtonClick:(UIButton *)button
{
    self.button1.selected = NO;
    self.button2.selected = NO;
    self.button3.selected = NO;
    button.selected = YES;
    self.backgroundView.hidden = YES;
    NSString *name;
    switch (button.tag) {
        case 100:
            name = @"标清";
            break;
        case 101:
            name = @"高清";
            break;
        case 102:
            name = @"超清";
            break;
    
        default:
            break;
    }
    [self.chooseButton setTitle:name forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(ChooseDefinition:)]) {
        [self.delegate performSelector:@selector(ChooseDefinition:) withObject:[NSNumber numberWithInt:button.tag]];
    }
}

- (void)chooseButtonControlBackgroundHidden
{
    [self backgroundViewHiddenOrNot:!self.backgroundView.hidden];
}

- (void)backgroundViewHiddenOrNot:(BOOL)hidden
{
    self.backgroundView.hidden = hidden;
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
