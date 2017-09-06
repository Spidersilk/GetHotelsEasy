//
//  OfferListModel.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferListModel : NSObject

@property(strong, nonatomic)NSString *oRoute;
@property(strong, nonatomic)NSString *oPrice;
@property(strong, nonatomic)NSString *oTime;
@property(strong, nonatomic)NSString *oType;
@property(strong, nonatomic)NSString *flight;

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
