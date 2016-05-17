//
//  Copyright © 2016 SpotX, Inc. All rights reserved.
//

#import "MainViewController.h"

#import "PreRollViewController.h"
#import "MidRollViewController.h"

@implementation MainViewController {
  NSArray<NSArray*> *_actions;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _actions = @[
    @[@"Multiple Pre-Roll Placements", [PreRollViewController class]],
    @[@"Multiple Mid-Roll Placements", [MidRollViewController class]]
  ];

  self.clearsSelectionOnViewWillAppear = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *kMenuTableCellID = @"kMenuTableCellID";

  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMenuTableCellID];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [_actions[indexPath.row] firstObject];

  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Class action = [_actions[indexPath.row] lastObject];

  UIViewController *vc = (UIViewController *)[[action alloc] init];
  [self presentViewController:vc animated:YES completion:nil];
}

@end
