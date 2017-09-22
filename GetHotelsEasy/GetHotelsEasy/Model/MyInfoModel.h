//
//  MyInfoModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfoModel : NSObject

@property (strong, nonatomic) NSString *name;       //昵称
@property (strong, nonatomic) NSString *picture;    //头像
@property (nonatomic) NSInteger grade;      //等级
@property (nonatomic) NSInteger Id;
@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString *final_in_time_str;
@property (strong, nonatomic) NSString *final_out_time_str;
@property (strong, nonatomic) NSString *final_price;
@property (strong, nonatomic) NSString *hotel_address;
@property (strong, nonatomic) NSString *hotel_name;
@property (nonatomic) NSInteger state;

- (instancetype)initWithDict: (NSDictionary *)dict;
- (instancetype)initWithForAll: (NSDictionary *)dict;
- (instancetype)initWithDictForWork: (NSDictionary *)dict;
- (instancetype)initWithDictForExpired: (NSDictionary *)dict;

@end
