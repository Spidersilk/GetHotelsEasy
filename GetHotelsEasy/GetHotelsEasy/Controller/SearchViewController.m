//
//  SearchViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 self. All rights reserved.
//

#import "SearchViewController.h"
#import "detailModel.h"

@interface SearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *SearcBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfing];
}
//将要来到此页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfing
{
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(1, 150, 255);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条按钮的分格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //是否需要毛玻璃的效果
    self.navigationController.navigationBar.translucent = YES;
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 22, 22);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始编辑");
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束编辑");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [self request];
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
    
}

//执行网络请求
- (void)request {
    NSDictionary *prarmeter = @{@"hotel_name":_SearcBar.text,@"inTime":[NSString stringWithFormat:@"2017-%@",_inDate],@"outTime":[NSString stringWithFormat:@"2017-%@",_outDate]};
    //开始请求
    [RequestAPI requestURL:@"/selectHotel" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        
        //成功以后要做的事情
        NSLog(@"responseObject = %@",responseObject);
        //       [self endAnimation];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSArray *content = responseObject[@"content"];
            for(NSDictionary *dict in content){
                detailModel * detailmodel = [[detailModel alloc]initWhitDictionary:dict];
            }
            //NSString *business_id
            //业务逻辑成功的情况下
        }else{
            [Utilities popUpAlertViewWithMsg:@"哈哈" andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
    [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
