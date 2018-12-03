//
//  JATabBarViewController.m
//  JALiveShow
//
//  Created by Jater on 2018/11/16.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JATabBarViewController.h"
#import "JAHomeViewController.h"
#import "JAExportViewController.h"
#import "JAFollowViewController.h"
#import "JAMineViewController.h"
#import "JAThemeManager.h"

@interface JATabBarViewController ()

@end

@implementation JATabBarViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configChildrenViewController];
}

- (void)configChildrenViewController {
    JAHomeViewController *homeVC = JAHomeViewController.new;
    [self configTabItemOfChildVC:homeVC title:@"首页" imageName:@"tabbar_home_1" selectedImageName:@"tabbar_home_H_10"];
    JAFollowViewController *followVC = JAFollowViewController.new;
    [self configTabItemOfChildVC:followVC title:@"关注" imageName:@"tabbar_follow_1" selectedImageName:@"tabbar_follow_H_27"];
    JAExportViewController *exportVC = JAExportViewController.new;
    [self configTabItemOfChildVC:exportVC title:@"探索" imageName:@"tabbar_export_1" selectedImageName:@"tabbar_export_H_21"];
    JAMineViewController *mineVC = JAMineViewController.new;
    [self configTabItemOfChildVC:mineVC title:@"我的" imageName:@"tabbar_mine_1" selectedImageName:@"tabbar_mine_H_22"];
    
    self.viewControllers = @[homeVC, followVC, exportVC, mineVC];
}

- (void)configTabItemOfChildVC:(UIViewController *)childVC
                         title:(NSString *)title
                     imageName:(NSString *)imageName
             selectedImageName:(NSString *)selectedImageName {
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [JAThemeManager colorWithHexString:@"535353"]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [JAThemeManager colorWithHexString:@"eb5b60"]} forState:UIControlStateSelected];
}

@end
