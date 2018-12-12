//
//  JALiveInfoModel.h
//  JALiveShow
//
//  Created by Jater on 2018/12/12.
//  Copyright © 2018 Jater. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JALiveInfoModel : NSObject

//allnum = 19376;
@property (nonatomic, assign) NSInteger allnum;

//anchorlevel = 59;
@property (nonatomic, assign) NSInteger anchorlevel;

//bigpic = "http://liveimg.miaobolive.com/pic/avator/201811/12/13/A4A24E7DE12E6BA1_64733775_640.png";
@property (nonatomic, strong) NSString *bigpic;

//distance = 0;
@property (nonatomic, assign) NSInteger distance;

//familyName = Hitler;
@property (nonatomic, strong) NSString *familyName;

//flv = "http://hdl.miaobolive.com/live/b7b588356cee785c63087b6f50e8c540.flv";
@property (nonatomic, strong) NSString *flv;

//gameid = 0;
@property (nonatomic, assign) NSInteger gameid;

//gender = 0;
@property (nonatomic, assign) NSInteger gender;

//gps = "\U6765\U81ea\U55b5\U661f";
@property (nonatomic, strong) NSString *gps;

//isSign = 1;
@property (nonatomic, assign) NSInteger isSign;

//myname = "Hitler-\U827e\U5341\U4e8c";
@property (nonatomic, strong) NSString *myname;

//nation = "";
@property (nonatomic, strong) NSString *nation;

//nationFlag = "";
@property (nonatomic, strong) NSString *nationFlag;

//pos = 1;
@property (nonatomic, assign) NSInteger pos;

//roomid = 60675707;
@property (nonatomic, assign) NSInteger roomid;

//serverid = 17;
@property (nonatomic, assign) NSInteger serverid;

//smallpic = "http://liveimg.miaobolive.com/pic/avator/201811/12/13/A4A24E7DE12E6BA1_64733775_640.png";
@property (nonatomic, strong) NSString *smallpic;

//starlevel = 3;
@property (nonatomic, assign) NSInteger starlevel;

//userId = WeiXin24223588;
@property (nonatomic, strong) NSString *userId;

//useridx = 64733775;
@property (nonatomic, assign) NSInteger useridx;


@end

NS_ASSUME_NONNULL_END
