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
#import "JARefreshHeader.h"
#import <MJRefresh/MJRefreshAutoNormalFooter.h>
#import "JAHomePageCollectionViewCell.h"

@interface JAHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JAHomePageHeaderView *headerView;

@property (nonatomic, assign)  NSInteger pageNo;

@property (nonatomic, strong)  NSMutableArray *dataSource;

@property (nonatomic, strong)  NSMutableArray *liveBlockList;

@property (nonatomic, strong)  JAHomePageRequestService *service;

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
    [cell configCoverImageLink:model.bigpic];
    [cell configLiveLink:model.flv];
    [cell configNickName:model.myname];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat item_W = (ThemeManager.screenWidth-15)/2;
    return CGSizeMake(item_W, item_W);
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

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JAHomePageCollectionViewCell *curCell = (JAHomePageCollectionViewCell *)cell;
    [curCell stop];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        [self.headerView start];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        [self.headerView stop];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffset_y = scrollView.contentOffset.y;
//    NSLog(@"contentOffset_y %f", contentOffset_y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self showLive];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        return;
    }
    [self showLive];
}


NSInteger preIntemIndex;

- (void)showLive {
    @synchronized (self.liveBlockList) {
        [self.liveBlockList removeAllObjects];
    }
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect cellRect = [self.collectionView convertRect:obj.frame toView:self.view];
        if (CGRectContainsRect(self.collectionView.frame, cellRect)) {
            NSIndexPath *curIndexPath = [self.collectionView indexPathForCell:obj];
            if ((curIndexPath.item-1)%4 == 0) {
                [self.liveBlockList addObject:obj];
            } else if ((curIndexPath.item-2)%4 == 0) {
                [self.liveBlockList addObject:obj];
            }
        } else {
            CGFloat curCellMaxY = CGRectGetMaxY(cellRect);
            if (curCellMaxY < CGRectGetHeight(cellRect)/3*2) {
                JAHomePageCollectionViewCell *homePageCollectionViewCell = (JAHomePageCollectionViewCell *)obj;
                [homePageCollectionViewCell stop];
            }
        }
        if (self.liveBlockList.count > 2) {
            *stop = YES;
        }
    }];
    
    [self.liveBlockList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JAHomePageCollectionViewCell *homePageCollectionViewCell =(JAHomePageCollectionViewCell *) obj;
        [homePageCollectionViewCell play];
    }];
}

#pragma mark - Getter and Setter

- (void)setupUI {
    self.tabBarController.navigationItem.title = @"喵Live";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 5.0f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 5, 10, 5);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[JAHomePageCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
    }];
    
    
    self.collectionView.mj_header = [JARefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(freshHeader)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(freshFooter)];
    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView reloadData];
    
    self.headerView = [[JAHomePageHeaderView alloc] initWithFrame:CGRectZero];
    self.dataSource = [NSMutableArray array];
    self.service = [JAHomePageRequestService new];
}

- (void)freshHeader {
    RACCommand *command = [self.service getHotRecAnchorReuqestCommand];
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
    
    
    RACCommand *listCommand = [self.service fetchHomePageLiveListRequestCommand];
    [[listCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        [self.dataSource removeAllObjects];
        NSArray *liveList = [JALiveInfoModel mj_objectArrayWithKeyValuesArray: x];
        [self.dataSource addObjectsFromArray:liveList];
        [self.collectionView reloadData];
        self.pageNo++;
    }];
    [listCommand.errors subscribeNext:^(NSError * _Nullable x) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
    }];
    self.pageNo = 1;
    [listCommand execute:@(self.pageNo)];
}

- (void)freshFooter {
    RACCommand *listCommand = [self.service fetchHomePageLiveListRequestCommand];
    [[listCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
        NSArray *liveList = [JALiveInfoModel mj_objectArrayWithKeyValuesArray: x];
        [self.dataSource addObjectsFromArray:liveList];
        [self.collectionView reloadData];
        self.pageNo++;
    }];
    [listCommand.errors subscribeNext:^(NSError * _Nullable x) {
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
    [listCommand execute:@(self.pageNo)];
}

- (NSMutableArray *)liveBlockList {
    if (!_liveBlockList) {
        _liveBlockList = [NSMutableArray array];
    }
    return _liveBlockList;
}

@end
