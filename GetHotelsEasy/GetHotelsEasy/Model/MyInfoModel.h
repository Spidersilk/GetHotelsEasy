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
- (instancetype)initWithDict: (NSDictionary *)dict;
@end
