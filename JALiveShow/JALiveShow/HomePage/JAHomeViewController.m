//
//  JAHomeViewController.m
//  JALiveShow
//
//  Created by Jater on 2018/11/26.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomeViewController.h"
#import "JAHomePageHeaderView.h"
#import "JAHomePageRequestService.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <MJExtension/NSObject+MJKeyValue.h>
#import "JALiveInfoModel.h"

@interface JAHomeViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationItem.title = @"喵Live";
    
    JAHomePageHeaderView *headerView = [[JAHomePageHeaderView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:headerView];
    
    [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(385.0f);
    }];
    
    JAHomePageRequestService *service = [JAHomePageRequestService new];
    RACCommand *command = [service getHotRecAnchorReuqestCommand];
    [[command.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        NSArray *liveList = [JALiveInfoModel mj_objectArrayWithKeyValuesArray: x];
        NSMutableArray *tempArray = [NSMutableArray array];
        [liveList enumerateObjectsUsingBlock:^(JALiveInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray addObject:obj.flv];
        }];
        [headerView configHotAnchorList:tempArray];

    }];
    [command.errors subscribeNext:^(id  _Nullable x) {
        
    }];
    [command execute:@1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
