//
//  PurchaseTableViewController.h
//  GetHotelsEasy
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
#import "OfferListModel.h"
@interface PurchaseTableViewController : UITableViewController
@property (strong, nonatomic) detailModel *detail;
@property (strong, nonatomic) OfferListModel *offerList;
@end
