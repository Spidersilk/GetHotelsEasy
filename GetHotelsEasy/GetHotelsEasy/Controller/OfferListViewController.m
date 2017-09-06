//
//  OfferListViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 self. All rights reserved.
//

#import "OfferListViewController.h"
#import "OfferTableViewCell.h"
#import "OfferListModel.h"

@interface OfferListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic) NSArray *arr;

@end

@implementation OfferListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _offerTableView.tableFooterView = [UITableView new];
    NSDictionary *dictA = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"546",@"oTime":@"5:40 ——7:30",@"oType":@"经济舱",@"flight":@"深圳航空HX482"};
    NSDictionary *dictB = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"750",@"oTime":@"5:40 ——7:30",@"oType":@"商务舱",@"flight":@"深圳航空HX482"};
    NSDictionary *dictC = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"830",@"oTime":@"5:40 ——7:30",@"oType":@"头等舱",@"flight":@"深圳航空HX482"};
    NSDictionary *dictD = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"546",@"oTime":@"5:20 ——7:10",@"oType":@"经济舱",@"flight":@"深圳航空HZ482"};
    NSDictionary *dictE = @{@"oRoute":@"8-15 广州—无锡 机票",@"oPrice":@"900",@"oTime":@"5:20 ——7:10",@"oType":@"头等舱",@"flight":@"深圳航空HZ482"};
    _arr = @[dictA,dictB,dictC,dictD,dictE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}
//每个细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    cell.backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    cell.backView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.backView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    cell.backView.layer.shadowRadius = 4;//阴影半径，默认3
    return cell;
}
//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
@end
