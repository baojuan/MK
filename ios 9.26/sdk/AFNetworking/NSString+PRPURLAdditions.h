//
//  NSString+PRPURLAdditions.h
//  MoFang
//
//  Created by 鲍娟 on 13-8-14.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PRPURLAdditions)
- (NSString *)prp_URLEncodedFormStringUsingEncoding:(NSStringEncoding)enc;
@end
