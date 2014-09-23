//
//  NSString+FanZhuan.m
//  MKProject
//
//  Created by baojuan on 14-7-27.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "NSString+FanZhuan.h"

@implementation NSString (FanZhuan)
+(NSString *)fanZhuan:(NSString *)str
{
    
    unsigned long len;
    len = [str length];
    unichar a[len];
    for(int i = 0; i < len; i++)
    {
        unichar c = [str characterAtIndex:len-i-1];
        a[i] = c;
    }
    NSString *str1=[NSString stringWithCharacters:a length:len];
    return  str1;
}

+ (NSString *)changePriceFormat:(NSString *)str
{
    NSString *string = [NSString fanZhuan:str];
    unsigned long len;
    len = [string length];
    unichar a[len];
    int j = 0;
    for(int i = 0; i < len; i++)
    {
        unichar c = [str characterAtIndex:len-i-1];
        if (i % 3 == 2 && (i + 1 < len)) {
            a[j] = c;
            j ++;
            a[j] = ',';
            j ++;
            continue;
        }
        a[j] = c;
        j ++;
    }
    NSString *str1=[NSString stringWithCharacters:a length:j];

    return [NSString fanZhuan:str1];
}

@end
