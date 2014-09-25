//
//  VolumnView.m
//  MKProject
//
//  Created by baojuan on 14-9-24.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "VolumnView.h"
#import <MediaPlayer/MediaPlayer.h>
#define MKSystemVolumeDidChangeNotification         @"AVSystemController_SystemVolumeDidChangeNotification"

typedef enum {
    MKExpandDirectionUp,
    MKExpandDirectionDown
} MKExpandDirection;

@implementation VolumnView
{
    UISlider *_slider;
    CGFloat _volume;
}

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.7;
        [self addSubview:blackView];
        _volume = [self systemVolume];
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(-48, CGRectGetHeight(self.frame) - 60, CGRectGetHeight(self.frame) - 40, 40)];
        _slider.layer.anchorPoint = CGPointMake(0, 0.5);
        _slider.transform = [self transformForExpandDirection:MKExpandDirectionUp];
        [self addSubview:_slider];
        [_slider addTarget:self action:@selector(handleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.maximumValue = 1.0f;
        _slider.minimumValue = 0.0f;
        _slider.value = _volume;
        _slider.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:138/255.0 blue:0 alpha:1];
        _slider.maximumTrackTintColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volumn_video"]];
        imageView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 40, 40, 40);
        [self addSubview:imageView];
        
        
        
        // observe changes to system volume (volume buttons)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(systemVolumeChanged:)
                                                     name:MKSystemVolumeDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (CGAffineTransform)transformForExpandDirection:(MKExpandDirection)expandDirection {
    if (expandDirection == MKExpandDirectionUp) {
        return CGAffineTransformMakeRotation(-M_PI/2.f);
    } else {
        return CGAffineTransformMakeRotation(M_PI/2.f);
    }
}


- (void)handleSliderValueChanged:(id)sender {
    _volume = _slider.value;
    [self setSystemVolume:_volume];
}

- (void)systemVolumeChanged:(NSNotification *)notification {
    _slider.value = _volume;
}

- (float)systemVolume {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    return musicPlayer.volume;
}

- (void)setSystemVolume:(float)systemVolume {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicPlayer.volume = systemVolume;
}


@end
