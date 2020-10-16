//
//  AppDelegate.m
//  GASimpleCalendar
//
//  Created by Gamin on 9/14/20.
//  Copyright © 2020 Gamin. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:home];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
