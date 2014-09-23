//
//  LeftBottomView.m
//  MKProject
//
//  Created by baojuan on 14-8-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "LeftBottomView.h"


@implementation LeftBottomView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.frame = RECT(0, SCREEN_WIDTH - 49, 320, 49);
        }
        else {
            self.frame = RECT(0, SCREEN_HEIGHT - 49, 277, 49);

        }
        self.backgroundColor = RGBCOLOR(234, 234, 234);
        
        CGFloat buttonWidth = self.frame.size.width / 5.0;

        self.historyButton = [self buttonWithSelector:@selector(historyButtonClick:) imagename:@"left_history"];
        self.historyButton.frame = RECT(0, 0, buttonWidth, self.frame.size.height);
        [self addSubview:self.historyButton];
        
        
        self.collectionButton = [self buttonWithSelector:@selector(collectionButtonClick:) imagename:@"left_collection"];
        self.collectionButton.frame = RECT(buttonWidth, 0, buttonWidth, self.frame.size.height);
        [self addSubview:self.collectionButton];
        
        self.subscriptionButton = [self buttonWithSelector:@selector(subscriptionButtonClick:) imagename:@"left_subscription"];
        self.subscriptionButton.frame = RECT(buttonWidth * 2, 0, buttonWidth, self.frame.size.height);
        [self addSubview:self.subscriptionButton];
        
        
        self.sortButton = [self buttonWithSelector:@selector(sortButtonClick:) imagename:@"left_sort"];
        [self.sortButton setImage:IMAGENAMED(@"left_sort_commit") forState:UIControlStateSelected];
        self.sortButton.frame = RECT(buttonWidth * 3, 0, buttonWidth, self.frame.size.height);
        [self addSubview:self.sortButton];

        
        self.searchButton = [self buttonWithSelector:@selector(searchButtonClick:) imagename:@"left_search"];
        self.searchButton.frame = RECT(buttonWidth * 4, 0, buttonWidth, self.frame.size.height);
        [self addSubview:self.searchButton];

        
    }
    return self;
}


- (UIButton *)buttonWithSelector:(SEL)selector imagename:(NSString *)imagename
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self.delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    return button;
}

- (void)sortButtonState:(BOOL)selected
{
    if (selected) {
        self.searchButton.hidden = YES;
        self.historyButton.hidden = YES;
        self.collectionButton.hidden = YES;
        self.subscriptionButton.hidden = YES;
        self.sortButton.selected = YES;
    }
    else {
        self.searchButton.hidden = NO;
        self.historyButton.hidden = NO;
        self.collectionButton.hidden = NO;
        self.subscriptionButton.hidden = NO;
        self.sortButton.selected = NO;
    }
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
