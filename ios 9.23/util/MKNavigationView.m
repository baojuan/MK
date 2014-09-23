//
//  MKNavigationView.m
//  MKProject
//
//  Created by baojuan on 14-6-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "MKNavigationView.h"

@implementation MKNavigationView
{
    AppDelegate *appdelegate;
}

- (id)initWithTitle:(NSString *)title ForPad:(BOOL)ForPad ForPadFullScreen:(BOOL)fullScreen
{
    return [self initWithTitle:title leftButtonImage:Nil rightButtonImage:Nil ForPad:ForPad ForPadFullScreen:fullScreen];
}

- (id)initWithTitle:(NSString *)title leftButtonImage:(UIImage *)leftImage rightButtonImage:(UIImage *)rightImage ForPad:(BOOL)ForPad ForPadFullScreen:(BOOL)fullScreen
{
    if (self = [super init]) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (ForPad) {
                self.frame = RECT(60, 0, 470, 64);
            }
            else {
                self.frame = RECT(0, 0, 320, 64);
            }
            
            if (fullScreen) {
                self.frame = RECT(0, 0, SCREEN_HEIGHT, 64);
            }

        }
        
        else {
            self.frame = RECT(0, 0, 320, 64);
        }
        appdelegate = APPDELEGATE;
        if (appdelegate.navigationStyle) {
            self.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(@"NavBackImage")];
        }
        else {
            self.backgroundColor = appdelegate.navigationColor;
        }
        
        self.titleLabel = [[UILabel alloc] initWithFrame:RECT(50, 20, self.frame.size.width - 100, self.frame.size.height - 20)];
        self.titleLabel.userInteractionEnabled = YES;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = FONTSIZE(appdelegate.navigationTitleFontSize);
        self.titleLabel.textColor = appdelegate.navigationTitleColor;
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        if (leftImage) {
            self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.leftButton setImage:leftImage forState:UIControlStateNormal];
            self.leftButton.frame = RECT(10 - 10, (self.titleLabel.frame.size.height - leftImage.size.height) / 2.0 - 10 + 20, leftImage.size.width + 20, leftImage.size.height + 20);
            [self addSubview:self.leftButton];
        }
        if (rightImage) {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.rightButton setImage:rightImage forState:UIControlStateNormal];
            self.rightButton.frame = RECT(self.frame.size.width - rightImage.size.width - 10 - 2, (self.titleLabel.frame.size.height - rightImage.size.height) / 2.0 + 20 - 5, rightImage.size.width + 4, rightImage.size.height + 10);
            [self addSubview:self.rightButton];
        }

    }
    return self;
}

- (id)initWithTitle:(NSString *)title rightButtonImage:(UIImage *)rightImage ForPad:(BOOL)ForPad ForPadFullScreen:(BOOL)fullScreen
{
    return [self initWithTitle:title leftButtonImage:IMAGENAMED(@"navback") rightButtonImage:rightImage ForPad:ForPad ForPadFullScreen:fullScreen];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
