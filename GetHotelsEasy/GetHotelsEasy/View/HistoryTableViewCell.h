//
//  HistoryTableViewCell.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *hPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hTypeLabel;

@end
