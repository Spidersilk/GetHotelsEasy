//
//  MyAirViewController.m
//  GetHotelsEasy
//
//  Created by admin7 on 2017/8/20.
//  Copyright © 2017年 self. All rights reserved.
//

#import "MyAirViewController.h"
#import "HMSegmentedControl.h"
#import "OverDealTableViewCell.h"
#import "IssuingTableViewCell.h"
#import "HistoryTableViewCell.h"
#import "OfferDetailViewController.h"
#import "MyInfoModel.h"
#import "MyAirModel.h"

@interface MyAirViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
    NSInteger issuingFlag;
    NSInteger historyFlag;
    NSInteger overDealPageNum;
    BOOL overDaelLastPage;
    NSInteger issuingPageNum;
    BOOL issuingLastpage;
    NSInteger historyPageNum;
    BOOL historyLastPage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *overDealTableView;
@property (weak, nonatomic) IBOutlet UITableView *issuingTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) NSMutableArray *overDealArr;
@property (strong, nonatomic) NSMutableArray *issuingArr;
@property (strong, nonatomic) NSMutableArray *historyArr;
@property (strong, nonatomic) UIImageView *overDealNothingImg;
@property (strong, nonatomic) UIImageView *issuingNothingImg;
@property (strong, nonatomic) UIImageView *historyNothingImg;


@end

@implementation MyAirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    issuingFlag = 1;
    historyFlag = 1;
    
    overDealPageNum=1;
    issuingPageNum = 1;
    historyPageNum = 1;
    
    _overDealArr = [NSMutableArray new];
    _issuingArr = [NSMutableArray new];
    _historyArr = [NSMutableArray new];
    //去掉tableview底部多余的线
    _overDealTableView.tableFooterView = [UIView new];
    _issuingTableView.tableFooterView = [UIView new];
    _historyTableView.tableFooterView = [UIView new];
    
    //调用当TableView没有数据显示时，显示图片的方法
    if (_overDealArr.count == 0) {
        [self nothingForTableView];
    }else if (_issuingArr.count == 0){
        [self nothingForTableView];
    }else{
        [self nothingForTableView];
    }
    
    //调用设置导航栏的方法
    [self setNavigationItem];

    [self setSegment];

    //下拉刷新
    [self setReareshControl];
    //以获取任务的网络请求，带蒙层
    [self overDealInitializeData];
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
//初始化菜单栏的方法
- (void)setSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已成交",@"正在发布",@"历史发布"]];
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

//当TableView没有数据显示时，显示图片
-(void)nothingForTableView{
    _overDealNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noOrder"]];
    _overDealNothingImg.frame = CGRectMake((UI_SCREEN_W - 150) / 2, 50, 150, 100);
    
    _issuingNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noOrder"]];
    _issuingNothingImg.frame = CGRectMake((UI_SCREEN_W - 150) / 2 + UI_SCREEN_W, 50, 150, 100);
    
    _historyNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noOrder"]];
    _historyNothingImg.frame = CGRectMake((UI_SCREEN_W - 150) / 2 + UI_SCREEN_W * 2, 50, 150, 100);
    
    [_scrollView addSubview:_overDealNothingImg];
    [_scrollView addSubview:_overDealNothingImg];
    [_scrollView addSubview:_historyNothingImg];
}
#pragma mark -reareshControl

-(void) setReareshControl{
    //初始化一个下拉刷新控件
    UIRefreshControl *overDealRef = [UIRefreshControl new];
    overDealRef.tag = 10001;
    //定义用户触发下拉事件时执行的方法
    [overDealRef addTarget:self action:@selector(overDealRef) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到acquireTableView中,(在tableview中，下拉刷新控件会自动放置在表格视图顶部后侧位置）
    [_overDealTableView addSubview:overDealRef];
    
    UIRefreshControl *issuingRef = [UIRefreshControl new];
    issuingRef.tag = 10002;
    [issuingRef addTarget:self action:@selector(issuingRef) forControlEvents:UIControlEventValueChanged];
    [_issuingTableView addSubview:issuingRef];
    
    UIRefreshControl *historyRef = [UIRefreshControl new];
    historyRef.tag = 10003;
    [historyRef addTarget:self action:@selector(historyRef) forControlEvents:UIControlEventValueChanged];
    [_historyTableView addSubview:historyRef];
}
//下拉刷新事件
-(void)overDealRef{
    //allOrdersPageNum = 1;
    [self overDealRequest];
}
-(void)issuingRef{
    issuingPageNum = 1;
    [self issuingRequest];
}

-(void)historyRef{
    historyPageNum = 1;
    [self HistoryRequest];
}
//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
-(void)overDealInitializeData{
    //创建一个蒙层，并显示在当前页面
    _avi =[Utilities getCoverOnView:self.view];
    [self overDealRequest];
}
//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
-(void)issuingInitializeData{
    //创建一个蒙层，并显示在当前页面
    _avi =[Utilities getCoverOnView:self.view];
    [self issuingRequest];
}
//第一次进行网络请求的时候需要盖上蒙层，而下拉刷新的时候不需要蒙层，所以我们把第一次网络请求和下拉刷新分开来
-(void)historyInitializeData{
    //创建一个蒙层，并显示在当前页面
    _avi =[Utilities getCoverOnView:self.view];
    [self HistoryRequest];
}


#pragma mark - scollView
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
        [self overDealRequest];
    }
    if (issuingFlag == 1 && page == 1) {
        issuingFlag = 0;
        NSLog(@"第一次滑动scollview来到正在发布");
        [self issuingInitializeData];
    }
    if (historyFlag == 1 && page == 2) {
        historyFlag = 0;
        NSLog(@"第一次滑动scollview来到历史发布");
        [self historyInitializeData];
    }
    return page;
}
#pragma mark - Request
//已成交的网络请求
- (void) overDealRequest {
     MyInfoModel *myinfo = [[StorageMgr singletonStorageMgr] objectForKey:@"MemberInfo"];
    //参数
    NSDictionary *para = @{@"openid" :myinfo.openid,@"pageNum" :@(overDealPageNum) ,@"pageSize":@10,@"state":@0};
    //网络请求
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"overDealRequest哈哈:%@",responseObject);
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *result = responseObject[@"content"];
            NSArray *list = result[@"list"];
            overDaelLastPage = [result[@"isLastPage"] boolValue];
            for (NSDictionary *dict in list) {
                MyAirModel *airmodel = [[MyAirModel alloc]initWithDict:dict];
                [_overDealArr addObject:airmodel];
            }
            //当数组没有数据显示时，将图片显示，反之隐藏
            if (_overDealArr.count == 0) {
                _overDealNothingImg.hidden = NO;
            }else{
                _overDealNothingImg.hidden = YES;
            }
            [_overDealTableView reloadData];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
            [_avi stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
//正在发布的网络请求
- (void) issuingRequest {
    MyInfoModel *myinfo = [[StorageMgr singletonStorageMgr] objectForKey:@"MemberInfo"];
    //参数
    NSDictionary *para = @{@"openid" :myinfo.openid,@"pageNum" :@(issuingPageNum) ,@"pageSize":@10,@"state":@1};
    //网络请求
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"issuingRequest哈哈:%@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_issuingTableView viewWithTag:10002];
        [ref endRefreshing];
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *result = responseObject[@"content"];
            NSArray *list = result[@"list"];
            issuingLastpage = [result[@"isLastPage"] boolValue];
            //当页码为1的时候让数据先清空，再重新添加
            if (issuingPageNum == 1) {
                [_issuingArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                MyAirModel *airmodel = [[MyAirModel alloc]initWithDictForIssuing:dict];
                [_issuingArr addObject:airmodel];
            }
            //当数组没有数据显示时，将图片显示，反之隐藏
            if (_issuingArr.count == 0) {
                _overDealNothingImg.hidden = NO;
            }else{
                _overDealNothingImg.hidden = YES;
            }
            
            [_issuingTableView reloadData];
            
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_issuingTableView viewWithTag:10002];
        [ref endRefreshing];

        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
//历史发布的网络请求
- (void) HistoryRequest {
     MyInfoModel *myinfo = [[StorageMgr singletonStorageMgr] objectForKey:@"MemberInfo"];    
    //参数
    NSDictionary *para = @{@"openid" :myinfo.openid,@"pageNum" :@(historyPageNum) ,@"pageSize":@10,@"state":@2};
    //网络请求
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"HistoryRequest哈哈:%@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_historyTableView viewWithTag:10003];
        [ref endRefreshing];
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *result = responseObject[@"content"];
            //NSArray *list = result[@"list"];
            historyLastPage = [result[@"isLastPage"] boolValue];
            //当页码为1的时候让数据先清空，再重新添加
            if (historyPageNum == 1) {
                [_historyArr removeAllObjects];
            }

            //当数组没有数据显示时，将图片显示，反之隐藏
            if (_historyArr.count == 0) {
                _historyNothingImg.hidden = NO;
            }else{
                _historyNothingImg.hidden = YES;
            }
            [_historyTableView reloadData];
            
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        UIRefreshControl *ref = (UIRefreshControl *)[_historyTableView viewWithTag:10003];
        [ref endRefreshing];
        [_avi stopAnimating];
        
    }];
    
}



#pragma mark - tableView
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _overDealTableView) {
        return _overDealArr.count;
    }else if (tableView == _issuingTableView) {
        return _issuingArr.count;
    }else{
        return _historyArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _overDealTableView) {
        OverDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"overDealCell" forIndexPath:indexPath];
        //MyAirModel *overDeal = _overDealArr[indexPath.section];
        return cell;
    }else if (tableView == _issuingTableView){
        IssuingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssuingCell" forIndexPath:indexPath];
        MyAirModel *issuing = _issuingArr[indexPath.section];
        
        NSString *str = [NSString stringWithFormat:@"%@ %@ 机票",issuing.start_time_str,issuing.route];
        
        cell.iRouteLabel.text = str;
        //NSLog(@"cell.iRouteLabel.text = %@",issuing.route);
        cell.iPriceLabel.text = [NSString stringWithFormat:@"价格区间：%@-%@",issuing.lowPrice,issuing.highPrice];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:issuing.start_time/1000];
//        NSLog(@"hahaha%f",issuing.start_time);
//        NSLog(@"hahaha%@",issuing.lowPrice);
        //初始化一个日期格式器
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //定义日期的格式为yyyy-MM-dd
        formatter.dateFormat = @"HH";
        NSString *date = [formatter stringFromDate:confromTimesp];
        NSInteger i = [date intValue];
        if (i <= 12 && i>=0) {
            cell.iTimeLabel.text = [NSString stringWithFormat:@"大约上午%ld点",(long)i];
        }else{
            i = i - 12;
            cell.iTimeLabel.text = [NSString stringWithFormat:@"大约下午%ld点",(long)i];
        }
        cell.iTypeLabel.text = issuing.demand;
        //NSLog(@"i = %ld",(long)i);
        return cell;
    }else{
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
        return cell;
    }
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}
//设置每一组每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断当前tableview是否为_activityTableView（这个条件判断常用在一个界面中有多个tableView的时候）
    if([tableView isEqual:_issuingTableView]){
        OfferDetailViewController *offervc = [Utilities getStoryboardInstance:@"MyInfo" byIdentity:@"offerDetail"];
        //[self.navigationController pushViewController:offervc animated:YES];
        //根据当前点击的组号拿到对应的model
        MyAirModel *AirModel = _issuingArr[indexPath.section];
        //通过performSegueWithIdentifier根据箭头的名字调转页面，sender可以将需要的任意类型的参数传递到目标页面
        offervc.AirModel = AirModel;
        [self.navigationController pushViewController:offervc animated:YES];
        //[self performSegueWithIdentifier:@"taskToDetail" sender:nil];
    }
}
//设置组的头部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
//设置当一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _overDealTableView) {
        //判断是否是最后一行细胞将要出现
        if (indexPath.section == _overDealArr.count - 1) {
            //判断还有没有下一页
            if (!overDaelLastPage) {
                //在这里执行上拉翻页的数据操作
                overDealPageNum++;
                [self overDealRequest];
            }
        }
        
    }else if (tableView == _issuingTableView){
        //判断是否是最后一行细胞将要出现
        if (indexPath.section == _issuingArr.count - 1) {
            //判断还有没有下一页
            if (!issuingLastpage) {
                //在这里执行上拉翻页的数据操作
                issuingPageNum++;
                [self issuingRequest];
            }
        }
    }else{
        //判断是否是最后一行细胞将要出现
        if (indexPath.section == _historyArr.count - 1) {
            //判断还有没有下一页
            if (!historyLastPage) {
                //在这里执行上拉翻页的数据操作
                historyPageNum++;
                [self HistoryRequest];
            }
        }
    }
}
@end
