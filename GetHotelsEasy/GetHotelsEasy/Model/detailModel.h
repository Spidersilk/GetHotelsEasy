//
//  detailModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailModel : NSObject
@property (strong, nonatomic) NSString *business_id;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *hotel_img;//首页图片
@property (strong, nonatomic) NSString *hotel_name;//酒店
@property (strong, nonatomic) NSString *hotel_address;//地址
@property ( nonatomic) NSInteger longitude;//经度
@property ( nonatomic) NSInteger latitude;//纬度
- (id) initWhitDictionary: (NSDictionary *)dict;

@end
