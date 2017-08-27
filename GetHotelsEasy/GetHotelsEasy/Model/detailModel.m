//
//  detailModel.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 self. All rights reserved.
//

#import "detailModel.h"

@implementation detailModel
- (id) initWhitDictionary: (NSDictionary *)dict{
        self = [super init];//self调用者本身
    if (self){
        _hotelID = [[Utilities nullAndNilCheck:@"id" replaceBy:0] integerValue];
        _price = [[Utilities nullAndNilCheck:dict[@"price"] replaceBy:0]integerValue];
        self.longitude = [[Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:0] integerValue];
        self.hotel_img = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _latitude = [[Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:0] integerValue];
        _hotel_address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];

       
    }
    return self;
}
- (id) initWiihDetailDictionary: (NSDictionary *)dict{
    self = [super init];//self调用者本身
    if (self){
        _hotelID = [[Utilities nullAndNilCheck:@"id" replaceBy:0] integerValue];
        _price = [[Utilities nullAndNilCheck:dict[@"price"] replaceBy:0]integerValue];
        self.hotel_img = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _hotel_address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];
        _start_time = [dict[@"start_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"start_time"] integerValue];
        _out_time = [dict[@"out_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"out_time"] integerValue];
        _room_img = [Utilities nullAndNilCheck:dict[@"room_img"] replaceBy:@""];
        _hotel_facility = [Utilities nullAndNilCheck:dict[@"hotel_facility"] replaceBy:@""];
        _hotel_type = [Utilities nullAndNilCheck:dict[@"hotel_type"] replaceBy:@""];
        if([dict[@"is_pet"] isKindOfClass:[NSNull class]]){
            _is_pet = @"";
        }else{
            switch ([dict[@"is_pet"]integerValue]) {
                case 0:
                    _is_pet = @"不可携带宠物";
                    break;
                case 1:
                    _is_pet = @"可携带宠物";
                    break;
                default:
                    _is_pet = @"未设置";
                    break;
            }
        }
    }
    return self;
}
@end
