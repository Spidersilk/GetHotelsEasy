//
//  AirReleaseViewController.m
//  GetHotelsEasy
//
//  Created by admin7 on 2017/9/1.
//  Copyright © 2017年 self. All rights reserved.
//

#import "AirReleaseViewController.h"

@interface AirReleaseViewController ()<UITextFieldDelegate>{
    NSInteger flag;
    float _keyBoardHeight;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *DepartureTimeView;
@property (weak, nonatomic) IBOutlet UIView *arrivalTimeView;
@property (weak, nonatomic) IBOutlet UIView *departureCityView;
@property (weak, nonatomic) IBOutlet UIView *arrivalCityView;

@property (weak, nonatomic) IBOutlet UIButton *DepartureTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *arrivalTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *departureCityBtn;
@property (weak, nonatomic) IBOutlet UIButton *arrivalCityBtn;

@property (weak, nonatomic) IBOutlet UITextField *minimumPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *mostPriceTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)postedAction:(UIButton *)sender forEvent:(UIEvent *)event;//发布
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;




@end

@implementation AirReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag = 0;
    [self naviConfig];
    [self uiLayout];
    // Do any additional setup after loading the view.
    //监听键盘将要打开这一操作，打开后执行keyboardWillShow:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    // 点击空白处收键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    UITapGestureRecognizer *DepartureTimeRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DepartureTime)];
    [_DepartureTimeView addGestureRecognizer:DepartureTimeRecognizer];
    UITapGestureRecognizer *arrivalTimeRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(arrivalTime)];
    [_arrivalTimeView addGestureRecognizer:arrivalTimeRecognizer];
    UITapGestureRecognizer *departureCityRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(departureCity)];
    [_departureCityView addGestureRecognizer:departureCityRecognizer];
    UITapGestureRecognizer *arrivalCityRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(arrivalCity)];
    [_arrivalCityView addGestureRecognizer:arrivalCityRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    
    // 记得一定要注销通知监听，否则有时会导致crash
    // 比如内存中两个类均收到通知，然后他们都想执行跳转,这个时候就crash了
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"发布需求";
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 128, 255);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
}
- (void)uiLayout{
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.backView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.backView.layer.shadowRadius = 4;//阴影半径，默认3
    self.minimumPriceTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置输入框边框颜色
    _minimumPriceTextField.layer.borderWidth = 1.0;     //设置输入框边框宽度
    self.mostPriceTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _mostPriceTextField.layer.borderWidth = 1.0;
}

//键盘打开时的操作
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _keyBoardHeight = keyboardSize.height;
    [self changeViewYByShow];
    
}

- (void)keyboardDidHide:(NSNotification *)notification{
    _keyBoardHeight = 0;
    _topConstraint.constant = 60.0f;
    [self changeViewYByHide];
}

#pragma mark - private methods
- (void)changeViewYByShow{
    
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, _keyBoardHeight, 0);
    /*  这个方法不好用
     [UIView animateWithDuration:0.2 animations:^{
     CGRect rect = self.view.frame;
     rect.origin.y -= _keyBoardHeight;
     self.view.frame = rect;
     }];*/
}

- (void)changeViewYByHide{
    
    //_scrollView.contentOffset = CGPointMake(0, 60);
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
     //这个方法不好用
//     CGRect rect = self.view.frame;
//     rect.origin.y = 0;
//     self.view.frame = rect;
}
//键盘收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// 滑动空白处隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)DepartureTime {
    flag = 0;
    _toolBar.hidden = NO;
    _datePicker.hidden = NO;
    NSLog(@"点击了page3");
}

- (void)arrivalTime {
    flag = 1;
    _toolBar.hidden = NO;
    _datePicker.hidden = NO;
}

- (void)departureCity {
    
}
- (void)arrivalCity {
    
}
- (IBAction)postedAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _datePicker.hidden = YES;
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的时间
    NSDate *date = _datePicker.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"yyyy-MM-dd";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    NSString *theDate = [formatter stringFromDate:date];
    //flag等于0 则开始按钮变为时间，反之结束按钮变为时间
    if (flag == 0) {
        [_DepartureTimeBtn setTitle:theDate forState:UIControlStateNormal];
    }else{
        [_arrivalTimeBtn setTitle:theDate forState:UIControlStateNormal];
    }    _toolBar.hidden = YES;
    _datePicker.hidden = YES;
}
@end
