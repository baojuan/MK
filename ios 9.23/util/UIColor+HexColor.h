//
//  UIColor+HexColor.h
//  MKProject
//
//  Created by baojuan on 14-7-13.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
