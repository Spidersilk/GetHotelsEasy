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
@property (strong, nonatomic) NSArray *arr;
@end

@implementation PurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];
    [self dataInitialize];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    self.navigationItem.title = @"支付";
}

- (void)uiLayout{
    _hotelNameLabel.text = _detail.hotel_name;
    _priceLabel.text = [NSString stringWithFormat:@"%ld元",(long)_detail.price];
    self.tableView.tableFooterView = [UIView new];
    //将表格视图设置为“编辑”
    self.tableView.editing = YES;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码表格视图中的某个cell
    [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
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
