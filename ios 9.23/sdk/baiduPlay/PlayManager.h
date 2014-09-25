//
//  PlayManager.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-11.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CyberPlayerController.h"

@interface PlayManager : NSObject
@property (nonatomic, strong) CyberPlayerController *cbPlayerController;
+ (PlayManager *)shareManager;


@end
