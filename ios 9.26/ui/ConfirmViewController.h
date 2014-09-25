//
//  ConfirmViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-27.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : UIViewController
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSString *typeId;
- (id)initWithTypeId:(NSString *)typeId;
@end
