//
//  MyAirViewController.m
//  GetHotelsEasy
//
//  Created by admin7 on 2017/8/20.
//  Copyright © 2017年 self. All rights reserved.
//

#import "MyAirViewController.h"
#import "HMSegmentedControl.h"

@interface MyAirViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *overDealTableView;
@property (weak, nonatomic) IBOutlet UITableView *issuingTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;

@end

@implementation MyAirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
//设置导航栏样式
-(void)setNavigationItem{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 128, 255)];
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

@end
