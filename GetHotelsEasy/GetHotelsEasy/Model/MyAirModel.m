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
        self.route = [Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@""];
        self.start_time_str = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        _start_time = [dict[@"start_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"start_time"] integerValue];
        self.price = [Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""];
        self.company = [[Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""] integerValue];
    }
    return self;
}
- (instancetype)initWithDictForIssuing: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.route = [Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@""];
        self.start_time_str = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        _start_time = [dict[@"start_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"start_time"] integerValue];
        self.highPrice = [Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];
        self.lowPrice = [Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""];
        self.demand = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
        _Id = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""] integerValue];
    }
    return self;
}
- (instancetype)initWithDictForHistory: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
