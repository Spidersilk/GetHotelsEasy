//
//  OfferDetailViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 self. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "OfferTableViewCell.h"

@interface OfferDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
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

    return cell;
}

- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
