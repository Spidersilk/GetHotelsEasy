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

@interface MyHotelViewController ()<UIScrollViewDelegate/*UITableViewDataSource,UITableViewDelegate*/>{
    NSInteger workableFlag;
    NSInteger expiredFlag;
}
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *allOrdersTableView;
@property (weak, nonatomic) IBOutlet UITableView *workableTableView;
@property (weak, nonatomic) IBOutlet UITableView *expiredTableView;
@property (strong,nonatomic) NSMutableArray *allOrdersArr;
@property (strong,nonatomic) NSMutableArray *workableArr;
@property (strong,nonatomic) NSMutableArray *expiredArr;

@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    workableFlag = 1;
    expiredFlag = 1;
    
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
    }
    if (workableFlag == 1 && page == 1) {
        workableFlag = 0;
        NSLog(@"第一次滑动scollview来到可使用");
    }
    if (expiredFlag == 1 && page == 2) {
        expiredFlag = 0;
        NSLog(@"第一次滑动scollview来到已过期");
    }
    
    return page;
}

//设置导航栏样式
-(void)setNavigationItem{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 128, 255)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //实例化一个button
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置button的位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
//自定义的返回按钮的事件
-(void)leftButtonAction:(UIButton *)sender{
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
//        cell.roomLable.text = @"希尔顿套房";
//        cell.typeLable.text = @"一人入住";
//        cell.inTimeLable.text = @"2017-2-23";
//        cell.outTimeLabel.text = @"2017-2-25";
        return cell;
    }else if(tableView == _workableTableView){
        WorkableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workableCell" forIndexPath:indexPath];
        return cell;
    }else{
        ExpiredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expiredCell" forIndexPath:indexPath];
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
//设置当一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
