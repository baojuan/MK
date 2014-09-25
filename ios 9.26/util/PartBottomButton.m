//
//  PartBottomButton.m
//  MKProject
//
//  Created by baojuan on 14-7-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "PartBottomButton.h"

@implementation PartBottomButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return RECT(10, (self.frame.size.height - 25) / 2.0, 25, 25);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return RECT(47, 0, self.frame.size.width - 47, self.frame.size.height);
}
@end
