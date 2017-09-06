//
//  MyAirModel.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import "MyAirModel.h"

@implementation MyAirModel


- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.oRoute = [Utilities nullAndNilCheck:dict[@"oRoute"] replaceBy:@""];
        self.oTime = [Utilities nullAndNilCheck:dict[@"oRoute"] replaceBy:@""];
        self.oType = [Utilities nullAndNilCheck:dict[@"oType"] replaceBy:@""];
        self.oPrice = [Utilities nullAndNilCheck:dict[@"oPrice"] replaceBy:@""];
    }
    return self;
}
- (instancetype)initWithDictForIssuing: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.iRoute = [Utilities nullAndNilCheck:dict[@"iRoute"] replaceBy:@""];
        self.iTime = [Utilities nullAndNilCheck:dict[@"iRoute"] replaceBy:@""];
        self.iType = [Utilities nullAndNilCheck:dict[@"iType"] replaceBy:@""];
        self.iPrice = [Utilities nullAndNilCheck:dict[@"iPrice"] replaceBy:@""];
    }
    return self;
}
- (instancetype)initWithDictForHistory: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.hRoute = [Utilities nullAndNilCheck:dict[@"hRoute"] replaceBy:@""];
        self.hTime = [Utilities nullAndNilCheck:dict[@"hRoute"] replaceBy:@""];
        self.hType = [Utilities nullAndNilCheck:dict[@"hType"] replaceBy:@""];
        self.hPrice = [Utilities nullAndNilCheck:dict[@"hPrice"] replaceBy:@""];
    }
    return self;
}
@end
