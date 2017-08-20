//
//  MyInfoViewController.m
//  GetHotelsEasy
//
//  Created by admin7 on 2017/8/19.
//  Copyright © 2017年 self. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"

@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *heardImageView;
@property (weak, nonatomic) IBOutlet UILabel *cName;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UITableView *myInfoTableView;
@property (strong,nonatomic) NSArray *myInfoArr;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myInfoArr = @[@{@"lefticon":@"酒店",@"title":@"我的酒店"},@{@"lefticon":@"航空",@"title":@"我的航空"},@{@"lefticon":@"信息",@"title":@"我的消息"},@{@"lefticon":@"设置",@"title":@"账户设置"},@{@"lefticon":@"协议",@"title":@"使用协议"},@{@"lefticon":@"电话",@"title":@"联系客服"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
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
#pragma mark - table view
//细胞有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}

//每组细胞多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  3;
}
//细胞长啥样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    cell.lefticon.image = [UIImage imageNamed:dict[@"lefticon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }else{
        return 1.f;
    }
}
//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"myInfoToMyHotel"sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"myInfoToMyAir"sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"myInfoToMyNews"sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"myInfoToAccountSettings"sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"myInfoToUseAgreement"sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"myInfoToContactCustomerService"sender:self];
            break;
        default:
            break;
    }
}


@end
