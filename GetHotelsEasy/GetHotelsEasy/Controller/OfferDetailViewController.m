//
//  OfferDetailViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "OfferTableViewCell.h"
#import "OfferListModel.h"

@interface OfferDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger PageNum;
    //BOOL isLastPage;

}
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSMutableArray *detailArr;
@property (strong, nonatomic) UIImageView *detailNothingImg;
@property (strong, nonatomic) UIActivityIndicatorView *avi;;

@end

@implementation OfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    // Do any additional setup after loading the view.
    //去掉tableview底部多余的线
    _offerTableView.tableFooterView = [UIView new];
    PageNum = 1;
    _detailArr = [NSMutableArray new];
    if (_detailArr.count == 0) {
        [self offerTableView];
    }
    [self initializeData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//当TableView没有数据显示时，显示图片
-(void)nothingForTableView{
    _detailNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noOrder"]];
    _detailNothingImg.frame = CGRectMake((UI_SCREEN_W - 150) / 2, 50, 150, 100);
}
-(void) setReareshControl{
    //初始化一个下拉刷新控件
    UIRefreshControl *offerListRef = [UIRefreshControl new];
    offerListRef.tag = 10001;
    //定义用户触发下拉事件时执行的方法
    [offerListRef addTarget:self action:@selector(offerListRef) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到acquireTableView中,(在tableview中，下拉刷新控件会自动放置在表格视图顶部后侧位置）
    [_offerTableView addSubview:offerListRef];
}
-(void)offerListRef{
    PageNum = 1;
    [self Request];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self offerListRef];
}
//正在发布的网络请求
- (void) Request {
    //网络请求
    [RequestAPI requestURL:@"/selectOffer_edu" withParameters:@{@"Id":@(_AirModel.Id)} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"Request哈哈:%@",responseObject);
//        UIRefreshControl *ref = (UIRefreshControl *)[_issuingTableView viewWithTag:10002];
//        [ref endRefreshing];
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];

            //isLastPage = [result[@"isLastPage"] boolValue];
            //当页码为1的时候让数据先清空，再重新添加
            if (PageNum == 1) {
                [_detailArr removeAllObjects];
            }
            for (NSDictionary *dict in content) {
                OfferListModel *offerModel = [[OfferListModel alloc]initWithDict:dict];
                [_detailArr addObject:offerModel];
            }
            //当数组没有数据显示时，将图片显示，反之隐藏
            if (_detailArr.count == 0) {
                _detailNothingImg.hidden = NO;
            }else{
                _detailNothingImg.hidden = YES;
            }
            
            [_offerTableView reloadData];
            
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_offerTableView viewWithTag:10001];
        [ref endRefreshing];
        
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _detailArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    cell.backView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.backView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    cell.backView.layer.shadowRadius = 2;//阴影半径，默认3
    //设置button边框
    cell.payBtn.layer.borderWidth = 1; //边框的宽度
    cell.payBtn.layer.masksToBounds = YES;
    cell.payBtn.layer.cornerRadius = 5;  //设置圆角大小
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){26/255.0,143/255.0,246/255.0,1});
    [cell.payBtn.layer setBorderColor:color];
    //设置细胞
    OfferListModel *offerList = _detailArr[indexPath.section];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:offerList.in_time/1000];
    //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"MM-dd";
    NSString *date = [formatter stringFromDate:confromTimesp];
    NSString *str = [NSString stringWithFormat:@"%@ %@——%@ 机票",date,offerList.departure,offerList.destination];
    cell.oRouteLabel.text = str;
//    //NSLog(@"cell.iRouteLabel.text = %@",issuing.route);
    cell.oPriceLabel.text = [NSString stringWithFormat:@"%@",offerList.final_price];
    //开始时间
    NSDate *confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:offerList.in_time/1000];
    //初始化一个日期格式器
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter1.dateFormat = @"HH-mm";
    NSString *date1 = [formatter stringFromDate:confromTimesp1];
    //结束时间
    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:offerList.out_time/1000];
    //初始化一个日期格式器
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter2.dateFormat = @"HH-mm";
    NSString *date2 = [formatter stringFromDate:confromTimesp2];
    cell.oTimeLabel.text = [NSString stringWithFormat:@"%@——%@",date1,date2];
    cell.flightLabel.text = [NSString stringWithFormat:@"%@ %@",offerList.aviation_company,offerList.flight_no];
    cell.oType.text = offerList.aviation_cabin;
    return cell;
}
//设置每一组每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
@end
