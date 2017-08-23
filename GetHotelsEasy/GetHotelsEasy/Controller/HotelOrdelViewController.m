//
//  HotelOrdelViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import "HotelOrdelViewController.h"

@interface HotelOrdelViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *HotelNameImage;
@property (weak, nonatomic) IBOutlet UILabel *HotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *secodDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstDayBtn;
- (IBAction)firstDayAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *secondDayBtn;
- (IBAction)secondDayAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;
@property (weak, nonatomic) IBOutlet UILabel *bedTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *breakfastLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *parkLotLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *gymLabel;
@property (weak, nonatomic) IBOutlet UILabel *toiletriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *luggageLabel;
@property (weak, nonatomic) IBOutlet UILabel *wifiLabel;
@property (weak, nonatomic) IBOutlet UILabel *diningLabel;
@property (weak, nonatomic) IBOutlet UILabel *wakeUpLabel;

- (IBAction)chatBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)buyBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation HotelOrdelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//将要来到此页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)firstDayAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)secondDayAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)chatBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)buyBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
