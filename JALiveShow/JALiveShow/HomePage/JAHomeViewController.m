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
#import "JAThemeManager.h"
#import <MJRefresh/UIScrollView+MJRefresh.h>
#import <MJRefresh/MJRefreshNormalHeader.h>

@interface JAHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong)  JAHomePageHeaderView *headerView;

@end

@implementation JAHomeViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.headerView = [[JAHomePageHeaderView alloc] initWithFrame:CGRectZero];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerId" forIndexPath:indexPath];
        self.headerView.frame = headerReusableView.frame;
        [headerReusableView addSubview:self.headerView];
        return headerReusableView;
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ThemeManager.screenWidth, 385.0f);
}

#pragma mark - Getter and Setter

- (void)setupUI {
    self.tabBarController.navigationItem.title = @"喵Live";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
    }];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freashHeader)];
    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView reloadData];
}

- (void)freashHeader {
    JAHomePageRequestService *service = [JAHomePageRequestService new];
    RACCommand *command = [service getHotRecAnchorReuqestCommand];
    [[command.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        NSArray *liveList = [JALiveInfoModel mj_objectArrayWithKeyValuesArray: x];
        NSMutableArray *tempArray = [NSMutableArray array];
        [liveList enumerateObjectsUsingBlock:^(JALiveInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray addObject:obj.flv];
        }];
        [self.headerView configHotAnchorList:tempArray];
    }];
    [command.errors subscribeNext:^(id  _Nullable x) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
    }];
    [command execute:@1];

}

@end
