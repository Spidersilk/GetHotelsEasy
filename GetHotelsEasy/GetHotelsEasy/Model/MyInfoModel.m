//
//  MyInfoModel.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 self. All rights reserved.
//

#import "MyInfoModel.h"

@implementation MyInfoModel

- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.grade = [[Utilities nullAndNilCheck:dict[@"grade"] replaceBy:0] integerValue];
        self.name = [Utilities nullAndNilCheck:dict[@"nick_name"] replaceBy:@""];
        self.picture = [Utilities nullAndNilCheck:dict[@"head_img"] replaceBy:@""];
    }
    return self;
}
@end
