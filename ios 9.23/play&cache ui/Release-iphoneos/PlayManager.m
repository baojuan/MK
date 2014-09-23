//
//  PlayManager.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-11.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "PlayManager.h"
static PlayManager *gl_manager = Nil;
@implementation PlayManager

+ (PlayManager *)shareManager
{
    if (!gl_manager) {
        gl_manager = [[PlayManager alloc] init];
    }
    return gl_manager;
}

- (id)init
{
    if (self = [super init]) {
        NSString* msAK=@"j6KXbaOu8cGM8oiBjAEvE49q";
        NSString* msSK=@"biFdX0ILp9pqyreI1rrYbU9cbNYBSFr2";
        [[CyberPlayerController class] setBAEAPIKey:msAK SecretKey:msSK];
        _cbPlayerController = [[CyberPlayerController alloc] init];
    }
    return self;
}

@end
