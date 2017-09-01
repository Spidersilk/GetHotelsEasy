//
//  PurchaseTableViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 self. All rights reserved.
//

#import "PurchaseTableViewController.h"

@interface PurchaseTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *outDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) UIButton *apply;
@property (strong, nonatomic) NSArray *arr;
@property (weak, nonatomic) IBOutlet UIView *applyView;
@end

@implementation PurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];
    [self dataInitialize];
    [self setFootViewForTableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
    [_apply addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    //_apply.frame = CGRectMake(UI_SCREEN_W / 2, UI_SCREEN_H - 300 - _applyView.frame.size.height, 90, 60);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    self.navigationItem.title = @"支付";
}
-(void)setFootViewForTableView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 45)];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(0, 5, UI_SCREEN_W, 60.f);
    [exitBtn setTitle:@"确定支付" forState:UIControlStateNormal];
    exitBtn.backgroundColor = [UIColor whiteColor];
    //设置按钮标题字体的大小
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [exitBtn setTitleColor:UIColorFromRGB(0, 128.f, 255.f) forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:exitBtn];
    [self.tableView setTableFooterView:view];
}
- (void)uiLayout{
    _hotelNameLabel.text = _detail.hotel_name;
    _priceLabel.text = [NSString stringWithFormat:@"%ld元",(long)_detail.price];
    _inDateLabel.text = [[StorageMgr singletonStorageMgr] objectForKey:@"first" ];
    _outDateLabel.text = [[StorageMgr singletonStorageMgr] objectForKey:@"second"];
    //NSString *dueTimeStr = [Utilities dateStrFromCstampTime:_detail.start_time withDateFormat:@"MM-dd"];
   // NSString *startTimeStr = [Utilities dateStrFromCstampTime:_detail.out_time withDateFormat:@"MM-dd"];
    //_inDateLabel.text = [NSString stringWithFormat:@"%@", dueTimeStr];
   // _outDateLabel.text = [NSString stringWithFormat:@"%@", startTimeStr];;
    self.tableView.tableFooterView = [UIView new];
    //将表格视图设置为“编辑”
    self.tableView.editing = YES;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码表格视图中的某个cell
    [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
}
- (void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:{
            NSString *tradeNo = [GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_detail.hotel_name amount:[NSString stringWithFormat:@"%ld元",(long)_detail.price] tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@价钱",_detail.hotel_name]  itBPay:@"30"];
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}
//设置每一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //遍历表格视图中选中状态下的cell
    for(NSIndexPath *eachIP in tableView.indexPathsForSelectedRows){
        //当选中的cell不是当前正在按得时候
        if(eachIP != indexPath)
            //取消cell选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
    }
}
- (void)dataInitialize{
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
//设置组的头标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"支付方式";
}
- (void)purchaseResultAction:(NSNotification *)not{
    NSString *result = not.object;
    if([result isEqualToString:@"9000"]){
        //成功
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜您，您成功完成报名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:^{
            
        }];
    }else{
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能成功支付，请保证账户余额充足" : @"您已取消支付" andTitle:@"支付失败" onView:self];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
