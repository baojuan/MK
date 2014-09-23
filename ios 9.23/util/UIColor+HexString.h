//
//  UIColor+HexString.h
//  Shark
//
//  Created by Connect King on 11-11-15.
//  Copyright 2011年 alpha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (HexString)

/*******************这两个方法不要再继续使用，请使用后面两个方法！！！******************/
+ (UIColor *)please_do_not_call_me_again_colorWithHexString:(NSString *)stringToConvert NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
+ (UIColor *)please_do_not_call_me_again_colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
/*******************************************************************************/

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue;
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;

@end
