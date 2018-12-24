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

@interface JATabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation JATabBarViewController {
    NSArray *_homePageAniImages;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configChildrenViewController];
    self.delegate = self;
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
    childVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [JAThemeManager colorWithHexString:@"535353"]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [JAThemeManager colorWithHexString:@"eb5b60"]} forState:UIControlStateSelected];
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0);{
    NSInteger index = [tabBarController.childViewControllers indexOfObject:viewController];
    UIButton *barButton = tabBarController.tabBar.subviews[index+1];
    UIImageView *barImageView = barButton.subviews.firstObject;
    
    barImageView.animationImages = self.homePageAniImages;
    barImageView.animationDuration = 0.8;
    barImageView.animationRepeatCount = 1;
    [barImageView startAnimating];
    return YES;
}

- (NSArray *)homePageAniImages {
    if (_homePageAniImages) {
        return _homePageAniImages;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = 2; i < 20; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"e3L%@", @(i)]];
        [tempArr addObject:image];
    }
    return tempArr.copy;
}

@end
