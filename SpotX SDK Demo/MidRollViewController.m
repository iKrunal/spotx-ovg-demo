//
//  Copyright © 2016 SpotX, Inc. All rights reserved.
//

#import "MidRollViewController.h"

@import SpotX;

/**
 *  Test Channel ID
 */
static NSString * const kChannelID = @"85394"; // @"128951";

/**
 *  Number of Ads to play consecutively
 */
static NSUInteger const kAdCount = 2;

/**
 *  Number of seconds between ad breaks.
 */
static int64_t const kAdInterval = 10;


@implementation MidRollViewController {
  NSMutableArray<SPXAdController *> *_ads;
  AVPlayerItem *_content;
  CMTime _nextAdBreak;
  id _observer;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _ads = [NSMutableArray arrayWithCapacity:kAdCount];

//  NSURL *url = [NSURL URLWithString:@"http://spotxchange-a.akamaihd.net/media/videos/orig/9/a/9a5e4c9c92d411e59ef119e233f970be.mp4"];
    NSURL *url = [NSURL URLWithString:@"http://c.brightcove.com/services/mobile/streaming/index/master.m3u8?videoId=4543523309001"];

  _content = [AVPlayerItem playerItemWithURL:url];

  // Calculate initial ad break
  _nextAdBreak = kCMTimeZero;

  __weak id weakSelf = self;

  AVPlayer *player = [AVPlayer playerWithPlayerItem:_content];

  // Register a time observer to monitor for the next ad break
  _observer = [player addPeriodicTimeObserverForInterval:CMTimeMake(kAdInterval, 1) queue:nil usingBlock:^(CMTime time) {
    BOOL isContent = player.currentItem == _content;
    BOOL isTimeForAdBreak = CMTimeCompare(time, _nextAdBreak) >= 0;
    if (isContent && isTimeForAdBreak) {
      [weakSelf loadAds];
      _nextAdBreak = CMTimeAdd(time, CMTimeMake(kAdInterval, 1));
    }
  }];

  [self setPlayer:player content:_content];

  [player play];
}

- (void)contentDidFinish {
  [self.player removeTimeObserver:_observer];
  [super contentDidFinish];
}

- (void)loadAds {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(loadAds) withObject:nil waitUntilDone:YES];
        return;
    }
    
    if (_ads.count < kAdCount) {
        [self showLoadingIndicator];
        [SpotX adForChannel:kChannelID params:nil completion:^(SPXAdController * _Nullable adController, NSError * _Nullable error) {
            if (adController) {
                [_ads addObject:adController];
            }
            [self loadAds];
        }];
    }
    else {
        [self playNextAd];
        [self hideLoadingIndicator];
    }
}

- (void)playNextAd {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(playNextAd) withObject:nil waitUntilDone:YES];
        return;
    }
    
    SPXAdController *ad = [_ads lastObject];
    [_ads removeLastObject];
    
    if (ad) {
        [ad play:self.player completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self playNextAd];
            });
        }];
    }
    else {
        // NOTE: This is a workaround for a bug in SDK v1.1
        [self.player replaceCurrentItemWithPlayerItem:_content];
        [self.player play];
    }
}

@end
