//
//  Copyright © 2016 SpotX, Inc. All rights reserved.
//

#import "PreRollViewController.h"

@import SpotX;

static NSString * const kChannelID = @"85394";// @"128951";
static NSUInteger const kAdCount = 2;

@implementation PreRollViewController {
  AVQueuePlayer *_player;
}

- (void)viewDidLoad {
  [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"http://c.brightcove.com/services/mobile/streaming/index/master.m3u8?videoId=4543523309001"];

//  NSURL *url = [NSURL URLWithString:@"https://spotxchange-a.akamaihd.net/media/videos/orig/9/a/9a5e4c9c92d411e59ef119e233f970be.mp4"];
  AVPlayerItem *content = [AVPlayerItem playerItemWithURL:url];
  _player = [AVQueuePlayer playerWithPlayerItem:content];

  [self setPlayer:_player content:content];

  [self loadAds:kAdCount];
}

- (void)loadAds:(NSUInteger)count {
  if (count > 0) {
    [self showLoadingIndicator];
    [SpotX adForChannel:kChannelID params:nil completion:^(SPXAdController * _Nullable adController, NSError * _Nullable error) {
      if (adController) {
        [adController preRoll:_player];
      }
      [self loadAds:count-1];
    }];
  }
  else {
    [self hideLoadingIndicator];
    [self.player play];
  }
}

@end
