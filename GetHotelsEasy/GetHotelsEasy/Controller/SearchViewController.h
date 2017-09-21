//
//  SearchViewController.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 self. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>//使用该框架才可以使用定位功能
#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (strong, nonatomic)NSString* inDate;
@property (strong, nonatomic)NSString* outDate;
@property (strong, nonatomic) CLLocation *location;
@end
