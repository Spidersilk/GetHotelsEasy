//
//  ContactCustomerServiceViewController.m
//  GetHotelsEasy
//
//  Created by admin7 on 2017/8/20.
//  Copyright © 2017年 self. All rights reserved.
//

#import "ContactCustomerServiceViewController.h"
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ContactCustomerServiceViewController ()<MFMailComposeViewControllerDelegate>
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mailAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) MFMailComposeViewController *mailVC;
@end

@implementation ContactCustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //调用设置导航栏的方法
    [self setNavigationItem];
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

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *phoneStr = @"15170029037";
    //配置“电话”app的路径，并将要拨打的号码组合到路径中去
    NSString *targetAppStr = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
    NSLog(@"%@",targetAppStr);
    //将字符串转化成URL
    NSURL *targetAppUrl = [NSURL URLWithString:targetAppStr];
    
    //从当前app跳转到其他指定的APP中(先拿到APP实例)
    [[UIApplication sharedApplication] openURL:targetAppUrl];
}

- (IBAction)mailAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *email = @"1228205445@qq.com";
    NSLog(@"email = %@", email);
    //神奇的nil
    _mailVC = nil;
    //初始化一个邮件发送器
    _mailVC = [[MFMailComposeViewController alloc] init];
    //签协议
    _mailVC.mailComposeDelegate = self;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    //讲邮件发送器显示出来
    if (_mailVC) {
        //用modal的方式跳转页面
        [self presentViewController:_mailVC animated:YES completion:nil];
    }
}
@end
