//
//  detailModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailModel : NSObject
@property (strong, nonatomic) NSString *name;   //酒店名字
@property (strong, nonatomic) NSString *hotel_img;//首页图片
@property (strong, nonatomic) NSString *hotel_name;//酒店
@property (strong, nonatomic) NSString *hotel_address;//地址
@property (nonatomic) NSInteger price; //价格
@property (nonatomic) NSInteger longitude;//经度
@property (nonatomic) NSInteger latitude;//纬度
@property (nonatomic) NSInteger hotelID; //酒店id
- (id) initWhitDictionary: (NSDictionary *)dict;

@end
