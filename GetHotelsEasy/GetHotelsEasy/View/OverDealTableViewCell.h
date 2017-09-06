//
//  OverDealTableViewCell.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverDealTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;//路线
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//起飞时间
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//公司和舱的类型

@end
