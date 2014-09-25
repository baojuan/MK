//
//  NSString+PRPURLAdditions.m
//  MoFang
//
//  Created by 鲍娟 on 13-8-14.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import "NSString+PRPURLAdditions.h"

@implementation NSString (PRPURLAdditions)
- (NSString *)prp_percentEscapedStringWithEncoding:(NSStringEncoding)enc additionalCharacters:(NSString *)add ignoredCharacters:(NSString *)ignore
{
    CFStringEncoding convertEncoding = CFStringConvertNSStringEncodingToEncoding(enc);
    
    __autoreleasing NSString *str=(__bridge_transfer NSString * )CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)ignore, (CFStringRef)add, convertEncoding);
    
    
    return str;
}


- (NSString *)prp_URLEncodedFormStringUsingEncoding:(NSStringEncoding)enc
{
    NSString *escapedStringWithSpaces = [self prp_percentEscapedStringWithEncoding:enc additionalCharacters:@"&=+" ignoredCharacters:nil];
    return escapedStringWithSpaces;
}
@end
