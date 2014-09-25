//
//  NewsDetailCell.m
//  MKProject
//
//  Created by baojuan on 14-8-3.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "NewsDetailCell.h"
#import "NewsDetailViewController.h"

@implementation NewsDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForPad:(BOOL)forPad
{
    if (forPad) {
        self.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 480, 20);

    }
    else {
        self.frame = CGRectMake(0, 0, 320, 20);

    }
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 554, 20);
        }
        else {
            self.frame = CGRectMake(0, 0, 320, 20);
            
        }
        
        // Initialization code
        //self.detailImageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, self.frame.size.width, 230)];
        self.detailImageView = [[UIImageView alloc] initWithFrame:RECT(10, 0, self.frame.size.width - 20, 230)];
        self.detailImageView.image = IMAGENAMED(@"placeholderForNews");
#warning 转换展现方式
        self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.detailImageView.clipsToBounds = YES;
        self.detailImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.detailImageView];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:RECT(10, self.detailImageView.frame.size.height + self.detailImageView.frame.origin.y, self.frame.size.width - 20, 10)];
        self.detailLabel.font = FONTSIZE(14);
        self.detailLabel.numberOfLines = 0;
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)insertIntoDataComplete:(NSMutableDictionary *)dict complete:(void(^)(void))success
{
    if ([[dict objectForKey:@"classe"] isEqualToString:@"p"]) {
        __weak UILabel *tempLabel = self.detailLabel;
        __weak UIImageView *tempImageView = self.detailImageView;
        
        __weak NewsDetailCell * weakSelf = self;
        
        self.detailImageView.hidden = NO;
        self.detailImageView.frame = RECT(10, 0, self.frame.size.width - 20, [[dict objectForKey:@"imageHeight"] floatValue]);
        
        //NSLog(@"高度计算 %@   :  %d",[NSURL URLWithString:[dict objectForKey:@"src"]],[[dict objectForKey:@"indexof"] integerValue]);
        
 
        
        [self.detailImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"src"]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
                return ;
            }
            /*
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            CGFloat getHeight =height/width*320;
            
            [dict setObject:[NSNumber numberWithFloat:1] forKey:@"runBOOL"];
            
            [dict setObject:[NSNumber numberWithFloat:getHeight] forKey:@"imageHeight"];
            */
            
            success();
        }];
    }
}

- (void)insertIntoData:(NSMutableDictionary *)dict complete:(void(^)(void))success
{
    self.detailLabel.text = @"";
    //self.detailImageView.frame = RECT(0, 0, self.frame.size.width, 230);
    self.detailImageView.frame = RECT(10, 0, self.frame.size.width - 20, 230);
    
    self.detailLabel.frame = RECT(10, self.detailImageView.frame.size.height + self.detailImageView.frame.origin.y, self.frame.size.width - 20, 10);
    
    CGSize size = [[dict objectForKey:@"title"] sizeWithFont:self.detailLabel.font constrainedToSize:SIZE(self.detailLabel.frame.size.width, 10000)];
    
    CGRect rect = self.detailLabel.frame;
    rect.size = size;
    
    self.detailLabel.frame = rect;
    
    if ([[dict objectForKey:@"classe"] isEqualToString:@"p"]) {
        __weak UILabel *tempLabel = self.detailLabel;
        __weak UIImageView *tempImageView = self.detailImageView;

        __weak NewsDetailCell * weakSelf = self;
        [self.detailImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"src"]] placeholderImage:IMAGENAMED(@"placeholderForNews") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
                return ;
            }
            
            //self.detailImageView.hidden = YES;
            
            CGRect rr;
            
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            CGFloat getHeight =height/width*320;
            
            if (isnan(getHeight)) {
                getHeight = 230;
                NSLog(@"CCCC");
            }
            tempImageView.frame = RECT(10, 0, self.frame.size.width - 20, getHeight);
//            rr = tempImageView.frame;
//            rr.size.height = image.size.width / image.size.height * 320;
//            tempImageView.frame = rr;
            
            
//            rr = tempImageView.frame;
//            rr.size.height = getHeight;
//            tempImageView.frame = rr;
//            
//            rr = tempLabel.frame;
//            rr.origin.y += tempImageView.frame.size.height;
//            tempLabel.frame = rr;
            
//            NSMutableDictionary *dd = [((NewsDetailViewController *)weakSelf.delegate).dataArray objectAtIndex:[[dict objectForKey:@"indexof"] integerValue]];
//            
//            [dd setObject:[NSNumber numberWithFloat:getHeight] forKey:@"imageHeight"];
//            
//            [weakSelf.delegate refreshCellAtIndexPath:[NSIndexPath indexPathForRow:[[dict objectForKey:@"indexof"] integerValue] inSection:0]];
            
            //CGFloat height = image.size.height;
            //getHeight
            [dict setObject:[NSNumber numberWithFloat:1] forKey:@"runBOOL"];
            
            
            [dict setObject:[NSNumber numberWithFloat:getHeight] forKey:@"imageHeight"];
            
            [weakSelf.delegate refreshCellAtIndexPath:[NSIndexPath indexPathForRow:[[dict objectForKey:@"indexof"] integerValue] inSection:0]];
            
            success();
        }];
    }
    else {
        
        self.detailLabel.text = [dict objectForKey:@"title"];

        self.detailImageView.frame = RECT(10, 0, self.frame.size.width - 20, 0);
        self.detailLabel.frame = RECT(10, self.detailImageView.frame.size.height + self.detailImageView.frame.origin.y + 7, self.frame.size.width - 20, self.detailLabel.frame.size.height);

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
