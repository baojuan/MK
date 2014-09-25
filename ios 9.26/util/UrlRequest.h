//
//  UrlRequest.h
//  MKProject
//
//  Created by baojuan on 14-6-27.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlRequest : NSObject<NSXMLParserDelegate>
/**
 *  get 请求
 *
 *  @param url          url
 *  @param delegate     delegate
 *  @param finishMethod finishMethod
 *  @param failMethod   failMethod
 */

- (void)urlRequestWithGetUrl:(NSString *)url delegate:(id)delegate finishMethod:(NSString *)finishMethod failMethod:(NSString *)failMethod;
/**
 *  post 请求
 *
 *  @param url          url
 *  @param delegate     delegate
 *  @param dict         参数
 *  @param finishMethod finishMethod
 *  @param failMethod   failMethod
 */
- (void)urlRequestWithPostUrl:(NSString *)url delegate:(id)delegate dict:(NSDictionary *)dict finishMethod:(NSString *)finishMethod failMethod:(NSString *)failMethod;

@end
