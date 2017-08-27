//
//  HotelViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 self. All rights reserved.
//

#import "HotelViewController.h"
#import "HotelTableViewCell.h"
#import "HotelOrdelViewController.h"
#import <CoreLocation/CoreLocation.h>//使用该框架才可以使用定位功能
#import "ZLImageViewDisplayView.h"
#import "detailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotelViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    BOOL firstVisit;
    NSInteger page;//页码
}

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *HotelTableView;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)ctiyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSDictionary *cities;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) CLLocationManager *locMgr;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIToolbar *Toolbar;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)Done:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstVisit = YES;
    _headerView.frame=CGRectMake(0, 0, UI_SCREEN_W, 165);
    _arr = [NSMutableArray new];
    _imageArray = [NSMutableArray new];
    [self uilayout];//签署协议
    [self dataInitialize];//这个方法专门做数据的处理
    // Do any additional setup after loading the view.
    [self locationStart];//这个方法处理开始定位
    [self networkRequest];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//将要来到此页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
        
    
}


#pragma mack - 计算两地距离
-(NSString*)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    NSLog(@"这两点的距离为：%f",distance);
    NSString *str = [NSString stringWithFormat:@"距离：%.1f 公里",(distance/1000)];
    NSLog(@"距离：%@",str);
    return  str;
    
}
#pragma mack - 网络请求
//执行网络请求
- (void)networkRequest {
    page = 10;
    NSDictionary *prarmeter = @{@"city_name":@"无锡",@"pageNum" : @1,@"pageSize":@10, @"startId" :@1 , @"priceId":@1,@"sortingId" :@1 ,@"inTime" :@"2017-01-05" ,@"outTime" : @"2017-05-06",@"wxlongitude":@"",@"wxlatitude":@""};
    //开始请求
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情
        NSLog(@"responseObject = %@",responseObject);
 //       [self endAnimation];
        if ([responseObject[@"result"] integerValue] == 1) {
            //业务逻辑成功的情况下
            NSDictionary *content = responseObject[@"content"];
            NSArray *list = content[@"hotel"][@"list"];
            NSArray *advertising = content[@"advertising"];
            for (NSDictionary * dict in advertising){
                [_imageArray addObject: dict[@"ad_img"]];
            }
   //         NSArray *imageArray = @[@"001.jpg", @"002.jpg", @"003.jpg", @"004.jpg", @"005.jpg", @"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"];
            [self addZLImageViewDisPlayView:_imageArray];
//            if (page == 1) {
//                //清空数据
//                [_arr removeAllObjects];
//            }
//            
            for (NSDictionary *dict in list) {
                //用ActivityModel类中定义的初始化方法initWhitDictionary: 将遍历得来的字典dict转换成为initWhitDictionary对象
                detailModel *detailmodel = [[detailModel alloc] initWhitDictionary:dict];
                //将上述实例化好的ActivityModel对象插入_arr数组中
                [_arr addObject:detailmodel];
            }
            //刷新表格（重载数据）
            [_HotelTableView reloadData];//reloadData重新加载activityTableView数据
//
        }else{
//            //业务逻辑失败的情况下
//            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
//            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
//        //失败以后要做的事情
//        //NSLog(@"statusCode = %ld",(long)statusCode);
//        [self endAnimation];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];



}


#pragma mack - 广告轮播
- (void)addZLImageViewDisPlayView:(NSArray *)imageArray{
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_W, 165);
    
    
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = imageArray;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.7;
    [self.headerView addSubview:imageViewDisplay];
    
//    [imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
//        NSString *str = [NSString stringWithFormat:@"我是第%ld张图片", imageIndex];
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alter show];
//    }];
    
}
#pragma mack - 地图定位
- (void) uilayout {
    if (![[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"] isKindOfClass:[NSNull class]]) {
        if ([[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"] != nil) {
            //已获取定位，将定位到的城市显示在按钮上
            [_cityBtn setTitle:[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"] forState:UIControlStateNormal];
            _cityBtn.enabled = YES;
            return;
        }
    }
    //当还没获取定位的情况下，去执行定位功能
    [self locationConfig];
}
- (void) locationConfig {
    //这个方法专门处理定位的基本设置
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //定位到的设备位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLHeadingFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    //打开定位服务的开关（开始定位）
    [_locMgr startUpdatingLocation];
}
//这个方法处理开始定位
- (void) locationStart {
    //（判断用户是否选择过定位）
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //询问用户是否愿意打开定位
#ifdef __IPHONE_8_0
        if ([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            //使用“使用中打开定位”这个策略去运用定位功能
            [_locMgr requestWhenInUseAuthorization];
        }
        
#endif
    }
    //打开定位服务的开关（开始定位）
    [_locMgr startUpdatingLocation];
}

//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error) {
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
                break;
            default:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
                break;
        }
    }
}
//这个方法专门做数据的处理
- (void)dataInitialize{
    BOOL appInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开APP
        appInit = YES;
    } else {
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //也说明是第一次打开APP
            appInit = YES;
        }
    }
    if (appInit) {
        NSString *userCity = _cityBtn.titleLabel.text;
        
        [Utilities setUserDefaults:@"UserCity" content:userCity];
        
    } else {
        //不是第一次来到APP则将记忆城市与按钮上的城市名反向同步
        NSString *userCity = [Utilities getUserDefaults:@"UserCity"];
        [_cityBtn setTitle:userCity forState:UIControlStateNormal];
    }
    
   
    
    
    
}

//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿到城市
    //NSLog(@"%@",[firstVisit]);
    if (firstVisit) {
        //NSLog(@"%@",firstVisit);
        firstVisit = !firstVisit;
        //根据定位拿到城市
        [self getRegeoViaCoordinate];
    }
    
}
- (void) getRegeoViaCoordinate {
    //duration表示从now开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用duration这个设置好的策略去做某些事
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                NSLog(@"locDict:%@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                NSLog(@"locDict:%@",cityStr);
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                //将定位到的城市存进单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:cityStr];
                //修改城市按钮标题
                [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
                _cityBtn.enabled = YES;
                
            }
        }];

        [_locMgr stopUpdatingLocation];
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mack - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    detailModel *detailmodel = _arr[indexPath.row];
    //NSLog(@"reee图片的网址%@",detailmodel.hotel_img);
    [cell.hotelImg sd_setImageWithURL:[NSURL URLWithString:detailmodel.hotel_img] placeholderImage:[UIImage imageNamed:@"png2"]];
    cell.hotelName.text = detailmodel.hotel_name;
    cell.address.text = detailmodel.hotel_address;
    //通过distanceBetweenOrderBy方法获取两地距离
    NSString *str = [self distanceBetweenOrderBy:_location.coordinate.latitude :detailmodel.latitude :_location.coordinate.longitude :detailmodel.longitude];
    cell.distanceLabel.text = str;
    cell.priceLabel.text =[NSString stringWithFormat:@"%ld",(long)detailmodel.price];

    return cell;
}
//点击细胞事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   

    
}

//当某一个页面跳转行为将要发生的时候
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"HotelToOrder"]) {
        //当列表页到详情页的这个跳转要发生的时候
        //1.获取要传递到下一页的数据
//        NSIndexPath *indexPath = [_activityTableView indexPathForSelectedRow];
//        ActivityModel *activity = _arr[indexPath.row];
        //2.获取下一页的实例
        HotelOrdelViewController *detailVC = segue.destinationViewController;
        //3.把数据给下一页预备好的接收容器
        //detailVC.activity = activity;
    }
}
#pragma mack - 选项卡
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 创建包含标题标签的父视图
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 20.0)];
    UIImageView *bg = [[UIImageView alloc]initWithFrame:customView.frame];
    bg.image = [UIImage imageNamed:@"carTypeCellTitleBg1.png"];
    [customView addSubview:bg];
    // 创建按钮对象
    UIButton *Btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W/4, 30)];
    [Btn1 setTitle:@"入住03-24" forState:UIControlStateNormal];
    [Btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [Btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    Btn1.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [Btn1.layer setBorderWidth:0.3];//设置边框
    Btn1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件1
    [Btn1 addTarget:self action:@selector(Btn1Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *Btn2 = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4, 0, UI_SCREEN_W/4, 30)];
    [Btn2 setTitle:@"离店03-28" forState:UIControlStateNormal];
    [Btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [Btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    Btn2.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [Btn2.layer setBorderWidth:0.3];//设置边框
    Btn2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件2
    [Btn2 addTarget:self action:@selector(Btn2Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *Btn3 = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4*2, 0, UI_SCREEN_W/4, 30)];
    [Btn3 setTitle:@"智能排序" forState:UIControlStateNormal];
    [Btn3.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [Btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    Btn3.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [Btn3.layer setBorderWidth:0.3];//设置边框
    Btn3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件3
    [Btn3 addTarget:self action:@selector(Btn3Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *Btn4 = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4*3, 0, UI_SCREEN_W/4, 30)];
    [Btn4 setTitle:@"筛选" forState:UIControlStateNormal];
    [Btn4.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [Btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    Btn4.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [Btn4.layer setBorderWidth:0.3];//设置边框
    Btn4.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件3
    [Btn4 addTarget:self action:@selector(Btn4Action) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:242.0/255.0f green:161.0/255.0f blue:4.0/255.0 alpha:1.0];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont italicSystemFontOfSize:15];
    headerLabel.frame = customView.frame;
    // 如果你想对齐标题文本以居中对齐
    // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    // headerLabel.text = <:Put display to want you whatever here>// i.e. array element
    headerLabel.text = @"title";
    [customView addSubview:Btn1];
    [customView addSubview:Btn2];
    [customView addSubview:Btn3];
    [customView addSubview:Btn4];
    //[customView addSubview:headerLabel];
    return customView;

}
- (void)Btn1Action{
    NSLog(@"Btn1被按了");
    _picker.hidden = NO;
    _Toolbar.hidden = NO;
}
- (void)Btn2Action{
    NSLog(@"Btn2被按了");
    _picker.hidden = NO;
    _Toolbar.hidden = NO;

}
- (void)Btn3Action{
    NSLog(@"Btn3被按了");
}
- (void)Btn4Action{
    NSLog(@"Btn4被按了");
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

- (IBAction)ctiyAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    _picker.hidden = YES;
    _Toolbar.hidden = YES;
}

- (IBAction)Done:(UIBarButtonItem *)sender {
    _picker.hidden = YES;
    _Toolbar.hidden = YES;
}
@end
