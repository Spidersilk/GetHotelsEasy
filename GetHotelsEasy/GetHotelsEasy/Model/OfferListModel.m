//
//  OfferListModel.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import "OfferListModel.h"

@implementation OfferListModel

- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.oRoute = [Utilities nullAndNilCheck:dict[@"oRoute"] replaceBy:@""];
        self.flight = [Utilities nullAndNilCheck:dict[@"flight"] replaceBy:@""];
        self.oTime = [Utilities nullAndNilCheck:dict[@"oTime"] replaceBy:@""];
        self.oType = [Utilities nullAndNilCheck:dict[@"oType"] replaceBy:@""];
        self.oPrice = [Utilities nullAndNilCheck:dict[@"oPrice"] replaceBy:@""];
    }
    return self;
}
@end
