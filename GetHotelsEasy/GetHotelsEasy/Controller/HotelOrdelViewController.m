//
//  HotelOrdelViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import "HotelOrdelViewController.h"

@interface HotelOrdelViewController (){
    NSInteger flag;
}
@property (strong, nonatomic) UIActivityIndicatorView *avi;
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

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)canceAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;

@end

@implementation HotelOrdelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfing];
    [self setDefaultDateForButton];
    [self request];
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
- (void)setDefaultDateForButton{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期格式
    formatter.dateFormat = @"MM-dd cc";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    
    //将时间转换为字符串
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr = [formatter stringFromDate:dateTom];
    //将处理好的时间字符串设置给两个button
    [_firstDayBtn setTitle:dateStr forState:UIControlStateNormal];
    [_secondDayBtn setTitle:dateTomStr forState:UIControlStateNormal];
}
- (void)naviConfing
{
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(1, 150, 255);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条按钮的分格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //是否需要毛玻璃的效果
    self.navigationController.navigationBar.translucent = YES;
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 22, 22);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - request
- (void)request{
    _avi = [UIActivityIndicatorView new];
    NSDictionary *content = @{@"id" : @1};
    [RequestAPI requestURL:@"/findHotelById" withParameters:content andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject = %@",responseObject);
        if([responseObject[@"result"] integerValue] == 1)
        {
            
        }else{
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}
#pragma mark - datePicker
- (IBAction)firstDayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    _toolBar.hidden = NO;
    _datePicker.hidden = NO;
}
- (IBAction)secondDayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _toolBar.hidden = NO;
    _datePicker.hidden = NO;
}
- (IBAction)chatBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)buyBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)canceAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _datePicker.hidden = YES;
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的时间
    NSDate *date = _datePicker.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"MM-dd cc";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    NSString *theDate = [formatter stringFromDate:date];
    
    if (flag == 0) {
        [_firstDayBtn setTitle:theDate forState:UIControlStateNormal];
    }else{
        [_secondDayBtn setTitle:theDate forState:UIControlStateNormal];
    }

    _toolBar.hidden = YES;
    _datePicker.hidden = YES;
}
@end
