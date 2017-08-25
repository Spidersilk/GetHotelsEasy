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
        self.longitude = [[Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:0] integerValue];
        self.hotel_img = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _latitude = [[Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:0] integerValue];
        _hotel_address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];

       
    }
    return self;
}

@end
