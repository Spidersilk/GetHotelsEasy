//
//  OfferListModel.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import "OfferListModel.h"

@implementation OfferListModel

- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.aviation_cabin = [Utilities nullAndNilCheck:dict[@"aviation_cabin"] replaceBy:@""];
        self.aviation_company = [Utilities nullAndNilCheck:dict[@"aviation_company"] replaceBy:@""];
        _in_time = [dict[@"in_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"in_time"] integerValue];
        _out_time = [dict[@"out_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"out_time"] integerValue];
        self.final_price = [Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];
        self.destination = [Utilities nullAndNilCheck:dict[@"description"] replaceBy:@""];
        self.departure = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
        self.flight_no = [Utilities nullAndNilCheck:dict[@"flight_no"] replaceBy:@""];
    }
    return self;
}
@end
