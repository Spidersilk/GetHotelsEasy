//
//  OfferListModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferListModel : NSObject

@property(strong, nonatomic)NSString *departure;        //出发地
@property(strong, nonatomic)NSString *destination;      //目的地
@property(nonatomic)NSInteger in_time;          //起飞时间
@property(nonatomic)NSInteger out_time;          //起飞时间
@property(strong, nonatomic)NSString *final_price;      //价格
@property(strong, nonatomic)NSString *flight_no;        //航空编号
@property(strong, nonatomic)NSString *aviation_cabin;   //客舱类型
@property(strong, nonatomic)NSString *aviation_company; //航空公司

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
