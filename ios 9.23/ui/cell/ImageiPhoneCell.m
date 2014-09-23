//
//  ImageiPhoneCell.m
//  MKProject
//
//  Created by baojuan on 14-6-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ImageiPhoneCell.h"

@implementation ImageiPhoneCell
{
    AppDelegate *appdelegate;
    UIImageView *specialImageView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForSmall:(BOOL)small
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        appdelegate = APPDELEGATE;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImageView *background = [[UIImageView alloc] initWithImage:IMAGENAMED(@"imageBack")];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            background.frame = RECT((470 - 445) / 2.0, 11, 445, 165);
        }
        else {
            background.frame = RECT((self.frame.size.width - background.frame.size.width) / 2.0, 11, background.frame.size.width, background.frame.size.height);
        }
        if (small) {
            background.frame = RECT((320 - 590 / 2.0) / 2.0, 11, 590 / 2.0, 330 / 2.0);
        }
        [self.contentView addSubview:background];
        self.cellImageView = [[UIImageView alloc] initWithFrame:RECT(8, 8, background.frame.size.width - 16, background.frame.size.height - 16)];
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cellImageView.clipsToBounds = YES;
        [background addSubview:self.cellImageView];
        self.cellImageView.backgroundColor = [UIColor redColor];
        
        specialImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"imageTip")];
        specialImageView.frame = RECT(0, 0, specialImageView.frame.size.width, specialImageView.frame.size.height);
        [background addSubview:specialImageView];
        
        
        UIImageView *cellBottomImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"imagecellBottom")];
        cellBottomImageView.frame = RECT(0, self.cellImageView.frame.size.height - cellBottomImageView.frame.size.height, self.cellImageView.frame.size.width, cellBottomImageView.frame.size.height);
        [self.cellImageView addSubview:cellBottomImageView];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:cellBottomImageView.frame];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = FONTSIZE(appdelegate.h1FontSize);
        self.titleLabel.numberOfLines = 1;
        [self.cellImageView addSubview:self.titleLabel];
        
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier ForSmall:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
