//
//  OfferDetailViewController.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAirModel.h"
#import "OfferListModel.h"

@interface OfferDetailViewController : UIViewController

@property (strong, nonatomic) MyAirModel *AirModel;
@property (strong, nonatomic) OfferListModel *listModel;

@end
