//
//  MyHotelViewController.m
//  GetHotelsEasy
//
//  Created by admin7 on 2017/8/19.
//  Copyright © 2017年 self. All rights reserved.
//

#import "MyHotelViewController.h"
#import "HMSegmentedControl.h"
#import "AllOrdersTableViewCell.h"
#import "WorkableTableViewCell.h"
#import "ExpiredTableViewCell.h"
#import "MyInfoModel.h"

@interface MyHotelViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSInteger workableFlag;
    NSInteger expiredFlag;
    NSInteger allOrdersPageNum;
    BOOL allOrdersLastPage;
    NSInteger workablePageNum;
    BOOL workableLastpage;
    NSInteger expiredPageNum;
    BOOL expiredLastPage;
    NSInteger pageSize;
    
}
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *allOrdersTableView;
@property (weak, nonatomic) IBOutlet UITableView *workableTableView;
@property (weak, nonatomic) IBOutlet UITableView *expiredTableView;
@property (strong,nonatomic) NSMutableArray *allOrdersArr;
@property (strong,nonatomic) NSMutableArray *workableArr;
@property (strong,nonatomic) NSMutableArray *expiredArr;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) UIImageView *allOrdersNothingImg;
@property (strong, nonatomic) UIImageView *workableNothingImg;
@property (strong, nonatomic) UIImageView *expiredNothingImg;

@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    workableFlag = 1;
    expiredFlag = 1;
    
    allOrdersPageNum=1;
    workablePageNum = 1;
    expiredPageNum = 1;
    pageSize = 10;
    
    _allOrdersArr = [NSMutableArray new];
    _workableArr = [NSMutableArray new];
    _expiredArr = [NSMutableArray new];
    
    //去掉tableview底部多余的线
    _allOrdersTableView.tableFooterView = [UIView new];
    _workableTableView.tableFooterView = [UIView new];
    _expiredTableView.tableFooterView = [UIView new];
    
    //调用设置导航栏的方法
    [self setNavigationItem];
    [self setSegment];
    //调用当TableView没有数据显示时，显示图片的方法
    if (_allOrdersArr.count == 0) {
        [self nothingForTableView];
    }else if (_workableArr.count == 0){
        [self nothingForTableView];
    }else{
        [self nothingForTableView];
    }
    //下拉刷新
    [self setReareshControl];
    //以获取任务的网络请求，带蒙层
    [self allOrdersInitializeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，显示导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
#pragma mark - setSegment设置菜单栏

//初始化菜单栏的方法
- (void)setSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部订单",@"可使用",@"已过期"]];
    //设置位置
    _segmentedControl.frame = CGRectMake(0, 64, UI_SCREEN_W, 50);
    //设置默认选中的项
    _segmentedControl.selectedSegmentIndex = 0;
    //设置菜单栏的背景色
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    //设置线的高度
    _segmentedControl.selectionIndicatorHeight = 2.5f;
    //设置选中状态的样式
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //选中时的标记的位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题样式
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(230, 230, 230, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    //选中时的标题样式
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(154, 154, 154, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W, 200) animated:YES];
    }];
    
    [self.view addSubview:_segmentedControl];
}
#pragma mark - scrollView

//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSInteger page = [self scrollCheck:scrollView];
        //NSLog(@"page = %ld", (long)page);
        //将_segmentedControl设置选中的index为page（scrollView当前显示的tableview）
        [_segmentedControl setSelectedSegmentIndex:page animated:YES];
    }
}
//scrollView已经结束滑动的动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        [self scrollCheck:scrollView];
    }
}
//判断scrollView滑动到那里了
- (NSInteger)scrollCheck: (UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / (scrollView.frame.size.width);
    if (page == 0) {
        [self allOrdersRequest];
    }
    if (workableFlag == 1 && page == 1) {
        workableFlag = 0;
        NSLog(@"第一次滑动scollview来到可使用");
        [self workableInitializeData];
    }
    if (expiredFlag == 1 && page == 2) {
        expiredFlag = 0;
        NSLog(@"第一次滑动scollview来到已过期");
        [self expiredInitializeData];
    }
    
    return page;
}
//当TableView没有数据显示时，显示图片
-(void)nothingForTableView{
    _allOrdersNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noOrder"]];
    _allOrdersNothingImg.frame = CGRectMake((UI_SCREEN_W - 150) / 2, 50, 150, 100);
    
    _workableNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noOrder"]];
    _workableNothingImg.frame = CGRectMake((UI_SCREEN_W - 150) / 2 + UI_SCREEN_W, 50, 150, 100);
    
    _expiredNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noOrder"]];
    _expiredNothingImg.frame = CGRectMake((UI_SCREEN_W - 150) / 2 + UI_SCREEN_W * 2, 50, 150, 100);
    
    [_scrollView addSubview:_allOrdersNothingImg];
    [_scrollView addSubview:_workableNothingImg];
    [_scrollView addSubview:_expiredNothingImg];
}
#pragma mark -reareshControl

-(void) setReareshControl{
    //初始化一个下拉刷新控件
    UIRefreshControl *allOrdersRef = [UIRefreshControl new];
    allOrdersRef.tag = 10001;
    //定义用户触发下拉事件时执行的方法
    [allOrdersRef addTarget:self action:@selector(allOrdersRef) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到acquireTableView中,(在tableview中，下拉刷新控件会自动放置在表格视图顶部后侧位置）
    [_allOrdersTableView addSubview:allOrdersRef];
    
    UIRefreshControl *workableRef = [UIRefreshControl new];
    workableRef.tag = 10002;
    [workableRef addTarget:self action:@selector(workableRef) forControlEvents:UIControlEventValueChanged];
    [_workableTableView addSubview:workableRef];
    
    UIRefreshControl *expiredRef = [UIRefreshControl new];
    expiredRef.tag = 10003;
    [expiredRef addTarget:self action:@selector(expiredRef) forControlEvents:UIControlEventValueChanged];
    [_expiredTableView addSubview:expiredRef];
}
//下拉刷新事件
-(void)allOrdersRef{
    allOrdersPageNum = 1;
    [self allOrdersRequest];
}
-(void)workableRef{
    workablePageNum = 1;
    [self workableRequest];
}

-(void)expiredRef{
    expiredPageNum = 1;
    [self expiredRequest];
}
//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
-(void)allOrdersInitializeData{
    //创建一个蒙层，并显示在当前页面
    _avi =[Utilities getCoverOnView:self.view];
    [self allOrdersRequest];
}
//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
-(void)workableInitializeData{
    //创建一个蒙层，并显示在当前页面
    _avi =[Utilities getCoverOnView:self.view];
    [self workableRequest];
}
//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
-(void)expiredInitializeData{
    //创建一个蒙层，并显示在当前页面
    _avi =[Utilities getCoverOnView:self.view];
    [self expiredRequest];
}

//设置导航栏样式
-(void)setNavigationItem{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 128, 255)];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    //导航栏的返回按钮只保留那个箭头，去掉后边的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = item;
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
//全部订单的网络请求
-(void)allOrdersRequest{
    MyInfoModel *usermodel = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    NSDictionary *prarmeter = @{@"openid" : usermodel.openid , @"id" : @(1)};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:prarmeter andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_allOrdersTableView viewWithTag:10001];
        [ref endRefreshing];
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            //当页码为1的时候让数据先清空，再重新添加
            if (allOrdersPageNum == 1) {
                [_allOrdersArr removeAllObjects];
            }
            for (NSDictionary *dict in content) {
                MyInfoModel *airmodel = [[MyInfoModel alloc]initWithForAll:dict];
                [_allOrdersArr addObject:airmodel];
            }
            //当数组没有数据显示时，将图片显示，反之隐藏
            if (_allOrdersArr.count == 0) {
                _allOrdersNothingImg.hidden = NO;
            }else{
                _allOrdersNothingImg.hidden = YES;
            }
            [_allOrdersTableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_allOrdersTableView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
    }];
}
//可使用的网络接口
-(void)workableRequest{
    MyInfoModel *usermodel = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    NSDictionary *prarmeter = @{@"openid" : usermodel.openid , @"id" : @(2)};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:prarmeter andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_workableTableView viewWithTag:10002];
        [ref endRefreshing];
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            //当页码为1的时候让数据先清空，再重新添加
            if (workablePageNum == 1) {
                [_workableArr removeAllObjects];
            }
            for (NSDictionary *dict in content) {
                MyInfoModel *workmodel = [[MyInfoModel alloc]initWithDictForWork:dict];
                [_workableArr addObject:workmodel];
            }
            //当数组没有数据显示时，将图片显示，反之隐藏
            if (_workableArr.count == 0) {
                _workableNothingImg.hidden = NO;
            }else{
                _workableNothingImg.hidden = YES;
            }
            [_workableTableView reloadData];
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_workableTableView viewWithTag:10002];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
    }];
}
//已过期的网络接口
-(void)expiredRequest{
    MyInfoModel *usermodel = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    NSDictionary *prarmeter = @{@"openid" : usermodel.openid , @"id" : @(3) };
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:prarmeter andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_expiredTableView viewWithTag:10003];
        [ref endRefreshing];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            //当页码为1的时候让数据先清空，再重新添加
            if (expiredPageNum == 1) {
                [_expiredArr removeAllObjects];
            }
            for (NSDictionary *dict in content) {
                MyInfoModel *expirdemodel = [[MyInfoModel alloc]initWithDictForExpired:dict];
                [_expiredArr addObject:expirdemodel];
            }
            //当数组没有数据显示时，将图片显示，反之隐藏
            if (_expiredArr.count == 0) {
                _expiredNothingImg.hidden = NO;
            }else{
                _expiredNothingImg.hidden = YES;
            }
            [_expiredTableView reloadData];
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_expiredTableView viewWithTag:10003];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
    }];
}

#pragma mark - TableView

//细胞都少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _allOrdersTableView) {
        return _allOrdersArr.count;
    }else if (tableView == _workableTableView){
        return _workableArr.count;
    }else{
        return _expiredArr.count;
    }
}
//细胞长啥样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _allOrdersTableView) {
        AllOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allOrdersCell" forIndexPath:indexPath];
        MyInfoModel *allOrders = _allOrdersArr[indexPath.row];
        if (allOrders.state == 1) {
            cell.hotelImageView.image = [UIImage imageNamed:@"my_hotel"];
            cell.roomLable.textColor = [UIColor grayColor];
        }else{
            cell.hotelImageView.image = [UIImage imageNamed:@"酒店蓝"];
        }
        cell.roomLable.text = allOrders.hotel_name;
        cell.locationLable.text = allOrders.hotel_address;
        cell.typeLable.text = @"一人入住";
        cell.inTimeLable.text = allOrders.final_in_time_str;
        cell.outTimeLabel.text = allOrders.final_out_time_str;
        return cell;
    }else if(tableView == _workableTableView){
        WorkableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workableCell" forIndexPath:indexPath];
        MyInfoModel *workable = _workableArr[indexPath.row];
        cell.roomLable.text = workable.hotel_name;
        cell.locationLable.text = workable.hotel_address;
        cell.typeLable.text = @"一人入住";
        cell.inTimeLable.text = workable.final_in_time_str;
        cell.outTimeLabel.text = workable.final_out_time_str;
        return cell;
    }else{
        ExpiredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expiredCell" forIndexPath:indexPath];
        MyInfoModel *expired = _expiredArr[indexPath.row];
        cell.roomLable.text = expired.hotel_name;
        cell.locationLable.text = expired.hotel_address;
        cell.typeLable.text = @"一人入住";
        cell.inTimeLable.text = expired.final_in_time_str;
        cell.outTimeLabel.text = expired.final_out_time_str;
        return cell;
    }
}

//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
////设置当一个细胞将要出现的时候要做的事情
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == _allOrdersTableView) {
//        //判断是否是最后一行细胞将要出现
//        if (indexPath.section == _allOrdersArr.count - 1) {
//            //判断还有没有下一页
//            if (!allOrdersLastPage) {
//                //在这里执行上拉翻页的数据操作
//                allOrdersPageNum++;
//                [self allOrdersRequest];
//            }
//        }
//        
//    }else if (tableView == _workableTableView){
//        //判断是否是最后一行细胞将要出现
//        if (indexPath.section == _workableArr.count - 1) {
//            //判断还有没有下一页
//            if (!workableLastpage) {
//                //在这里执行上拉翻页的数据操作
//                workablePageNum++;
//                [self workableRequest];
//            }
//        }
//    }else{
//        //判断是否是最后一行细胞将要出现
//        if (indexPath.section == _expiredArr.count - 1) {
//            //判断还有没有下一页
//            if (!expiredLastPage) {
//                //在这里执行上拉翻页的数据操作
//                expiredPageNum++;
//                [self expiredRequest];
//            }
//        }
//    }
//}


@end
