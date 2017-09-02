//
//  IssuingTableViewCell.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssuingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
