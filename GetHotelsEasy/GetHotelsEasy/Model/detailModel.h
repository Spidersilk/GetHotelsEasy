//
//  detailModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailModel : NSObject
@property (strong, nonatomic) NSString *hotel_img;//首页图片
@property (strong, nonatomic) NSString *hotel_name;//酒店
@property (strong, nonatomic) NSString *hotel_address;//地址
@property (nonatomic) NSTimeInterval start_time;//入住时间
@property (nonatomic) NSTimeInterval out_time;//离店时间
@property (strong, nonatomic) NSString *room_img;//房间图片
@property (nonatomic) NSInteger price; //价格
@property (strong, nonatomic) NSString *longitude;//经度
@property (strong, nonatomic) NSString *latitude;//纬度
@property (nonatomic) NSInteger hotelID; //酒店id
@property (strong, nonatomic) NSString *is_pet;//宠物
@property (strong, nonatomic) NSString *hotel_facilitys;//酒店设施
@property (strong, nonatomic) NSString *hotel_types;//房间类型
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *hotel_imgs;
- (id) initWhitDictionary: (NSDictionary *)dict;
- (instancetype) initWiihDetailDictionary: (NSDictionary *)dict;
@end
