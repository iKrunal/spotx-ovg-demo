//
//  Copyright © 2016 SpotX, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  _window.rootViewController = [[MainViewController alloc] init];
  [_window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
