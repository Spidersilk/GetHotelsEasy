//
//  OfferTableViewCell.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oRouteLabel;//路线
@property (weak, nonatomic) IBOutlet UILabel *oPriceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *oTimeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *oType;//舱的类型
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;//航班
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
