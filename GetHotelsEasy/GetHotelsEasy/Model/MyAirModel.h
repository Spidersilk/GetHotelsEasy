//
//  MyAirModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAirModel : NSObject

@property(strong, nonatomic)NSString *start_time_str;   //出发时间
@property(strong, nonatomic)NSString *departure;        //出发地
@property(strong, nonatomic)NSString *destination;      //目的地
@property(nonatomic)NSInteger company;              //航空公司
@property(strong, nonatomic)NSString *price;        //成交价
@property(strong, nonatomic)NSString *highPrice;    //最高价
@property(strong, nonatomic)NSString *lowPrice;     //最低价价
@property(strong, nonatomic)NSString *demand;       //要求
@property(nonatomic)NSInteger Id;                   //订单id
@property (nonatomic) NSTimeInterval start_time;


- (instancetype)initWithDict: (NSDictionary *)dict;
- (instancetype)initWithDictForIssuing: (NSDictionary *)dict;
- (instancetype)initWithDictForHistory: (NSDictionary *)dict;

@end
