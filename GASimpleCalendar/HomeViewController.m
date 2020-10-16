//
//  HomeViewController.m
//  GASimpleCalendar
//
//  Created by Gamin on 9/14/20.
//  Copyright © 2020 Gamin. All rights reserved.
//

#import "HomeViewController.h"
#import "CommonHeader.h"
#import "BLCalendarViewController.h"
#import <Masonry/Masonry.h>

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray * dataArr;
@property (strong, nonatomic) BLCalendarViewController *tvHeaderVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"施工日志";
    self.view.backgroundColor = HexColor(@"#f2f2f2");
    [self setupTVHeaderView];
}

- (void)setupTVHeaderView {
    if (!_tvHeaderVC) {
        _tvHeaderVC = [[BLCalendarViewController alloc] initWithNibName:@"BLCalendarViewController" bundle:nil];
        __weak typeof(self) weakSelf = self;
        _tvHeaderVC.ChangeShowStatusBlock = ^(BOOL isShow) {
            /// 展开、收回
        };
        _tvHeaderVC.SelectDateBlock = ^(NSDateComponents * _Nonnull returnTime) {
            /// 选择日期
            NSLog(@"选择日期：%@",returnTime);
            [weakSelf.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        };
    }
    [self.view addSubview:_tvHeaderVC.view];
    [_tvHeaderVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVBARHEIGHT);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tvHeaderVC.view.mas_bottom).with.offset(8);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self nulCell:tableView];
    cell.textLabel.text = [NSString stringWithFormat:@"标题-%ld",(long)indexPath.row];
    return cell;
}

- (UITableViewCell *)nulCell:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

@end
