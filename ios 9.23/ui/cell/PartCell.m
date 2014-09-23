//
//  PartCell.m
//  MKProject
//
//  Created by baojuan on 14-7-14.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "PartCell.h"

@implementation PartCell
{
    AppDelegate *appdelegate;
    UIView *bigView;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForBig:(BOOL)big
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        appdelegate = APPDELEGATE;
        self.frame = RECT(0, 0, 320, 100);
        if (big) {
            self.frame = RECT(0, 0, 470, 100);
            
        }
        self.backgroundColor = RGBCOLOR(232, 232, 232);
        bigView = [[UIView alloc] initWithFrame:RECT(0, 0, self.frame.size.width, 100)];
        bigView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bigView];
        //187
        self.backgroundImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(appdelegate.placeholderName)];
        self.backgroundImageView.frame = RECT(0, 0, self.frame.size.width, 187);
        self.backgroundImageView.backgroundColor = RGBCOLOR(232, 232, 232);
        self.backgroundImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.backgroundImageView];
        //40
        
        self.picstateImageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, 56 / 2.0 * 1.2, 42 / 2.0 * 1.2)];
        self.picstateImageView.backgroundColor = [UIColor clearColor];
        [self.backgroundImageView addSubview:self.picstateImageView];
        
        
        self.placeholderImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"waitatime")];
        self.placeholderImageView.frame = RECT((self.backgroundImageView.frame.size.width - self.placeholderImageView.frame.size.width) / 2.0, (self.backgroundImageView.frame.size.height - self.placeholderImageView.frame.size.height) / 2.0, self.placeholderImageView.frame.size.width, self.placeholderImageView.frame.size.height);
        [self.backgroundImageView addSubview:self.placeholderImageView];
        
        self.playImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"playpart")];
        self.playImageView.frame = RECT((self.backgroundImageView.frame.size.width - self.playImageView.frame.size.width) / 2.0, (self.backgroundImageView.frame.size.height - self.playImageView.frame.size.height) / 2.0, self.playImageView.frame.size.width, self.playImageView.frame.size.height);
        [self.backgroundImageView addSubview:self.playImageView];
        
        self.playImageView.hidden = YES;

        self.iconImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(appdelegate.placeholderName)];
        self.iconImageView.frame = RECT(12, self.backgroundImageView.frame.size.height + self.backgroundImageView.frame.origin.y - 12, 40, 40);
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.cornerRadius = 20;
        
        self.authorLabel = [[UILabel alloc] initWithFrame:RECT(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width, self.backgroundImageView.frame.size.height + self.backgroundImageView.frame.origin.y, 100, 30)];
        self.authorLabel.backgroundColor = [UIColor clearColor];
        self.authorLabel.font = FONTSIZE(13);
        [self.contentView addSubview:self.authorLabel];
        
        
        self.dataLabel = [[UILabel alloc] initWithFrame:RECT(self.frame.size.width - 100 - 12, self.authorLabel.frame.origin.y, 100, 30)];
        self.dataLabel.backgroundColor = [UIColor clearColor];
        self.dataLabel.font = FONTSIZE(10);
        self.dataLabel.textAlignment = NSTextAlignmentRight;
        self.dataLabel.textColor = RGBCOLOR(167, 167, 167);
        [self.contentView addSubview:self.dataLabel];
        
        
        
        self.contentLabel = [[UILabel alloc] initWithFrame:RECT(12, self.iconImageView.frame.size.height + self.iconImageView.frame.origin.y + 5, self.frame.size.width - 12 * 2, 80)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = FONTSIZE(15);
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = RGBCOLOR(91, 91, 91);
        [self.contentView addSubview:self.contentLabel];
        
        
        
        self.bottomView = [[PartCellBottomView alloc] initWithSimple:!big];
        //        self.bottomView.frame = RECT(0, 100, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        [self.contentView addSubview:self.bottomView];
        
        
    }
    return self;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Simple:(BOOL)simple
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.bottomView.hidden = YES;
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier ForBig:NO];
}

- (void)insertIntoDataToPartCell:(ArticleModel *)item
{
    
    CGFloat height;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        height = [item.field3 floatValue] / 320 * self.frame.size.width;
        height = MAX(height, 20);
        self.backgroundImageView.frame = RECT(0, 0, self.frame.size.width, height);

    }
    else {
        height = MIN([item.field3 floatValue] / 320 * self.frame.size.width, 800);
        height = MAX(height, 20);
        self.backgroundImageView.frame = RECT(0, 0, self.frame.size.width, height);
    }
    self.picstateImageView.image = nil;

    if ([item.image length] == 0) {
        self.backgroundImageView.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.backgroundImageView.backgroundColor = RGBCOLOR(232, 232, 232);

        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[item.field2 componentsSeparatedByString:@"^"]];
        [array removeObject:@""];
        if ([array count] > 1) {
            self.picstateImageView.image = IMAGENAMED(@"picstate1");
        }
        else if (([item.field3 floatValue] / 320 * self.frame.size.width) > 800) {
            self.picstateImageView.image = IMAGENAMED(@"picstate2");
        }

    }
    
    self.placeholderImageView.frame = RECT((self.backgroundImageView.frame.size.width - self.placeholderImageView.frame.size.width) / 2.0, (self.backgroundImageView.frame.size.height - self.placeholderImageView.frame.size.height) / 2.0, self.placeholderImageView.frame.size.width, self.placeholderImageView.frame.size.height);

   __weak UIImageView *pp = self.placeholderImageView;
    NSMutableString *imageUrl = [[NSMutableString alloc] initWithString:item.image];
    [imageUrl replaceOccurrencesOfString:@"app." withString:@"t1." options:NSLiteralSearch range:NSMakeRange(0, [imageUrl length])];
    [imageUrl appendString:@"/480"];
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        pp.hidden = YES;
        if (image == nil) {
            return ;
        }
        }];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;

    
    self.playImageView.frame = RECT((self.backgroundImageView.frame.size.width - self.playImageView.frame.size.width) / 2.0, (self.backgroundImageView.frame.size.height - self.playImageView.frame.size.height) / 2.0, self.playImageView.frame.size.width, self.playImageView.frame.size.height);
    
    self.iconImageView.frame = RECT(12, self.backgroundImageView.frame.size.height + self.backgroundImageView.frame.origin.y - 12, 40, 40);
    NSMutableString *imageIcon = [[NSMutableString alloc] initWithString:item.fromUrl];
    [imageIcon replaceOccurrencesOfString:@"app." withString:@"t3." options:NSLiteralSearch range:NSMakeRange(0, [imageIcon length])];
    [imageIcon appendString:@"/100"];

    [self.iconImageView setImageWithURL:[NSURL URLWithString:imageIcon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image == nil) {
            return ;
        }
    }];
    
    self.authorLabel.frame = RECT(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width, self.backgroundImageView.frame.size.height + self.backgroundImageView.frame.origin.y, 100, 30);
    self.authorLabel.text = item.fromUrlName;
    
    self.dataLabel.frame = RECT(self.frame.size.width - 100 - 12, self.authorLabel.frame.origin.y, 100, 30);
    self.dataLabel.text = item.date;
    
    self.contentLabel.frame = RECT(12, self.iconImageView.frame.size.height + self.iconImageView.frame.origin.y + 5, self.frame.size.width - 12 * 2, 80);
    self.contentLabel.text = item.title;
    
    CGSize size = [item.title sizeWithFont:self.contentLabel.font constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 500)];
    CGRect rect = self.contentLabel.frame;
    rect.size.height = size.height + 20;
    self.contentLabel.frame = rect;
    
    self.bottomView.frame = RECT(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height);

    [self.bottomView insertIntoDataGoodNumber:item.goodNumber commentNumber:item.commentNumber isCollect:[self isCollectOrNot:item.articleId]];
    if (item.isgood) {
        self.bottomView.goodButton.selected = YES;
    }
    else {
        self.bottomView.goodButton.selected = NO;
    }
    self.bottomView.delegate = self.delegate;
    if (self.bottomView.hidden) {
        bigView.frame = RECT(0, 0, self.frame.size.width, height + 30 + self.contentLabel.frame.size.height);
    }
    else {
        bigView.frame = RECT(0, 0, self.frame.size.width, height + 30 + 74 / 2.0 + self.contentLabel.frame.size.height);

    }
}


- (BOOL)isCollectOrNot:(NSString *)articleId
{
    NSArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT] objectForKey:LOCAL_LANGUAGE(@"part")];
    BOOL isCollect = NO;
    for (NSDictionary *dd in arr) {
        if ([articleId isEqualToString:[dd objectForKey:@"articleId"]]) {
            isCollect = YES;
        }
    }
    return isCollect;
}

- (void)setTagWithButtons:(NSInteger)tag
{
    self.bottomView.reportButton.tag = tag;
    self.bottomView.goodButton.tag = tag;
    self.bottomView.talkButton.tag = tag;
    self.bottomView.shareButton.tag = tag;
    self.bottomView.collectButton.tag = tag;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
