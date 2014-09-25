//
//  BlurView.m
//  BlurViewTest
//
//  Created by baojuan on 14-7-9.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "BlurView.h"
#import "UIImage+ImageEffects.h"
@implementation BlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 1.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 1, -1);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.image = [image applyDarkEffect];
        
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
