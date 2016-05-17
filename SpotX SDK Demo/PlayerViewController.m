//
//  Copyright © 2016 SpotX, Inc. All rights reserved.
//

#import "PlayerViewController.h"

@implementation PlayerViewController {
  UIActivityIndicatorView *_loadingIndicator;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  _loadingIndicator.hidesWhenStopped = YES;
  [self.view addSubview:_loadingIndicator];
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  _loadingIndicator.center = self.view.center;
}


#pragma mark - Loading Indicator

- (void)showLoadingIndicator {
  if (![[NSThread currentThread] isMainThread]) {
    [self performSelectorOnMainThread:@selector(showLoadingIndicator) withObject:nil waitUntilDone:YES];
    return;
  }

  _loadingIndicator.center = self.view.center;
  [_loadingIndicator startAnimating];
  [self.view addSubview:_loadingIndicator];
  [self.view setUserInteractionEnabled:NO];
}

- (void)hideLoadingIndicator {
  if (![[NSThread currentThread] isMainThread]) {
    [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:YES];
    return;
  }

  [_loadingIndicator stopAnimating];
  [_loadingIndicator removeFromSuperview];
  [self.view setUserInteractionEnabled:YES];
}


#pragma mark - Player & Main Content

- (void)setPlayer:(AVPlayer *)player content:(AVPlayerItem *)content {
  [super setPlayer:player];

  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(contentDidFinish)
             name:AVPlayerItemDidPlayToEndTimeNotification object:content];
  [nc addObserver:self selector:@selector(contentDidFinish)
             name:AVPlayerItemFailedToPlayToEndTimeNotification object:content];
}

- (void)contentDidFinish {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
