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

@interface MyAirViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *overDealTableView;
@property (weak, nonatomic) IBOutlet UITableView *issuingTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *iRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *iTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *iTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *hPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hTypeLabel;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;

@end

@implementation MyAirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //调用设置导航栏的方法
    [self setNavigationItem];
    [self setSegment];
    
    //去掉tableview底部多余的线
    _overDealTableView.tableFooterView = [UIView new];
    _issuingTableView.tableFooterView = [UIView new];
    _historyTableView.tableFooterView = [UIView new];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - setSegment设置菜单栏

//初始化菜单栏的方法
- (void)setSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已成交",@"正在发布",@"历史发布"]];
    //设置位置
    _segmentedControl.frame = CGRectMake(0, 60, UI_SCREEN_W, 50);
    //设置默认选中的项
    _segmentedControl.selectedSegmentIndex = 0;
    //设置菜单栏的背景色
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    //设置线的高度
    _segmentedControl.selectionIndicatorHeight = 2.5f;
    //设置选中状态的样式
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
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

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _overDealTableView) {
        OverDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"overDealCell" forIndexPath:indexPath];
        return cell;
    }else if (tableView == _issuingTableView){
        IssuingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssuingCell" forIndexPath:indexPath];
        return cell;
    }else{
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
        return cell;
    }
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.f;
}
//设置每一组每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前tableview是否为_activityTableView（这个条件判断常用在一个界面中有多个tableView的时候）
    if([tableView isEqual:_issuingTableView]){
        //取消选中
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
@end
