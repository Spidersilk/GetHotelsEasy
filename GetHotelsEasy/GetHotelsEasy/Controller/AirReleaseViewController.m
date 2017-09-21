//
//  AirReleaseViewController.m
//  GetHotelsEasy
//
//  Created by admin7 on 2017/9/1.
//  Copyright © 2017年 self. All rights reserved.
//

#import "AirReleaseViewController.h"
#import "CityTableViewController.h"
#import "MyInfoModel.h"

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
@property (weak, nonatomic) IBOutlet UIView *avi;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;


@property (weak, nonatomic) IBOutlet UIButton *DepartureTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrivalTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *afterTomorrowLabel;
@property (weak, nonatomic) IBOutlet UIButton *departureCityBtn;
@property (weak, nonatomic) IBOutlet UIButton *arrivalCityBtn;

@property (weak, nonatomic) IBOutlet UITextField *minimumPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *mostPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *TitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)postedAction:(UIButton *)sender forEvent:(UIEvent *)event;//发布
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval endTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yPosition;
@end

@implementation AirReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _date = [NSDate dateTomorrow];
    flag = 0;
    _datePickerView.frame = CGRectMake(0, UI_SCREEN_H, UI_SCREEN_W, 260);
    [self naviConfig];
    [self uiLayout];
    [self setDefaultDateForButton];
    // Do any additional setup after loading the view.
    //监听键盘将要打开这一操作，打开后执行keyboardWillShow:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"AirCity" object:nil];
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
//当前页面将要显示的时候，隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
//-(void)viewDidDisappear:(BOOL)animated{
//    
//    // 记得一定要注销通知监听，否则有时会导致crash
//    // 比如内存中两个类均收到通知，然后他们都想执行跳转,这个时候就crash了
//    //[[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)layoutConstraints:(CGFloat)space {
    CGFloat distance = 0;
    if (space == 0) {
        distance = _yPosition.constant;
    } else {
        distance = 200 - _yPosition.constant;
    }
    [UIView animateWithDuration:0.5 delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _yPosition.constant = space;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
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
-(void)setDefaultDateForButton{
    //初始化一个日期格式器Formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期的格式为yyyy-MM-dd年月日
    formatter.dateFormat = @"yyyy-MM-dd";
    //后天的时间
    NSDate *dateaftertomorrow = [NSDate dateWithDaysFromNow:2];
    //明天的日期
    NSDate *datetomorrow = [NSDate dateTomorrow];
    NSString *datestr = [formatter stringFromDate:dateaftertomorrow];
    NSString *datetomstr = [formatter stringFromDate:datetomorrow];
    //将处理好的时间字符串设置给两个button
    [_DepartureTimeBtn setTitle:datetomstr forState:UIControlStateNormal];
    [_arrivalTimeBtn setTitle:datestr forState:UIControlStateNormal];
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
    NSInteger low = [_minimumPriceTextField.text integerValue];
    NSInteger hight = [_mostPriceTextField.text integerValue] ;
    if (low > hight) {
        [Utilities popUpAlertViewWithMsg:@"请正确设置价格" andTitle:@"提示" onView:self onCompletion:^{}];
        return;
    }

    [self.view endEditing:YES];
}

// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    NSInteger low = [_minimumPriceTextField.text integerValue];
    NSInteger hight = [_mostPriceTextField.text integerValue] ;
    if (low > hight) {
        [Utilities popUpAlertViewWithMsg:@"请正确设置价格" andTitle:@"提示" onView:self onCompletion:^{}];
        return;
    }

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

-(void)Request{
    //创建菊花膜（点击按钮的时候，并显示在当前页面）
    _aiv = [Utilities getCoverOnView:self.view];
    MyInfoModel *usermodel = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    //开始日期
    if ([_arrivalCityBtn.titleLabel.text isEqualToString:@"请选择城市"]) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请选择抵达的城市" andTitle:@"提示" onView:self onCompletion:^{}];
        return;
    }
    NSDictionary *prarmeter = @{@"openid" : usermodel.openid , @"set_low_time_str" : _DepartureTimeBtn.titleLabel.text,@"set_high_time_str" : _arrivalTimeBtn.titleLabel.text ,@"set_hour":@"" ,@"departure" : _departureCityBtn.titleLabel.text ,@"destination" : _arrivalCityBtn.titleLabel.text ,@"low_price" : _minimumPriceTextField.text ,@"high_price" : _mostPriceTextField.text ,@"aviation_demand_detail" : _detailTextField.text ,@"aviation_demand_title" : _TitleTextField.text ,@"is_back":@"" ,@"back_low_time_str":@"" ,@"back_high_time_str":@"" ,@"people_number":@"" ,@"child_number":@"" ,@"weight":@"" };
    [RequestAPI requestURL:@"/addIssue_edu" withParameters:prarmeter andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [_aiv stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            [Utilities popUpAlertViewWithMsg:@"发布成功！" andTitle:@"提示" onView:self onCompletion:^{
                [self setDefaultDateForButton];
                _departureCityBtn.titleLabel.text = @"无锡";
                [_arrivalCityBtn setTitle:@"请选择城市" forState:UIControlStateNormal];
                _minimumPriceTextField.text = @"";
                _mostPriceTextField.text = @"";
                _TitleTextField.text = @"";
                _detailTextField.text =@"";
                _tomorrowLabel.hidden = NO;
                _afterTomorrowLabel.hidden = NO;
                }];
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误，稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
    }];
}


- (void)DepartureTime {
    _datePicker.minimumDate = [NSDate dateTomorrow];
    _avi.hidden = NO;
    flag = 0;
    _datePickerView.hidden = NO;
    [self layoutConstraints:0];
}

- (void)arrivalTime {
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:_date];
    _datePicker.minimumDate = nextDate;
    _avi.hidden = NO;
    flag = 1;
    [self layoutConstraints:0];
}

- (void)departureCity {
    //_avi.hidden = NO;
    flag = 2;
    //获取要跳转过去的那个页面
    CityTableViewController *city = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"City"];
    city.flag = 2;
    //执行跳转
    [self.navigationController pushViewController:city animated:YES];
    //[self presentViewController:city animated:YES completion:nil];
}

- (void)arrivalCity {
    flag = 3;
    //_avi.hidden = NO;
    //获取要跳转过去的那个页面
    CityTableViewController *city = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"City"];
    city.flag = 3;
    //执行跳转
    [self.navigationController pushViewController:city animated:YES];
    //[self presentViewController:city animated:YES completion:nil];
}

- (void) checkCityState:(NSNotification *)note {
    NSString *cityStr = note.object;
    if (flag == 2) {
        //修改城市按钮标题
        [_departureCityBtn setTitle:cityStr forState:UIControlStateNormal];
        _departureCityBtn.titleLabel.text = cityStr;
    }else if (flag == 3){
        //修改城市按钮标题
        [_arrivalCityBtn setTitle:cityStr forState:UIControlStateNormal];
        _arrivalCityBtn.titleLabel.text = cityStr;
    }
    if ([_arrivalCityBtn.titleLabel.text isEqualToString:_departureCityBtn.titleLabel.text]) {
        [Utilities popUpAlertViewWithMsg:@"与已选择的城市相同，请重新选择" andTitle:@"提示" onView:self onCompletion:^{
        }];
        return;
    }
}

- (IBAction)postedAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        if(_minimumPriceTextField.text.length == 0){
            [Utilities popUpAlertViewWithMsg:@"请输入最低价格" andTitle:nil onView:self onCompletion:^{
            }];
            return;
        }
        if(_mostPriceTextField.text.length == 0){
            [Utilities popUpAlertViewWithMsg:@"请输入最高价格" andTitle:nil onView:self onCompletion:^{
            }];
            return;
        }
        if(_detailTextField.text.length == 0){
            [Utilities popUpAlertViewWithMsg:@"请输入详情" andTitle:nil onView:self onCompletion:^{
            }];
            return;
        }
        [self Request];
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Main" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _avi.hidden = YES;
    [self layoutConstraints:-260];
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    _avi.hidden = YES;
    [self layoutConstraints:-260];
    //拿到当前datepicker选择的时间
    NSDate *date = _datePicker.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //定义日期的格式为yyyy-MM-dd
    formatter.dateFormat = @"yyyy-MM-dd";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    NSString *theDate = [formatter stringFromDate:date];
    [NSString stringWithFormat:@""];
    //flag等于0 则开始按钮变为时间，反之结束按钮变为时间
    if (flag == 0 ) {
        _date = date;
        _tomorrowLabel.hidden = NO;
        [_DepartureTimeBtn setTitle:theDate forState:UIControlStateNormal];
        if (![theDate isEqualToString: [formatter stringFromDate:[NSDate dateTomorrow]]]) {
            _tomorrowLabel.hidden = YES;
            [_DepartureTimeBtn setTitle:theDate forState:UIControlStateNormal];
        }
        NSTimeInterval startTime = [Utilities cTimestampFromString:theDate format:@"yyyy-MM-dd"];
        //结束日期
       
        if (startTime >= _endTime) {
            NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
            NSString *nextdate = [formatter stringFromDate:nextDate];
            if (![nextdate isEqualToString: [formatter stringFromDate:[NSDate dateWithDaysFromNow:2]]]) {
                _afterTomorrowLabel.hidden = YES;
                [_arrivalTimeBtn setTitle:nextdate forState:UIControlStateNormal];
            }
        }
    }else{
        _afterTomorrowLabel.hidden = NO;
        [_arrivalTimeBtn setTitle:theDate forState:UIControlStateNormal];
        if (![theDate isEqualToString: [formatter stringFromDate:[NSDate dateWithDaysFromNow:2]]]) {
            _afterTomorrowLabel.hidden = YES;
            [_arrivalTimeBtn setTitle:theDate forState:UIControlStateNormal];
        }
         _endTime = [Utilities cTimestampFromString:theDate format:@"yyyy-MM-dd"];
}
}

@end
