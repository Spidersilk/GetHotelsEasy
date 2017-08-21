//
//  LoginViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *createUserBtn;
- (IBAction)createUserAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //让按钮初始不能点击
    _loginBtn.enabled = NO;
    _loginBtn.backgroundColor =UIColorFromRGB(200, 200, 200);
    //判断有值&&不为空，使用沙盒保存的用户名
    if (![[Utilities getUserDefaults:@"tel"] isKindOfClass:[NSNull class]] && [Utilities getUserDefaults:@"tel"] != nil) {
        _phoneTextField.text = [Utilities getUserDefaults:@"tel"];
    }
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.backView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.backView.layer.shadowRadius = 4;//阴影半径，默认3
    //添加事件监听当输入框的内容改变时调用textChange:方法
    [_phoneTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
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
//输入框内容改变的监听事件
- (void) textChange: (UITextField *)textField {
    //当文本框的内容改变时判断长度是否为0 是:禁用按钮 否:启用按钮
    if (_phoneTextField.text.length != 0 && _pwdTextField.text.length != 0) {
        _loginBtn.enabled = YES;
        _loginBtn.backgroundColor =UIColorFromRGB(99, 163, 210);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    }else{
        _loginBtn.enabled = NO;
        _loginBtn.backgroundColor =UIColorFromRGB(200, 200, 200);
    }
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}
//键盘收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _phoneTextField || textField == _pwdTextField) {
        [textField resignFirstResponder];
    }
    return YES;
    
}
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self request];
}
- (IBAction)createUserAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
#pragma mark - request网络请求
//登录
- (void) request {
    //创建菊花膜（点击按钮的时候，并显示在当前页面）
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    //参数
    NSDictionary *para = @{@"tel" : _phoneTextField.text,@"pwd" : _pwdTextField.text};
    //网络请求
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        NSLog(@"哈哈:%@",responseObject);
        //当网络请求成功时停止动画
        [avi stopAnimating];
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            NSDictionary *result = responseObject[@"result"];
            NSString *token = result[@"token"];
            //NSLog(@"%@",token);
            //防范式(移除这个键)
            [[StorageMgr singletonStorageMgr] removeObjectForKey:@"token"];
            //把token存入单例化全局变量中
            [[StorageMgr singletonStorageMgr] addKey:@"token" andValue:token];
            
            //客户的电话号码是否要加密处理，根据接口返回的hidePhone判断。把hidePhone处理后存入单例化全局变量中，在其他有客户信息显示的页面上判断
            NSDictionary *agent = result[@"agent"];
            BOOL showPhone = [agent[@"hidePhone"] boolValue];
            [[StorageMgr singletonStorageMgr] removeObjectForKey:@"showPhone"];
            [[StorageMgr singletonStorageMgr]addKey:@"showPhone" andValue:@(showPhone)];
            
            //保存用户名
            [Utilities removeUserDefaults:@"tel"];
            //退出登录，或者返回桌面退出。回到软件保存用户名
            [Utilities setUserDefaults:@"tel" content:_phoneTextField.text];
            
            //清空用户名和密码(网络请求成功之后再执行，不然网络请求不到用户名和密码)
            //_userNameTextField.text = @"";
            _pwdTextField.text = @"";
            
            //登录成功跳页
            [self performSegueWithIdentifier:@"loginToTask" sender:self];
        }else{
            [Utilities popUpAlertViewWithMsg:responseObject[@"message"] andTitle:@"提示" onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
@end
