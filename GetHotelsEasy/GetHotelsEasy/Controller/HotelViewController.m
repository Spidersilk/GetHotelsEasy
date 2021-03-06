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
#import "HotelCollectionViewCell.h"
#import "LabelCollectionViewCell.h"
#import "HotelOrdelViewController.h"
#import "SearchViewController.h"
#import "CityTableViewController.h"
#import "JSONS.h"
#import "NSDate+Utility.h"

@interface HotelViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL firstVisit;
    NSInteger page;//页码
    BOOL pageLast;
    NSInteger flag;
}
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *HotelTableView;
@property (weak, nonatomic) UIActivityIndicatorView *avi;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)ctiyAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)searchBtnAction:(UIButton *)sender;
@property (strong, nonatomic) NSDictionary *cities;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) CLLocationManager *locMgr;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSArray *optionsArr;
@property (weak, nonatomic) IBOutlet UIToolbar *Toolbar;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)Done:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *picker;
@property (strong, nonatomic) UIButton *Btn1;
@property (strong, nonatomic) UIButton *Btn2;
@property (strong, nonatomic) UIButton *Btn3;
@property (strong, nonatomic) UIButton *Btn4;
@property (strong, nonatomic) UIView *uiv;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *collectionCellOne;
@property (strong, nonatomic) NSArray *collectionCellTwo;

@property (strong, nonatomic) NSIndexPath *tableViewIndexPath;
@property (strong, nonatomic) NSIndexPath *cellindexPathNowOne;
@property (strong, nonatomic) NSIndexPath *cellindexPathNowTwo;
@property (strong, nonatomic) NSIndexPath *cellindexPathOne;
@property (strong, nonatomic) NSIndexPath *cellindexPathTwo;

@property (nonatomic) NSInteger sortingid;
@property (strong, nonatomic) NSString *theDate;
@property (strong, nonatomic) NSString *inDate;
@property (strong, nonatomic) NSString *outDate;
@property (strong, nonatomic) NSDate * indate;//储存入住时间戳
@property (strong, nonatomic) NSDate * outdate;//储存离店时间戳




@property (strong, nonatomic) UIView * shadeView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLable;
@property (weak, nonatomic) IBOutlet UILabel *tempLable;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (weak, nonatomic) NSString* icon;//天气图片

@property (nonatomic, strong) CLGeocoder *geoC;

@property (nonatomic) NSInteger teg;
@property (nonatomic) NSInteger teger;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yPosition;

@property (strong, nonatomic) UIImageView *Img;//没有数据添加的图片
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//q去掉状态栏的空白
    //self.navigationController.navigationBar.translucent = NO;
    firstVisit = YES;
    _headerView.frame=CGRectMake(0, 0, UI_SCREEN_W, 165);
    _arr = [NSMutableArray new];
    _imageArray = [NSMutableArray new];
    _HotelTableView.tableFooterView = [UIView new];
    _collectionCellOne = @[@"星级",@"全部",@"四星",@"五星"];
    _collectionCellTwo = @[@"  价格区间",@"不限",@"300以下",@"301-500",@"",@"",@"501-1000",@"1000以上"];
    _optionsArr = @[@"智能排序",@"价格低到高",@"价格高到低",@"离我从近到远"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityStat:) name:@"ResetHome" object:nil];
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Searc:) name:@"SearcHome" object:nil];
    
    
    _picker.minimumDate = [NSDate date];
    page = 1;
    flag = 0;
    [self uilayout];//签署协议
    [self initial];
    [self initialBtn];//初始化Btn
    [self dataInitialize];//这个方法专门做数据的处理
    // Do any additional setup after loading the view.
    [self locationStart];//这个方法处理开始定位
    [self InitializeData];
    [self setRefreshControl];
    [self nothingForTableView];
    _picker.backgroundColor = UIColorFromRGB(235, 235, 241);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsSelection = YES;
    
    
    
    
}
- (void) initialBtn{
    if (flag == 0){
        NSDate *date = [NSDate date];
        _indate = date;
        NSDate *tomorrowdate =[NSDate dateTomorrow];
        //初始化一个日期格式器
        _outdate = tomorrowdate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //定义日期的格式为yyyy-MM-dd
        formatter.dateFormat = @"MM-dd";
        //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
        NSString *Date = [formatter stringFromDate:date];
        NSString *tomorrowDate = [formatter stringFromDate:tomorrowdate];
        //NSLog(@"date:%@",Date);
        _inDate = [NSString stringWithFormat:@"%@",Date];
        _outDate = [NSString stringWithFormat:@"%@",tomorrowDate];
    }
    
    // 创建按钮对象
    _Btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W/4, 40)];
    [_Btn1 setTitle:[NSString stringWithFormat:@"入住%@",_inDate] forState:UIControlStateNormal];
    [_Btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [_Btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _Btn1.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [_Btn1.layer setBorderWidth:0.3];//设置边框
    _Btn1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件1
    [_Btn1 addTarget:self action:@selector(Btn1Action) forControlEvents:UIControlEventTouchUpInside];
    
    _Btn2 = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4, 0, UI_SCREEN_W/4, 40)];
    [_Btn2 setTitle:[NSString stringWithFormat:@"离店%@",_outDate] forState:UIControlStateNormal];
    [_Btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [_Btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _Btn2.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [_Btn2.layer setBorderWidth:0.3];//设置边框
    _Btn2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件2
    [_Btn2 addTarget:self action:@selector(Btn2Action) forControlEvents:UIControlEventTouchUpInside];
    
    _Btn3 = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4*2, 0, UI_SCREEN_W/4, 40)];
    [_Btn3 setTitle:@"智能排序" forState:UIControlStateNormal];
    [_Btn3.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [_Btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _Btn3.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [_Btn3.layer setBorderWidth:0.3];//设置边框
    _Btn3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件3
    [_Btn3 addTarget:self action:@selector(Btn3Action) forControlEvents:UIControlEventTouchUpInside];
    
    _Btn4 = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4*3, 0, UI_SCREEN_W/4, 40)];
    [_Btn4 setTitle:@"筛选" forState:UIControlStateNormal];
    [_Btn4.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
    [_Btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _Btn4.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
    [_Btn4.layer setBorderWidth:0.3];//设置边框
    _Btn4.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件3
    [_Btn4 addTarget:self action:@selector(Btn4Action) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (void)initial{
    _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, UI_SCREEN_H*2)];
    _shadeView.backgroundColor =UIColorFromRGBA(235, 234, 235, 0.7);
    _shadeView.hidden = YES;
    [_HotelTableView addSubview:_shadeView];
    //创建uiview放置选项标签
    _uiv = [[UIView alloc]initWithFrame:CGRectMake(0, 205, UI_SCREEN_W, 200)];
    _uiv.backgroundColor = UIColorFromRGBA(255, 255, 255,1);
    _uiv.hidden = YES;
    [_HotelTableView addSubview:_uiv];
    _optionsTableView.frame = _uiv.bounds;
    [self collectionViewInitialize];
    
    [_uiv addSubview:_optionsTableView];
    //创建手势
    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange)];
    //r5.numberOfTapsRequired = 1;
    //NSLog(@"阀门%lu",(unsigned long)r5.numberOfTapsRequired);
    [_shadeView addGestureRecognizer:r5];
    
    
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
    //NSLog(@"这两点的距离为：%f",distance);
    NSString *str = [NSString stringWithFormat:@"距离：%.1f 公里",(distance/1000)];
    //NSLog(@"距离：%@",str);
    return  str;
    
}
#pragma mack - 网络请求
- (void)InitializeData{
    
    //点击按钮的时候创建一个蒙层（菊花膜）并显示在当前页面（self.view）
    _avi = [Utilities getCoverOnView:self.view];
    [self request];
}
//创建刷新指示器的方法
- (void)setRefreshControl{
    //以获取列表的刷新指示器
    UIRefreshControl *Ref = [UIRefreshControl new];
    [Ref addTarget:self action:@selector(Ref) forControlEvents:UIControlEventValueChanged];
    Ref.tag = 10001;
    [_HotelTableView addSubview:Ref];
}
//以获取列表的刷新
- (void)Ref{
    page = 1;
    [self request];
    
}
//执行网络请求
- (void)request {
    NSInteger  start;
    NSInteger price;
    if (_sortingid == 0) {
        _sortingid = 1;
    }
    if ([[StorageMgr singletonStorageMgr] objectForKey:@"start"] == NULL) {
        start = 1;
    }else{
        start = [[[StorageMgr singletonStorageMgr] objectForKey:@"start"] integerValue];//获取单例化全局变量
        //NSLog(@"start:%ld",(long)start);
    }
    if ([[StorageMgr singletonStorageMgr] objectForKey:@"priceid"] == NULL) {
        price = 1;
    }else{
        price = [[[StorageMgr singletonStorageMgr] objectForKey:@"priceid"] integerValue];//获取单例化全局变量
        //NSLog(@"price:%ld",(long)price);
    }
    //NSLog(@"入店时间%@",_inDate);
    //NSLog(@"离店时间%@",_outDate);
    //NSLog(@"这是排序ID:%ld",(long)_sortingid);
    NSDictionary *prarmeter = @{@"city_name":_cityBtn.titleLabel.text,@"pageNum" :@(page),@"pageSize":@5 ,@"startId":@(start),@"priceId":@(price),@"sortingId":@(_sortingid) ,@"inTime":[NSString stringWithFormat:@"2017-%@",_inDate],@"outTime":[NSString stringWithFormat:@"2017-%@",_outDate],@"wxlongitude":@"",@"wxlatitude":@""};
    
    //    NSMutableDictionary *muteDict = [NSMutableDictionary dictionaryWithDictionary:@{@"name" : @"YYX", @"gender" : @0}];
    //    if (/* DISABLES CODE */ (1) == 0) {
    //        [muteDict setObject:@"20" forKey:@"age"];
    //    } else {
    //        [muteDict setObject:@"30" forKey:@"age"];
    //    }
    
    //开始请求
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        //成功以后要做的事情
        //NSLog(@"responseObject = %@",responseObject);
        //       [self endAnimation];
        if ([responseObject[@"result"] integerValue] == 1) {
            //业务逻辑成功的情况下
            [_avi stopAnimating];
            //UIRefreshControl *强制转换
            UIRefreshControl *ref = (UIRefreshControl *)[_HotelTableView viewWithTag:10001];
            [ref endRefreshing];
            
            NSDictionary *content = responseObject[@"content"];
            pageLast = [content[@"hotel"][@"isLastPage"] boolValue];
            NSArray *list = content[@"hotel"][@"list"];
            NSArray *advertising = content[@"advertising"];
            if (_imageArray !=NULL) {
                [_imageArray removeAllObjects];
            }
            for (NSDictionary * dict in advertising){
                [_imageArray addObject: dict[@"ad_img"]];
            }
            [self addZLImageViewDisPlayView:_imageArray];
            if (page == 1) {
                //清空数据
                [_arr removeAllObjects];
            }
            
            for (NSDictionary *dict in list) {
                //用ActivityModel类中定义的初始化方法initWhitDictionary: 将遍历得来的字典dict转换成为initWhitDictionary对象
                detailModel *detailmodel = [[detailModel alloc] initWhitDictionary:dict];
                //将上述实例化好的ActivityModel对象插入_arr数组中
                //NSLog(@"hotelID:%ld",(long)detailmodel.hotelID);
                [_arr addObject:detailmodel];
            }
            //刷新表格（重载数据）
            [_HotelTableView reloadData];//reloadData重新加载activityTableView数据
            //
            
            if (_arr.count ==0) {
                _Img.hidden = NO;
            }else{
                _Img.hidden = YES;
                
            }
        }else{
            
            //            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_HotelTableView viewWithTag:10001];
        [ref endRefreshing];
        
        //        //失败以后要做的事情
        //        //NSLog(@"statusCode = %ld",(long)statusCode);
        //        [self endAnimation];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
    
    
}
- (void) WeatherRequest{
    // Do any additional setup after loading the view, typically from a nib.
    
    //NSString *weatherURLStr = @"http://api.openweathermap.org/data/2.5/weather?q=Wuxi,cn&appid=5ee88a19ade27e1f2dbc3730ea80d661";
    //获得全宇宙天气的接口（当前这一刻的天气）（api.openweathermap.org是一个开放天气接口提供商）
    //NSString *weatherURLStr =@"http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139,cn&appid=5ee88a19ade27e1f2dbc3730ea80d661";
    NSString *weatherURLStr =[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=5ee88a19ade27e1f2dbc3730ea80d661&lang=zh_cn&find?q=London&units=metric&weather?q=London",_location.coordinate.latitude,_location.coordinate.longitude];
    
    //NSLog(@"经度：%f",_location.coordinate.latitude);
    //NSLog(@"纬度：%f",_location.coordinate.longitude);
    
    //将字符串转换成NSURL对象
    NSURL *weatherURL = [NSURL URLWithString:weatherURLStr];
    //初始化单例化的NSURLSession对象(专门用来进行网络请求的类)
    NSURLSession *session = [NSURLSession sharedSession];
    //创建一个基于NSURLSession的请求（除了请求任务还有上传和下载任务可以选择）任务并处理完成后的回调
    NSURLSessionDataTask *jsonDataTask = [session dataTaskWithURL:weatherURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"请求完成，开始做事");
        if (!error) {
            NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
            if (httpRes.statusCode == 200) {//成功
                //NSLog(@"网络请求成功，真的开始做事");
                //将JSON格式的数据流data用JSONS工具包里的NSData下的Category中的JSONCol方法转化为OC对象（Array或Dictionary）
                id jsonObject = [data JSONCol];//把数据流改为oc语言对象
                NSInteger temp= [jsonObject[@"main"][@"temp"]integerValue]/1;
                //NSLog(@"温度：%ld",(long)temp);
                NSString* description = jsonObject[@"weather"][0][@"description"];
                //NSLog(@"天气：%@",description);
                _icon = jsonObject[@"weather"][0][@"icon"];
                //NSLog(@"图片：%@",_icon);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@"字符个数：%lu",(unsigned long)description.length);
                    
                    if (description.length>3) {
                        [_weatherLabel setFont:[UIFont boldSystemFontOfSize:7]];
                        NSString *cca2 =  [description stringByReplacingOccurrencesOfString:@"，" withString:@","];
                        
                        //NSLog(@"字符,：%@",cca2);
                        _weatherLabel.text = cca2;
                    }else{
                        [_weatherLabel setFont:[UIFont boldSystemFontOfSize:9]];
                        _weatherLabel.text = description;
                    }
                    
                    _tempLable.text = [NSString stringWithFormat:@"%ld°c",(long)temp];
                    [_weatherImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",_icon]] placeholderImage:[UIImage imageNamed:@"png2"]];
                    
                    
                    
                });
                //NSLog(@"%@", jsonObject);
            } else {
                //NSLog(@"%ld", (long)httpRes.statusCode);
            }
        } else {
            //NSLog(@"%@", error.description);
        }
    }];
    //让任务开始执行
    [jsonDataTask resume];
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
    
    if ([[Utilities getUserDefaults:@"UserCityop"] isKindOfClass:[NSNull class]]) {
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
        [_cityBtn setTitle:[Utilities getUserDefaults:@"UserCity"] forState:UIControlStateNormal];
    }
}

//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    //NSLog(@"经度:%f",newLocation.coordinate.longitude);
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
                //NSLog(@"locDict:%@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                //NSLog(@"locDict:%@",cityStr);
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                //将定位到的城市存进单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:cityStr];
                if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
                    //当定位到的城市和当前选择的城市不一样的时候，弹窗询问是否要切换城市
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@,是否切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
                        _cityBtn.titleLabel.text = cityStr;
                        //修改用户选择的城市
                        [Utilities removeUserDefaults:@"UserCity"];
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新进行网络请求
                        [self InitializeData];
                        
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                };
                
            }
        }];
        [self WeatherRequest];
        [_locMgr stopUpdatingLocation];
    });
}

- (void) checkCityStat:(NSNotification *)note {
    NSString *cityStr = note.object;
    if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
        //修改城市按钮标题
        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
        _cityBtn.titleLabel.text = cityStr;
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //[self dataInitialize];
        //重新进行网络请求
        [self geoCoder:cityStr];//地理编码
        [self InitializeData];
    }
}
//懒加载
-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
//地理编码
- (void)geoCoder:(NSString*)cityStr {
    // 容错
    if([cityStr length] == 0)
        return;
    [self geoC];
    [_geoC geocodeAddressString:cityStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *pl = [placemarks firstObject];
        if(!error)
        {
            _location= pl.location;
            [self WeatherRequest];
        }else
        {
            //NSLog(@"错误");
        }
    }];
}

//- (void) Searc:(NSNotification *)note {
//    NSMutableArray *arr = [NSMutableArray new];
//    arr = note.object;
//    _arr = arr;
//    [_HotelTableView reloadData];
//}

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
    if (tableView == _HotelTableView) {
        return 100;
    }else{
        return _optionsTableView.frame.size.height/4;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _HotelTableView) {
        return _arr.count;
    }else{
        return _optionsArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _HotelTableView) {
        HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
        detailModel *detailmodel = _arr[indexPath.row];
        //NSLog(@"reee图片的网址%@",detailmodel.hotel_img);
        NSString *userAgent = @"";
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
            [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        }
        /////////////////////////
        [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                     forHTTPHeaderField:@"Accept"];
        [cell.hotelImg sd_setImageWithURL:[NSURL URLWithString:detailmodel.hotel_img] placeholderImage:[UIImage imageNamed:@"png2"]];
        cell.hotelName.text = detailmodel.hotel_name;
        cell.address.text = detailmodel.hotel_address;
        //通过distanceBetweenOrderBy方法获取两地距离
        NSString *str = [self distanceBetweenOrderBy:_location.coordinate.latitude :[detailmodel.latitude doubleValue] :_location.coordinate.longitude :[detailmodel.longitude doubleValue]];
                         //:_location.coordinate.latitude :detailmodel.latitude :_location.coordinate.longitude :detailmodel.longitude];
        cell.distanceLabel.text = str;
        cell.priceLabel.text =[NSString stringWithFormat:@"%ld",(long)detailmodel.price];
        return cell;
    }else{
        UITableViewCell *beforecell = [_optionsTableView cellForRowAtIndexPath:_tableViewIndexPath];
        beforecell.textLabel.textColor = UIColorFromRGB(10, 127, 254);
        beforecell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"optionsCell" forIndexPath:indexPath];
        cell.textLabel.text = _optionsArr[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        return cell;
    }
}
//点击细胞事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _HotelTableView) {
        HotelOrdelViewController *purchaseVC = [Utilities getStoryboardInstance:@"Order" byIdentity:@"ordelDetail"];
        detailModel *detail = _arr [indexPath.row];
        //NSLog(@"zhebian:%ld",(long)detail.hotelID);
        purchaseVC.hotelID = detail.hotelID;
        [self.navigationController pushViewController:purchaseVC animated:NO];
    }else{
        if (indexPath !=_tableViewIndexPath) {
            
            page = 1;
            UITableViewCell *cell = [_optionsTableView cellForRowAtIndexPath:indexPath];
            cell.tintColor = UIColorFromRGB(10, 127, 254);
            cell.textLabel.textColor = UIColorFromRGB(10, 127, 254);
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *beforecell = [_optionsTableView cellForRowAtIndexPath:_tableViewIndexPath];
            beforecell.textLabel.textColor = [UIColor darkGrayColor];
            beforecell.accessoryType = UITableViewCellAccessoryNone;
            _tableViewIndexPath = indexPath;
            _sortingid = indexPath.row+1;
            NSString *str =_optionsArr[indexPath.row];
            [_Btn3 setTitle:str forState:UIControlStateNormal];
            [self InitializeData];
            _optionsTableView.hidden = YES;
            _uiv.hidden = YES;
            _HotelTableView.scrollEnabled = YES;
            _shadeView.hidden = YES;
        }
    }
}
//第一页最后一个细胞将要出现的时候
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView ==_HotelTableView) {
        if (indexPath.row == _arr.count-1) {
            if (!pageLast) {
                page++;
                [self request];
                //NSLog(@"还有下一页");
            }else{//NSLog(@"最后一页");
            }
        }
    }
    
    
}


////当某一个页面跳转行为将要发生的时候
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"HotelToOrder"]) {
//        //当列表页到详情页的这个跳转要发生的时候
//        //1.获取要传递到下一页的数据
////        NSIndexPath *indexPath = [_activityTableView indexPathForSelectedRow];
////        ActivityModel *activity = _arr[indexPath.row];
//        //2.获取下一页的实例
//        HotelOrdelViewController *detailVC = segue.destinationViewController;
//        //3.把数据给下一页预备好的接收容器
//        //detailVC.activity = activity;
//    }
//}
#pragma mack - 选项卡
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _HotelTableView) {
        // 创建包含标题标签的父视图
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 20.0)];
        UIImageView *bg = [[UIImageView alloc]initWithFrame:customView.frame];
        bg.image = [UIImage imageNamed:@"carTypeCellTitleBg1.png"];
        [customView addSubview:bg];
        
        
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
        [customView addSubview:_Btn1];
        [customView addSubview:_Btn2];
        [customView addSubview:_Btn3];
        [customView addSubview:_Btn4];
        //[customView addSubview:headerLabel];
        return customView;
        
        
    }else{
        return 0;
    }
}
//- (UIButton*)createBtn: (NSString*)btn :(NSString*)btnTitle: (CGFloat) btnFrame: (NSString*)btnAction{
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnFrame, 0, UI_SCREEN_W/4, 30)];
//    [btn setTitle:btnTitle forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
//    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    btn.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
//    [btn.layer setBorderWidth:0.3];//设置边框
//    btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    //添加事件3
//    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//    return btn;
//}
- (void)Btn1Action{
    //NSLog(@"Btn1被按了");
    
    //_picker.maximumDate = [NSDate dateTomorrow];//设置datePicker的最小时间
    flag = 1;
    _picker.hidden = NO;
    _Toolbar.hidden = NO;
    _shadeView.hidden = NO;
    _uiv.hidden = YES;
    [self layoutConstraints:0];
}
- (void)Btn2Action{
    //NSLog(@"Btn2被按了");
    //_picker.minimumDate = [NSDate dateTomorrow];//设置datePicker的最小时间
    flag = 2;
    _picker.hidden = NO;
    _Toolbar.hidden = NO;
    _shadeView.hidden = NO;
    _uiv.hidden = YES;
    [self layoutConstraints:0];
}
- (void)Btn3Action{
    
    //NSLog(@"Btn3被按了");
    if (_arr.count != 0) {
        [_HotelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    _uiv.hidden = NO;
    _optionsTableView.hidden = NO;
    _HotelTableView.scrollEnabled = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.hidden = YES;
    _shadeView.hidden = NO;
    _picker.hidden = YES;
    _Toolbar.hidden = YES;
    
}
- (void)Btn4Action{
    //NSLog(@"Btn4被按了");
    if (_cellindexPathOne != _cellindexPathNowOne) {
        [self selectedIndexPathNowpath:_cellindexPathNowOne Beforepath:_cellindexPathOne];
    }
    if (_cellindexPathTwo != _cellindexPathNowTwo) {
        [self selectedIndexPathNowpath:_cellindexPathNowTwo Beforepath:_cellindexPathTwo];
    }
    if (_arr.count != 0) {
        [_HotelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    //    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    _optionsTableView.hidden = YES;
    _collectionView.hidden = NO;
    _HotelTableView.scrollEnabled = NO;
    _collectionView.scrollEnabled = NO;
    _uiv.hidden = NO;
    
    _shadeView.hidden = NO;
    
    _picker.hidden = YES;
    _Toolbar.hidden = YES;
    
}
- (void)layoutConstraints:(CGFloat)space {
    CGFloat distance = 0;
    if (space == 0) {
        distance = _yPosition.constant;
    } else {
        distance = 200 - _yPosition.constant;
    }
    CGFloat percentage = distance / 200.f;
    [UIView animateWithDuration:0.8f * percentage delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _yPosition.constant = space;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _HotelTableView) {
        return 40;
    }else{
        return 0;
    }
    
}

- (IBAction)ctiyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    CityTableViewController *city = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"City"];
    city.flag =1;
    [self.navigationController pushViewController:city animated:NO];
}

- (IBAction)searchBtnAction:(UIButton *)sender {
    SearchViewController *search = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"search"];
    search.inDate = _inDate;
    search.outDate = _outDate;
    search.location = _location;
    [self.navigationController pushViewController:search animated:YES];
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self layoutConstraints:-320];
    //    _picker.hidden = YES;
    //    _Toolbar.hidden = YES;
    _shadeView.hidden = YES;
}

- (IBAction)Done:(UIBarButtonItem *)sender {
    [self layoutConstraints:-320];
    //拿到当前datepicker选择的时间
    NSDate *date= _picker.date;
    
    
    //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"MM-dd";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    _theDate = [formatter stringFromDate:date];
    //NSLog(@"离店时间1：%@",_theDate);
    
    
    if (flag ==1) {
        if(_outdate >date){
            _indate = date;
            //_Btn1.titleLabel.text = theDate;
            NSString *str = [NSString stringWithFormat:@"入住%@",_theDate];
            [_Btn1 setTitle:str forState:UIControlStateNormal];
            //NSLog(@"离店时间2：%@",_Btn1.titleLabel.text);
            _inDate = _theDate;
            //        _picker.hidden = YES;
            //        _Toolbar.hidden = YES;
            _shadeView.hidden = YES;
            [self InitializeData];
        }else{
            _indate = date;
            //_Btn1.titleLabel.text = theDate;
            NSString *str = [NSString stringWithFormat:@"入住%@",_theDate];
            [_Btn1 setTitle:str forState:UIControlStateNormal];
            //NSLog(@"离店时间2：%@",_Btn1.titleLabel.text);
            _inDate = _theDate;
            //        _picker.hidden = YES;
            //        _Toolbar.hidden = YES;
            //NSLog(@"离店时间3：%@",_outdate);
            _outdate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
            //NSLog(@"离店时间3：%@",_outdate);
            _theDate = [formatter stringFromDate:_outdate];
            _outDate = _theDate;
            NSString *str1 = [NSString stringWithFormat:@"离店%@",_theDate];
            [_Btn2 setTitle:str1 forState:UIControlStateNormal];
            
            _shadeView.hidden = YES;
            [self InitializeData];
        }
        
    }else if(flag == 2){
        if(_indate <date){
            _outdate = date;
            NSString *str = [NSString stringWithFormat:@"离店%@",_theDate];
            [_Btn2 setTitle:str forState:UIControlStateNormal];
            //_Btn2.titleLabel.text = _theDate;
            //NSLog(@"离店时间3：%@",_Btn2.titleLabel.text);
            _outDate = _theDate;
            //            _picker.hidden = YES;
            //            _Toolbar.hidden = YES;
            _shadeView.hidden = YES;
            [self InitializeData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"提示请输入正确日期" andTitle:@"提示" onView:self];
            _shadeView.hidden = YES;
        }
    }
    
    
}
#pragma mack - collectionView
- (void)collectionViewInitialize{
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 200);
    //该方法也可以设置itemSize
    //layout.itemSize =CGSizeMake(UI_SCREEN_W, 300);
    
    
    //2.初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:_uiv.bounds collectionViewLayout:layout];
    //_collectionView.bounds = CGRectMake(0, 0, UI_SCREEN_W, _uiv.frame);
    [_uiv addSubview:_collectionView];
    _collectionView.hidden = YES;
    _collectionView.backgroundColor = UIColorFromRGBA(255, 255, 255, 1);
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_collectionView registerClass:[HotelCollectionViewCell class] forCellWithReuseIdentifier:@"BtnCell"];
    [_collectionView registerClass:[LabelCollectionViewCell class] forCellWithReuseIdentifier:@"lableCell"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //创建确定按钮
    UIButton* DoneBtn = [[UIButton alloc] initWithFrame:CGRectMake((UI_SCREEN_W/2-(UI_SCREEN_W/4+25)/2), 155, UI_SCREEN_W/4+30, 25)];
    [DoneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [DoneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];//设置字体大小
    [DoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DoneBtn.backgroundColor = UIColorFromRGBA(73, 162, 254, 1);
    //[DoneBtn.layer setBorderWidth:0.8];//设置边框
    DoneBtn.layer.cornerRadius = 5.0 ;
    //DoneBtn.titleLabel.textColor = [UIColor redColor];
    //DoneBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //添加事件
    [DoneBtn addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    [_collectionView addSubview:DoneBtn];
    
}
//多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else{
        return 8;
    }
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LabelCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"lableCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HotelCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"BtnCell" forIndexPath:indexPath];
            NSString *str = _collectionCellOne[indexPath.row];
            [cell.button setTitle:str forState:UIControlStateNormal];
            
            
            return cell;
            
        }else{
            _cellindexPathOne = [NSIndexPath indexPathForRow:1 inSection:0];
            _cellindexPathNowOne =[NSIndexPath indexPathForRow:1 inSection:0];
            LabelCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"lableCell" forIndexPath:indexPath];
            cell.lable.text = _collectionCellOne[indexPath.row];
            
            LabelCollectionViewCell *beforecell = (LabelCollectionViewCell *)[_collectionView cellForItemAtIndexPath:_cellindexPathNowOne];
            beforecell.lable.textColor = UIColorFromRGB(104, 187, 238);
            beforecell.lable.layer.borderColor = [UIColorFromRGB(104, 187, 238) CGColor];
            return cell;
            
        }
    }else {
        if (indexPath.row == 0) {
            HotelCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"BtnCell" forIndexPath:indexPath];
            NSString *str = _collectionCellTwo[indexPath.row];
            [cell.button setTitle:str forState:UIControlStateNormal];
            return cell;
            
        }else{
            if (indexPath.row == 4||indexPath.row == 5) {
                cell.lable.hidden = YES;
            }
            _cellindexPathTwo = [NSIndexPath indexPathForRow:1 inSection:1];
            _cellindexPathNowTwo =[NSIndexPath indexPathForRow:1 inSection:1];
            LabelCollectionViewCell *beforecell = (LabelCollectionViewCell *)[_collectionView cellForItemAtIndexPath:_cellindexPathNowTwo];
            //beforecell.layer.cornerRadius = 5.0 ;
            beforecell.lable.textColor = UIColorFromRGB(104, 187, 238);
            beforecell.lable.layer.borderColor = [UIColorFromRGB(104, 187, 238) CGColor];
            cell.lable.text = _collectionCellTwo[indexPath.row];
            return cell;
        }
        
    }
    
    
    
    
}



//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//
//} // called when the user taps on an already-selected item in multi-select mode




//每个细胞的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    CGFloat x = self.view.frame.size.width-40;
    //    CGFloat space = self.view.frame.size.width / 200;
    //    return CGSizeMake(( x-  space* 3) / 4, (x-  space* 3) / 4);
    
    if (indexPath.row == 0) {
        return CGSizeMake(70, 40);
        
    }else{
        if (indexPath.section == 0) {
            return CGSizeMake(50, 27);
        }else{
            if(indexPath.row == 4){
                return CGSizeMake(10, 27);
            }
            return CGSizeMake(70, 27);
        }
    }
    
    
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  10;
}
//细胞的横向间距（列间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //    if (section == 0) {
    //        return 20;
    //    }else{
    //        return 15;
    //    }
    return 20;
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{   _collectionView.allowsMultipleSelection = YES;
    //    HotelCollectionViewCell *cell = (HotelCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger msg = (long)indexPath.row;
    //NSLog(@"%ld",msg);
    if (indexPath.row == 0) {
        return;
        
    }else{
        if (indexPath.section == 0) {
            NSInteger str =indexPath.row;
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"start"];
            
            [[StorageMgr singletonStorageMgr] addKey:@"start" andValue:@(str)];
            
            if(indexPath.row != _cellindexPathOne.row){
                _cellindexPathOne = [self selectedIndexPathNowpath:indexPath Beforepath:_cellindexPathOne];
            }
            if(indexPath.row != _cellindexPathNowOne.row){
                [self selectedIndexPathNowpath:indexPath Beforepath:_cellindexPathNowOne];
                //NSLog(@"星级：%ld.%ld",(long)_cellindexPathNowOne.row,_cellindexPathNowOne.section);
                
            }
            
        }else{
            NSInteger ns = indexPath.row;
            if (ns >3) {
                ns=ns-2;
            }
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"priceid"];
            [[StorageMgr singletonStorageMgr] addKey:@"priceid" andValue:@(ns)];
            if(indexPath.row != _cellindexPathTwo.row ){
                _cellindexPathTwo = [self selectedIndexPathNowpath:indexPath Beforepath:_cellindexPathTwo];
            }
            if (indexPath.row != _cellindexPathNowTwo.row) {
                [self selectedIndexPathNowpath:indexPath Beforepath:_cellindexPathNowTwo];
                
            }
        }
    }
}
- (void)DoneAction{
    page = 1;
    [self InitializeData];
    _uiv.hidden = YES;
    _HotelTableView.scrollEnabled = YES;
    _collectionView.scrollEnabled = YES;
    _cellindexPathNowOne =_cellindexPathOne ;
    _cellindexPathNowTwo = _cellindexPathTwo;
    _collectionView.hidden = YES;
    _shadeView.hidden = YES;
    
}
- (NSIndexPath *)selectedIndexPathNowpath:(NSIndexPath *)nowpath Beforepath:(NSIndexPath *)beforepath{
    
    //NSLog(@"现在的%ld",(long)nowpath.row);
    
    //NSLog(@"旧的%ld",(long)beforepath.row);
    LabelCollectionViewCell *cell = (LabelCollectionViewCell *)[_collectionView cellForItemAtIndexPath:nowpath];
    //cell.layer.cornerRadius = 5.0 ;
    //cell.backgroundColor = UIColorFromRGBA(93, 185, 238, 0.9);
    cell.lable.textColor = UIColorFromRGB(104, 187, 238);
    cell.lable.layer.borderColor = [UIColorFromRGB(104, 187, 238) CGColor];
    LabelCollectionViewCell *beforecell = (LabelCollectionViewCell *)[_collectionView cellForItemAtIndexPath:beforepath];
    beforecell.lable.textColor = [UIColor lightGrayColor];
    beforecell.lable.layer.borderColor =[ [UIColor lightGrayColor]CGColor];
    
    //beforecell.selected = NO;
    [_collectionView deselectItemAtIndexPath:beforepath animated:YES];//这句是防止取消后，前面取消的cell被动选中；
    return nowpath;
}
-(void)buttonAction{
    _uiv.hidden = YES;
    
    
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(10, 10);
}

////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}

////通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
//    headerView.backgroundColor =[UIColor grayColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
//    label.text = @"这是collectionView的头部";
//    label.font = [UIFont systemFontOfSize:20];
//    [headerView addSubview:label];
//    return headerView;
//}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _uiv.hidden = YES;
    _shadeView.hidden = YES;
    _HotelTableView.scrollEnabled = YES;
    _collectionView.scrollEnabled = YES;
    
}


//蒙层手势方法
-(void)doTapChange{
    [self layoutConstraints:-320];
    _uiv.hidden = YES;
    _shadeView.hidden = YES;
    _HotelTableView.scrollEnabled = YES;
    _collectionView.scrollEnabled = YES;
    //    _picker.hidden = YES;
    //    _Toolbar.hidden = YES;
}
#pragma mack - 选项卡tableView
//tableView没东西的时候运行
- (void)nothingForTableView{
    
    _Img = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"no_things" ]];
    _Img.frame = CGRectMake((UI_SCREEN_W-100)/2, 250, 100, 100);
    
    
    [_HotelTableView addSubview:_Img];
    
}

















@end
