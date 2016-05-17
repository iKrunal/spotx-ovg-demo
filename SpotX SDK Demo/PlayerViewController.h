//
//  Copyright © 2016 SpotX, Inc. All rights reserved.
//
@import AVKit;
@import UIKit;

@interface PlayerViewController : AVPlayerViewController

- (void)setPlayer:(AVPlayer *)player content:(AVPlayerItem *)content;

- (void)showLoadingIndicator;

- (void)hideLoadingIndicator;

- (void)contentDidFinish;

@end
