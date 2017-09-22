//
//  MyInfoModel.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 self. All rights reserved.
//

#import "MyInfoModel.h"

@implementation MyInfoModel

- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.grade = [[Utilities nullAndNilCheck:dict[@"grade"] replaceBy:0] integerValue];
        self.name = [Utilities nullAndNilCheck:dict[@"nick_name"] replaceBy:@""];
        self.picture = [Utilities nullAndNilCheck:dict[@"head_img"] replaceBy:@""];
        _Id = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"] integerValue];
        _openid = [Utilities nullAndNilCheck:dict[@"openid"] replaceBy:@"暂无"];
    }
    return self;
}
- (instancetype)initWithForAll:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.final_in_time_str = [Utilities nullAndNilCheck:dict[@"final_in_time_str"] replaceBy:0];
        self.final_out_time_str = [Utilities nullAndNilCheck:dict[@"final_out_time_str"] replaceBy:@""];
        self.state = [[Utilities nullAndNilCheck:dict[@"state"] replaceBy:@""] integerValue];
        self.hotel_address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"0"];
        self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"0"];
    }
    return self;
}

- (instancetype)initWithDictForWork:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.final_in_time_str = [Utilities nullAndNilCheck:dict[@"final_in_time_str"] replaceBy:0];
        self.final_out_time_str = [Utilities nullAndNilCheck:dict[@"final_out_time_str"] replaceBy:@""];
        //self.final_price = [Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""];
        self.hotel_address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"0"];
        self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"0"];
    }
    return self;
}
- (instancetype)initWithDictForExpired:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.final_in_time_str = [Utilities nullAndNilCheck:dict[@"final_in_time_str"] replaceBy:0];
        self.final_out_time_str = [Utilities nullAndNilCheck:dict[@"final_out_time_str"] replaceBy:@""];
        //self.final_price = [Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""];
        self.hotel_address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"0"];
        self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"0"];
    }
    return self;
}

@end
