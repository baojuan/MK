//
//  UrlRequest.m
//  MKProject
//
//  Created by baojuan on 14-6-27.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "UrlRequest.h"
#import "NSString+PRPURLAdditions.h"
#import "AFHTTPRequestOperation.h"
@implementation UrlRequest

- (void)urlRequestWithGetUrl:(NSString *)url delegate:(id)delegate finishMethod:(NSString *)finishMethod failMethod:(NSString *)failMethod
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        if ([operation.response statusCode] != 200)
        {
            if ([delegate respondsToSelector:NSSelectorFromString(failMethod)]) {
                [delegate performSelector:NSSelectorFromString(failMethod) withObject:Nil];
            }
        }
        if ([delegate respondsToSelector:NSSelectorFromString(finishMethod)]) {
            [delegate performSelector:NSSelectorFromString(finishMethod) withObject:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([delegate respondsToSelector:NSSelectorFromString(failMethod)]) {
            [delegate performSelector:NSSelectorFromString(failMethod) withObject:error];
        }
    }];
    [operation start];
}

- (void)urlRequestWithPostUrl:(NSString *)url delegate:(id)delegate dict:(NSDictionary *)dict finishMethod:(NSString *)finishMethod failMethod:(NSString *)failMethod
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSString *paramKey in dict)
    {
        if ([paramKey length] > 0)
        {
            NSStringEncoding enc=NSUTF8StringEncoding;
            NSString *value = [dict objectForKey:paramKey];
            NSString *encodedValue = [value prp_URLEncodedFormStringUsingEncoding:enc];
            NSString *paramFormat = @"%@=%@";
            [post appendFormat:paramFormat,paramKey,encodedValue];
        }
    }
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        if ([delegate respondsToSelector:NSSelectorFromString(finishMethod)]) {
            [delegate performSelector:NSSelectorFromString(finishMethod) withObject:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([delegate respondsToSelector:NSSelectorFromString(failMethod)]) {
            [delegate performSelector:NSSelectorFromString(failMethod) withObject:error];
        }
    }];
    [operation start];
}


@end
