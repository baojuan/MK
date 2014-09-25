//
//  VideoiPhoneCell.m
//  MKProject
//
//  Created by baojuan on 14-6-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "VideoiPhoneCell.h"

@implementation VideoiPhoneCell
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
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 78)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backgroundView];
        
        self.videoImageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, 102, 78)];
        self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.videoImageView.clipsToBounds = YES;
        self.videoImageView.backgroundColor = [UIColor redColor];
        [backgroundView addSubview:self.videoImageView];
        
        
        UIImageView *ttImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"playImageBack")];
        ttImageView.frame = RECT(self.videoImageView.frame.size.width - 50, self.videoImageView.frame.size.height - ttImageView.frame.size.height, 50, ttImageView.frame.size.height);
        [self.videoImageView addSubview:ttImageView];
        
        
        self.duringLabel = [[UILabel alloc] initWithFrame:RECT(ttImageView.frame.origin.x, ttImageView.frame.origin.y, ttImageView.frame.size.width - 3, ttImageView.frame.size.height)];
        self.duringLabel.backgroundColor = [UIColor clearColor];
        self.duringLabel.textAlignment = NSTextAlignmentRight;
        self.duringLabel.font = FONTSIZE(10);
        self.duringLabel.textColor = RGBCOLOR(217, 217, 217);
        [self.videoImageView addSubview:self.duringLabel];
        
        /*
        UIImageView *playImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"play")];
        playImageView.frame = RECT((self.videoImageView.frame.size.width - playImageView.frame.size.width) / 2.0, (self.videoImageView.frame.size.height - playImageView.frame.size.height) / 2.0, playImageView.frame.size.width, playImageView.frame.size.height);
        [self.videoImageView addSubview:playImageView];
        */
        self.titleLabel = [[UILabel alloc] initWithFrame:RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.videoImageView.frame.origin.y - 3, SCREEN_WIDTH - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10) - 5, 40)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = appdelegate.h1Color;
        self.titleLabel.font = FONTSIZE(appdelegate.h1FontSize);
        self.titleLabel.numberOfLines = 2;
        [backgroundView addSubview:self.titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"playButtonIcon")];
        imageView.frame = RECT(self.titleLabel.frame.origin.x, self.videoImageView.frame.size.height - imageView.frame.size.height - 5, imageView.frame.size.width, imageView.frame.size.height);
        [backgroundView addSubview:imageView];
        
        
        self.playCountLabel = [[UILabel alloc] initWithFrame:RECT(imageView.frame.origin.x + imageView.frame.size.width + 2 + 4, imageView.frame.origin.y, 100, imageView.frame.size.height)];
        self.playCountLabel.backgroundColor = [UIColor clearColor];
        self.playCountLabel.font = FONTSIZE(11);
        self.playCountLabel.textColor = RGBCOLOR(183, 183, 183);
        [backgroundView addSubview:self.playCountLabel];
        
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:RECT(SCREEN_WIDTH - 10 - 100 - 5 - 10, self.playCountLabel.frame.origin.y, 100, self.playCountLabel.frame.size.height)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = FONTSIZE(11);
        self.dateLabel.textColor = RGBCOLOR(183, 183, 183);
        [backgroundView addSubview:self.dateLabel];

        
        if (!right) {
            self.titleLabel.frame = RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.videoImageView.frame.origin.y, 470 - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10) - 5, 40);
            self.dateLabel.frame = RECT(470 - 10 - 100, self.playCountLabel.frame.origin.y, 100, self.playCountLabel.frame.size.height);
        }
        if (small) {
            self.titleLabel.frame = RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10, self.videoImageView.frame.origin.y, 320 - 10 - (self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 10) - 5, 40);
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
