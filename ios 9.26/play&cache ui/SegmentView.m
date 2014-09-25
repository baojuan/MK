//
//  SegmentView.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-4.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "SegmentView.h"

 #define BACKGROUND @"segBackground"


@implementation SegmentView

- (id)initWithFrame:(CGRect)frame buttonArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.buttonArray = array;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:BACKGROUND];
        [self addSubview:imageView];
        CGFloat width = frame.size.width * 1.0 / [array count];
        for (int i = 0; i < [array count]; i++) {
            UIButton *button = [array objectAtIndex:i];
            button.frame = CGRectMake(i * width + 2, 1, width - 4, self.frame.size.height - 2);
            [self addSubview:button];
        }
    }
    return self;
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
