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
//#import "MyAirModel.h"

@interface MyAirViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *overDealTableView;
@property (weak, nonatomic) IBOutlet UITableView *issuingTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (strong, nonatomic)NSArray *arr;
@property (weak, nonatomic) IBOutlet UIView *backView;

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
    NSDictionary *dictA = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"546",@"oTime":@"5:40 ——7:30",@"oType":@"经济舱",};
    NSDictionary *dictB = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"750",@"oTime":@"5:40 ——7:30",@"oType":@"商务舱",};
    NSDictionary *dictC = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"830",@"oTime":@"5:40 ——7:30",@"oType":@"头等舱"};
    NSDictionary *dictD = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"546",@"oTime":@"5:20 ——7:10",@"oType":@"经济舱"};
    NSDictionary *dictE = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"900",@"oTime":@"5:20 ——7:10",@"oType":@"头等舱"};
    _arr =@[dictA,dictB,dictC,dictD,dictE];
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
    _segmentedControl.frame = CGRectMake(0, 0, UI_SCREEN_W, 40);
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
    
    [_backView addSubview:_segmentedControl];
}
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
    
    return page;
}

#pragma mark - tableView
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _overDealTableView) {
        return _arr.count;
    }else if (tableView == _issuingTableView) {
        return _arr.count;
    }else{
        return _arr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _overDealTableView) {
        OverDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"overDealCell" forIndexPath:indexPath];
        NSDictionary *dict = _arr[indexPath.row];
        cell.routeLabel.text =dict[@"oRoute"];
        cell.timeLabel.text =dict[@"oTime"];
        cell.priceLabel.text =dict[@"oprice"];
        cell.typeLabel.text =dict[@"oType"];
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
    return 150.f;
}
//设置每一组每一行的细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前tableview是否为_activityTableView（这个条件判断常用在一个界面中有多个tableView的时候）
    if([tableView isEqual:_issuingTableView]){
        //取消选中
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
//设置组的头部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
@end
