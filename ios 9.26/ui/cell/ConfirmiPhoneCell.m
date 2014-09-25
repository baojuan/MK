//
//  ConfirmiPhoneCell.m
//  MKProject
//
//  Created by baojuan on 14-6-27.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ConfirmiPhoneCell.h"

@implementation ConfirmiPhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = FONTSIZE(14);
        self.textLabel.textColor = [UIColor whiteColor];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:IMAGENAMED(@"right") forState:UIControlStateNormal];
        [self.button setImage:IMAGENAMED(@"add") forState:UIControlStateSelected];
        self.button.frame = RECT(0, 0, 45 / 2.0, 45 / 2.0);
        self.accessoryView = self.button;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
