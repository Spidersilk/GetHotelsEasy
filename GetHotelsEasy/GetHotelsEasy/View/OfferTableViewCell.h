//
//  OfferTableViewCell.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *oPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oType;
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
