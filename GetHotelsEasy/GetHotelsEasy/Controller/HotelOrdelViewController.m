//
//  HotelOrdelViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import "HotelOrdelViewController.h"
#import "ZLImageViewDisplayView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PurchaseTableViewController.h"
@interface HotelOrdelViewController (){
    NSInteger flag;
}
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UIImageView *HotelNameImage;
@property (weak, nonatomic) IBOutlet UILabel *HotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

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
@property (strong, nonatomic) NSMutableArray *strFacility;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)buyBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)canceAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *is_petLabel;
@property (strong, nonatomic) NSMutableArray *imageArray;
@end

@implementation HotelOrdelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _strFacility = [NSMutableArray new];
    _imageArray = [NSMutableArray new];
    [self naviConfing];
    [self setDefaultDateForButton];
    [self request];
    [self addZLImageViewDisPlayView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) addZLImageViewDisPlayView{
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    CGRect frame = CGRectMake(0, 0, screenFrame.size.width, 165);
    
    NSArray *imageArray = @[@"hotelname",@"hotelname1",@"hotelname2"];
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = imageArray;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.6;
    [self.scrollView addSubview:imageViewDisplay];
    
   /* [imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        NSString *str = [NSString stringWithFormat:@"我是第%ld张图片", imageIndex];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }];*/
    
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
    formatter.dateFormat = @"yyyy-MM-dd";
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
    _avi = [Utilities getCoverOnView:self.view];
    //开始日期
    NSTimeInterval startTime = [Utilities cTimestampFromString:_firstDayBtn.titleLabel.text format:@"yyyy-MM-dd"];
    //结束日期
    NSTimeInterval endTime = [Utilities cTimestampFromString:_secondDayBtn.titleLabel.text format:@"yyyy-MM-dd"];
    
    if (startTime >= endTime) {
        [_avi stopAnimating];
        //UIRefreshControl *ref = [_historyTableView viewWithTag:10005];
        //[ref endRefreshing];
        [self setDefaultDateForButton];
        [Utilities popUpAlertViewWithMsg:@"请正确设置开始日期和结束日期" andTitle:@"提示" onView:self onCompletion:^{
        }];
    }else{
        NSLog(@"eeeee%ld",(long)_hotelID);
    NSDictionary *para = @{@"id" : @(_hotelID)};
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObjectOrder = %@",responseObject);
        if([responseObject[@"result"] integerValue] == 1)
        {
            NSDictionary *content = responseObject[@"content"];
            _detail = [[detailModel alloc] initWiihDetailDictionary:content];
            _HotelNameLabel.text = _detail.hotel_name;
            /*for(NSString *hotelImags in content[@"hotel_imgs"])
            {
                NSLog(@"hotelImags = %@",hotelImags);
                [_imageArray addObject:hotelImags];
            }*/
            //[self addZLImageViewDisPlayView:_imageArray];
            _priceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)_detail.price];
            _addressLabel.text = _detail.hotel_address;
            //NSURL *URL = [NSURL URLWithString:detailMd.hotel_img];
            [_hotelImage sd_setImageWithURL:[NSURL URLWithString:_detail.hotel_img] placeholderImage:[UIImage imageNamed:@"hotel123"]];
            /*NSLog(@"%@",detailMd.hotel_img);
            NSArray *arrayFacility = [detailMd.hotel_facilitys componentsSeparatedByString:@","];
            _parkLotLabel.text = arrayFacility[0];
            _pickUpLabel.text = arrayFacility[1];
            _gymLabel.text = arrayFacility[2];
            _toiletriesLabel.text = arrayFacility[3];*/
            NSArray *hotel_facilities = content[@"hotel_facilities"];
            for(NSInteger i = 0 ; i < hotel_facilities.count ; i ++){
                NSString *string = hotel_facilities[i];
                if (i == 0){
                    _parkLotLabel.text = string;
                }if(i == 1){
                    _pickUpLabel.text = string;
                }if(i == 2){
                    _gymLabel.text = string;
                }if(i == 3){
                    _toiletriesLabel.text = string;
                }if(i == 4){
                    _luggageLabel.text = string;
                }if(i == 5){
                    _wifiLabel.text = string;
                }if(i == 6){
                    _diningLabel.text = string;
                }if(i == 7){
                    _wakeUpLabel.text = string;
                }
            }
            NSArray *arrayType = content[@"hotel_types"];
            for(NSInteger i = 0 ; i < arrayType.count ; i++){
                NSString *string = arrayType[i];
                if(i == 0){
                    _bedTypeLabel.text = string;
                }
                if(i == 1){
                    _breakfastLabel.text = string;
                }
                if(i == 2){
                    _bedLabel.text = string;
                }
                if(i == 3){
                    _bedSizeLabel.text = string;
                }
            }
            //NSLog(@"hotel_facility = %@",arrayType[0]);
            //_bedLabel.text = strFacility[2];
            NSArray *remark = content[@"remarks"];
            for(NSInteger j = 0 ; j < remark.count ; j ++){
                NSString *rem = remark[j];
                NSLog(@"rem = %@",rem);
                if(j==0){
                    _firstLabel.text = rem;
                }if(j==1){
                    _secondLabel.text = rem;
                }
            }
            _is_petLabel.text = _detail.is_pet;
            /*if([detailMd.is_pet isEqualToString:@"0"])
            {
                _is_petLabel.text = @"不可携带宠物";
            }else{
                _is_petLabel.text = @"可携带宠物";
            }*/
            //NSString *startTimeStr = [Utilities dateStrFromCstampTime:detailMd.start_time withDateFormat:@"yyyy-MM-dd"];
            //NSLog(@"yjjftfytty%f",detailMd.start_time);
            //NSString *outTimeStr = [Utilities dateStrFromCstampTime:detailMd.out_time withDateFormat:@"yyyy-MM-dd"];
            //[_hotelImage sd_setImageWithURL:[NSURL URLWithString:detailMd.hot] placeholderImage:[UIImage imageNamed:@"png2"]];
        }else{
            [_avi stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    }
}
#pragma mark - datePicker
- (IBAction)firstDayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    _viewDate.hidden = NO;
    _toolBar.hidden = NO;
    _datePicker.hidden = NO;
}
- (IBAction)secondDayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _viewDate.hidden = NO;
    _toolBar.hidden = NO;
    _datePicker.hidden = NO;
}
- (IBAction)chatBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)buyBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        PurchaseTableViewController *purchaseVC = [Utilities getStoryboardInstance:@"Order" byIdentity:@"Purchase"];
        purchaseVC.detail = _detail;
        [self.navigationController pushViewController:purchaseVC animated:YES];
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Main" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
}
- (IBAction)canceAction:(UIBarButtonItem *)sender {
    _viewDate.hidden = YES;
    _toolBar.hidden = YES;
    _datePicker.hidden = YES;
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的时间
    NSDate *date = _datePicker.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"yyyy-MM-dd";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    NSString *theDate = [formatter stringFromDate:date];
    if (flag == 0) {
        [_firstDayBtn setTitle:theDate forState:UIControlStateNormal];
        [self request];
    }else{
        [_secondDayBtn setTitle:theDate forState:UIControlStateNormal];
        [self request];
    }
    _viewDate.hidden = YES;
    _toolBar.hidden = YES;
    _datePicker.hidden = YES;
}
@end
