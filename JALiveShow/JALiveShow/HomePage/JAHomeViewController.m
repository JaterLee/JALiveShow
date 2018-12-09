//
//  JAHomeViewController.m
//  JALiveShow
//
//  Created by Jater on 2018/11/26.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomeViewController.h"
#import "JAGetHotRecAnchorReuqest.h"

@interface JAHomeViewController ()

@end

@implementation JAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"喵live";
    
    JAGetHotRecAnchorReuqest *request = [JAGetHotRecAnchorReuqest new];
    [request start];
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
