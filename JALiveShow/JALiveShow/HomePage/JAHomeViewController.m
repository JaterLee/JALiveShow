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
#import "JAHomePageCollectionViewCell.h"

@interface JAHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JAHomePageHeaderView *headerView;

@property (nonatomic, assign)  NSInteger pageNo;

@property (nonatomic, strong)  NSMutableArray *dataSource;

@end

@implementation JAHomeViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JAHomePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    JALiveInfoModel *model = self.dataSource[indexPath.item];
    [cell configLiveLink:model.flv];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat item_W = (ThemeManager.screenWidth-30)/2;
    CGFloat scale = item_W/ThemeManager.screenWidth;
    return CGSizeMake((ThemeManager.screenWidth-30)/2, ThemeManager.screenHeight*scale);
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
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.minimumInteritemSpacing = 10.0f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[JAHomePageCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
    }];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freashHeader)];
    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView reloadData];
    
    self.headerView = [[JAHomePageHeaderView alloc] initWithFrame:CGRectZero];
    self.dataSource = [NSMutableArray array];
}

- (void)freashHeader {
    JAHomePageRequestService *service = [JAHomePageRequestService new];
    RACCommand *command = [service getHotRecAnchorReuqestCommand];
    [[command.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        NSArray *liveList = [JALiveInfoModel mj_objectArrayWithKeyValuesArray: x];
        NSMutableArray *tempArray = [NSMutableArray array];
        [liveList enumerateObjectsUsingBlock:^(JALiveInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray addObject:obj.flv];
        }];
        [self.headerView configHotAnchorList:tempArray];
    }];
    [command.errors subscribeNext:^(id  _Nullable x) {
    }];
    [command execute:@1];
    
    
    RACCommand *listCommand = [service fetchHomePageLiveListRequestCommand];
    [[listCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        [self.dataSource removeAllObjects];
        NSArray *liveList = [JALiveInfoModel mj_objectArrayWithKeyValuesArray: x];
        [self.dataSource addObjectsFromArray:liveList];
        [self.collectionView reloadData];

    }];
    [listCommand.errors subscribeNext:^(NSError * _Nullable x) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
    }];
    [listCommand execute:@1];

}

@end
