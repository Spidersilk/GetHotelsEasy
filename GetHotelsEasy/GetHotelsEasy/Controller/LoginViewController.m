//
//  LoginViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import "LoginViewController.h"
#import "MyInfoModel.h"
#import "MyHotelViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *createUserBtn;
- (IBAction)createUserAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *photoimageView;
@property (strong, nonatomic) UIActivityIndicatorView *avi;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uiLayout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"会员登录";
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 128, 255);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
}
//自定的返回按钮的事件
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uiLayout{
    _photoimageView.layer.borderWidth = 1;//设置用户头像边框
    _photoimageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.backView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.backView.layer.shadowRadius = 4;//阴影半径，默认3
    //添加事件监听当输入框的内容改变时调用textChange:方法
    if(![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]){
        if([Utilities getUserDefaults:@"Username"] != nil){
            //将它显示在用户名输入框中
            _phoneTextField.text = [Utilities getUserDefaults:@"Username"];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}
//键盘收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if(_phoneTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_pwdTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_pwdTextField.text.length < 6 || _pwdTextField.text.length > 18){
        [Utilities popUpAlertViewWithMsg:@"您的密码必须在6~18之间" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    //判断某个字符串中是否每个字符都是数字(invertedSet:反向设置，Digits：数字)
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_phoneTextField.text.length < 11 || [_phoneTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    [self request];
}
- (IBAction)createUserAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
#pragma mark - request网络请求
//登录
- (void) request {
    //创建菊花膜（点击按钮的时候，并显示在当前页面）
    _avi = [Utilities getCoverOnView:self.view];
    //参数
    NSDictionary *para = @{@"tel" : _phoneTextField.text,@"pwd" : _pwdTextField.text};
    //网络请求
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"哈哈:%@",responseObject);
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *content = responseObject[@"content"];

            //NSLog(@"%@",token);
            MyInfoModel *usermodel = [[MyInfoModel alloc] initWithDict:content];
            //将登录获取到的用户信息打包存储到单例化全局变量中
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:usermodel];
            //单独将用户的ID也存储进单例化全局变量来作为用户是否已经登录的判断依据，同时也方便其它所有页面更快捷地使用ID这个参数
            [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:@(usermodel.Id)];
            //让根视图结束编辑状态达到收起键盘的目的
            [self.view endEditing:YES];
            //保存用户名
            [Utilities removeUserDefaults:@"Username"];
            //退出登录，或者返回桌面退出。回到软件保存用户名
            [Utilities setUserDefaults:@"Username" content:_phoneTextField.text];
            
            //清空用户名和密码(网络请求成功之后再执行，不然网络请求不到用户名和密码)
            //_userNameTextField.text = @"";
            _pwdTextField.text = @"";
            
            //用model的方式返回上一页
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
@end
