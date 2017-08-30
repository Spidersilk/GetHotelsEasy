//
//  HotelOrdelViewController.h
//  GetHotelsEasy
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
@interface HotelOrdelViewController : UIViewController
@property (strong, nonatomic) detailModel *detail;
@property (nonatomic) NSInteger hotelID;
@end
