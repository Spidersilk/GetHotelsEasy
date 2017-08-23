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
@interface HotelViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mack - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];

    return cell;
}
//点击细胞事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   

    
}
//当某一个页面跳转行为将要发生的时候
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"HotelToOrder"]) {
        //当列表页到详情页的这个跳转要发生的时候
        //1.获取要传递到下一页的数据
//        NSIndexPath *indexPath = [_activityTableView indexPathForSelectedRow];
//        ActivityModel *activity = _arr[indexPath.row];
        //2.获取下一页的实例
        HotelOrdelViewController *detailVC = segue.destinationViewController;
        //3.把数据给下一页预备好的接收容器
        //detailVC.activity = activity;
    }
}

@end
