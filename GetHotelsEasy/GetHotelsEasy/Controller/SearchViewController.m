//
//  SearchViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 self. All rights reserved.
//


#import "SearchViewController.h"
#import "HotelTableViewCell.h"
#import "HotelOrdelViewController.h"
#import "detailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger page;
}
@property (weak, nonatomic) IBOutlet UITableView *HotelTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) UIActivityIndicatorView *avi;

@property (strong, nonatomic) NSMutableArray *SearcArr;

@property (strong, nonatomic) UIImageView *Img;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _SearcArr = [NSMutableArray new];
    [self setRefreshControl];
    [self nothingForTableView];
    _HotelTableView.tableFooterView = [UIView new];
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
    //[self initial];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


//将要来到此页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏下面的线
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
  
    [self setNavigationItem];
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:nil];
    
   
    //[[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //[self.navigationController.navigationBar setBackgroundImage:nilforBarPosition:UIBarPositionAnybarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //self.navigationController.navigationBar.clipsToBounds = YES;
    //去除导航栏半透膜
//    [self useMethodToFindBlackLineAndHind];
//    [self findHairlineImageViewUnder:[[UIView alloc] init]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(14, 123, 235) ;
    
}
//设置导航栏样式
-(void)setNavigationItem{
    //[self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(201,201,206)];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    //导航栏的返回按钮只保留那个箭头，去掉后边的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = item;
}
-(void)initial{
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.showsCancelButton = NO;
    _searchBar.tintColor = [UIColor orangeColor];
    _searchBar.placeholder = @"搜索感兴趣的内容";
    
    for (UIView *subView in _searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                UITextField *textField = [subView.subviews objectAtIndex:0];
                textField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                
                //设置输入框边框的颜色
                //                    textField.layer.borderColor = [UIColor blackColor].CGColor;
                //                    textField.layer.borderWidth = 1;
                
                //设置输入字体颜色
                //                    textField.textColor = [UIColor lightGrayColor];
                
                //设置默认文字颜色
                UIColor *color = [UIColor grayColor];
                [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"搜索感兴趣的内容"
                                                                                    attributes:@{NSForegroundColorAttributeName:color}]];
                //修改默认的放大镜图片
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.image = [UIImage imageNamed:@"gww_search_ misplaces"];
                textField.leftView = imageView;
            }
        }
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始编辑");
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束编辑");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [self InitializeData];
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
    
}
#pragma mack - 网络请求
- (void)InitializeData{
    page =1;
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
    NSDictionary *prarmeter = @{@"hotel_name":_searchBar.text,@"inTime":[NSString stringWithFormat:@"2017-%@",_inDate],@"outTime":[NSString stringWithFormat:@"2017-%@",_outDate]};
    //开始请求
    [RequestAPI requestURL:@"/selectHotel" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        UIRefreshControl *ref = (UIRefreshControl *)[_HotelTableView viewWithTag:10001];
        [ref endRefreshing];
        [_avi stopAnimating];
        NSLog(@"%@",_SearcArr);
        
        //成功以后要做的事情
        NSLog(@"responseObject = %@",responseObject);
        //       [self endAnimation];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            if (page == 1) {
                //清空数据
                [_SearcArr removeAllObjects];
            }
            for(NSDictionary *dict in content){
                detailModel * detailmodel = [[detailModel alloc]initWhitDictionary:dict];
                [_SearcArr addObject:detailmodel];
            }
            //[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"SearcHome" object:_SearcArr] waitUntilDone:YES];
            //[self.navigationController popViewControllerAnimated:YES];
            
            //NSString *business_id
            //业务逻辑成功的情况下
           

            [_HotelTableView reloadData];
            if (_SearcArr.count == 0) {
                [self nothingForTableView];
            }else{
                _Img.hidden = YES;
                _HotelTableView.scrollEnabled = YES;
            }
        }else{
            [Utilities popUpAlertViewWithMsg:@"没有找到你需要的酒店" andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        UIRefreshControl *ref = (UIRefreshControl *)[_HotelTableView viewWithTag:10001];
        [ref endRefreshing];
        [_avi stopAnimating];

    [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
    
    
}

#pragma mack - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return _SearcArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell1" forIndexPath:indexPath];
        detailModel *detailmodel = _SearcArr[indexPath.row];
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
        NSString *str = [self distanceBetweenOrderBy:_location.coordinate.latitude :[detailmodel.latitude doubleValue]:_location.coordinate.longitude :[detailmodel.longitude doubleValue]];
        cell.distanceLabel.text = str;
        cell.priceLabel.text =[NSString stringWithFormat:@"%ld",(long)detailmodel.price];
        return cell;
}

//点击细胞事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        HotelOrdelViewController *purchaseVC = [Utilities getStoryboardInstance:@"Order" byIdentity:@"ordelDetail"];
        detailModel *detail = _SearcArr [indexPath.row];
        //NSLog(@"zhebian:%ld",(long)detail.hotelID);
        purchaseVC.hotelID = detail.hotelID;
        [self.navigationController pushViewController:purchaseVC animated:YES];
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

- (void)nothingForTableView{
    
    _Img = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"no_things" ]];
    _Img.frame = CGRectMake((UI_SCREEN_W-100)/2, 100, 100, 100);
    
    
    [_HotelTableView addSubview:_Img];
    _HotelTableView.scrollEnabled = NO;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
