//
//  HotelTableViewCell.h
//  GetHotelsEasy
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotelImg;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;

@end
