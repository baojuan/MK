//
//  UIColor+HexString.m
//  Shark
//
//  Created by Connect King on 11-11-15.
//  Copyright 2011年 alpha. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)please_do_not_call_me_again_colorWithHexString:(NSString *)stringToConvert
{
    return [self please_do_not_call_me_again_colorWithHexString:stringToConvert alpha:1.0f];
} /* colorWithHexString */

+ (UIColor *)please_do_not_call_me_again_colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha
{
    NSString * cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha//(NSUInteger)alpha
{
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;
    //CGFloat a = alpha / 255.0;
    
    return [self colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue
{
    return [self colorWithHexValue:hexValue alpha:1.0];//255];
}

@end
