//
//  ExpiredTableViewCell.h
//  GetHotelsEasy
//
//  Created by admin7 on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpiredTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roomLable;
@property (weak, nonatomic) IBOutlet UILabel *locationLable;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *inTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *outTimeLabel;
@end
