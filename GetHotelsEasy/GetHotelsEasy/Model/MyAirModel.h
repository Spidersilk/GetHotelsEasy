//
//  MyAirModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAirModel : NSObject

@property(strong, nonatomic)NSString *oRoute;
@property(strong, nonatomic)NSString *oPrice;
@property(strong, nonatomic)NSString *oTime;
@property(strong, nonatomic)NSString *oType;

@property(strong, nonatomic)NSString *iRoute;
@property(strong, nonatomic)NSString *iPrice;
@property(strong, nonatomic)NSString *iTime;
@property(strong, nonatomic)NSString *iType;

@property(strong, nonatomic)NSString *hRoute;
@property(strong, nonatomic)NSString *hPrice;
@property(strong, nonatomic)NSString *hTime;
@property(strong, nonatomic)NSString *hType;

- (instancetype)initWithDict: (NSDictionary *)dict;
- (instancetype)initWithDictForIssuing: (NSDictionary *)dict;
- (instancetype)initWithDictForHistory: (NSDictionary *)dict;

@end
