//
//  NewsiPhoneCell.m
//  MKProject
//
//  Created by baojuan on 14-6-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "NewsiPhoneCell.h"

@implementation NewsiPhoneCell
{
    AppDelegate *appdelegate;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForSmall:(BOOL)small ForRight:(BOOL)right
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        appdelegate = APPDELEGATE;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *selectView = [[UIView alloc] init];
        selectView.backgroundColor = appdelegate.cellSelectedColor;
        self.selectedBackgroundView = selectView;

        self.videoImageView = [[UIImageView alloc] initWithFrame:RECT(10, 11, 102, 58)];
        self.videoImageView.backgroundColor = [UIColor redColor];
        self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.videoImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.videoImageView];
        
        UIImageView *ttImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"playImageBack")];
        ttImageView.frame = RECT(0, self.videoImageView.frame.size.height - ttImageView.frame.size.height, self.videoImageView.frame.size.width, ttImageView.frame.size.height);
//        [self.videoImageView addSubview:ttImageView];

        self.duringLabel = [[UILabel alloc] initWithFrame:RECT(0, ttImageView.frame.origin.y, ttImageView.frame.size.width - 3, ttImageView.frame.size.height)];
        self.duringLabel.backgroundColor = [UIColor clearColor];
        self.duringLabel.textAlignment = NSTextAlignmentRight;
        self.duringLabel.font = FONTSIZE(10);
        self.duringLabel.textColor = RGBCOLOR(217, 217, 217);
        [self.videoImageView addSubview:self.duringLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.videoImageView.frame.origin.y, SCREEN_WIDTH - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10), 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = appdelegate.h1Color;
        self.titleLabel.font = FONTSIZE(appdelegate.h1FontSize);
        self.titleLabel.numberOfLines = 1;
        [self.contentView addSubview:self.titleLabel];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"newsButtonIcon")];
        imageView.frame = RECT(self.titleLabel.frame.origin.x, self.videoImageView.frame.origin.y + self.videoImageView.frame.size.height - imageView.frame.size.height, imageView.frame.size.width, imageView.frame.size.height);
        [self.contentView addSubview:imageView];
        
        
        self.playCountLabel = [[UILabel alloc] initWithFrame:RECT(imageView.frame.origin.x + imageView.frame.size.width + 2 + 4, imageView.frame.origin.y, 100, imageView.frame.size.height)];
        self.playCountLabel.backgroundColor = [UIColor clearColor];
        self.playCountLabel.font = FONTSIZE(11);
        self.playCountLabel.textColor = RGBCOLOR(183, 183, 183);
        [self.contentView addSubview:self.playCountLabel];
        
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:RECT(320 - 10 - 100, self.playCountLabel.frame.origin.y, 100, self.playCountLabel.frame.size.height)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = FONTSIZE(11);
        self.dateLabel.textColor = RGBCOLOR(183, 183, 183);
        [self.contentView addSubview:self.dateLabel];
        
        
//        self.descriptionLabel = [[UILabel alloc] initWithFrame:RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y, SCREEN_WIDTH - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10), 40)];
//        self.descriptionLabel.backgroundColor = [UIColor clearColor];
//        self.descriptionLabel.textColor = appdelegate.descriptionColor;
//        self.descriptionLabel.font = FONTSIZE(appdelegate.descriptionFontSize);
//        self.descriptionLabel.numberOfLines = 2;
//        [self.contentView addSubview:self.descriptionLabel];

        
        if (!right) {
            self.titleLabel.frame = RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.videoImageView.frame.origin.y, 470 - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10), 20);
            self.descriptionLabel.frame = RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y, 470 - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10), 40);
            self.dateLabel.frame = RECT(470 - 10 - 100, self.playCountLabel.frame.origin.y, 100, self.playCountLabel.frame.size.height);
        }
        if (small) {
            self.titleLabel.frame = RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.videoImageView.frame.origin.y, 320 - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10), 20);
            self.descriptionLabel.frame = RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y, 320 - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10), 40);

        }

        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [self initWithStyle:style reuseIdentifier:reuseIdentifier ForSmall:NO ForRight:NO];

    }
    else {
        return [self initWithStyle:style reuseIdentifier:reuseIdentifier ForSmall:NO ForRight:YES];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
