//
//  UpDownButton.m
//  MKProject
//
//  Created by baojuan on 14-7-10.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "UpDownButton.h"

@implementation UpDownButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return RECT((self.frame.size.width - 48) / 2.0, 5, 48, 48);
    }
    else {
        return RECT((self.frame.size.width - 30) / 2.0, 5, 30, 30);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return RECT(0, self.frame.size.height - 5 - 20, self.frame.size.width, 20);
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
