//
//  PickerViewController.m
//  PickerAndCollection
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *popupBtn;
- (IBAction)popupAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cencelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSArray *pickerArr;
@property (strong, nonatomic) NSArray *arr;

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerArr = @[@"小米",@"华为",@"苹果",@"魅族",@"诺基亚",@"锤子"];
    _arr = @[@"百度",@"UC",@"E+",@"魅族",@"诺基亚",@"锤子"];
    //设置pickerView选中行，并且不要动画
    [_pickerView selectRow:2 inComponent:0 animated:NO];
    //刷新第一列
    [_pickerView reloadComponent:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
//每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _pickerArr.count;
    }
    return _arr.count;
}
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}
//每列的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return _pickerArr[row];
    }else{
        return _arr[row];;
    }
}
//每列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return _pickerView.frame.size.width / 4;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)popupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
}

- (IBAction)cencelAction:(id)sender {
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
}

- (IBAction)doneAction:(id)sender {
    //拿到某一列中选中的行号
    NSInteger row = [_pickerView selectedRowInComponent:0];
    //根据上面拿到行号，找到对应的数据（选中行的标题）
    NSString *title = _pickerArr[row];
    NSInteger secondRow = [_pickerView selectedRowInComponent:1];
    NSString *str = _arr[secondRow];
    //NSString *string = [title stringByAppendingString:str];
    [_popupBtn setTitle:[title stringByAppendingString:str] forState:UIControlStateNormal];
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}
@end
