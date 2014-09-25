//
//  MKButton.m
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "MKButton.h"

@implementation MKButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return RECT((self.frame.size.width - 57 / 2.0) / 2.0, 5, 57 / 2.0, 49 / 2.0);
    }
    else {
        return RECT((self.frame.size.width - 25) / 2.0, 5, 25, 35);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return RECT(0, 49 - 5 - 10, self.frame.size.width, 20);
    }
    else {

        return RECT(0, 49 - 5 - 20, self.frame.size.width, 20);
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
