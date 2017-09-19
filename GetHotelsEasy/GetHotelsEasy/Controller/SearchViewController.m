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
@property (strong, nonatomic) NSMutableArray *SearcArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _SearcArr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


//将要来到此页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏下面的线
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
  
    [self setNavigationItem];
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:nil];
    
   
    //[[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //[self.navigationController.navigationBar setBackgroundImage:nilforBarPosition:UIBarPositionAnybarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //self.navigationController.navigationBar.clipsToBounds = YES;
    //去除导航栏半透膜
    [self useMethodToFindBlackLineAndHind];
    [self findHairlineImageViewUnder:[[UIView alloc] init]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(14, 123, 235) ;
    
}
-(void)useMethodToFindBlackLineAndHind
{
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //隐藏黑线（在viewWillAppear时隐藏，在viewWillDisappear时显示）
    blackLineImageView.hidden = YES;
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
//设置导航栏样式
-(void)setNavigationItem{
    //[self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(201,201,206)];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    //导航栏的返回按钮只保留那个箭头，去掉后边的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = item;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                [_SearcArr addObject:detailmodel];
            }
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"SearcHome" object:_SearcArr] waitUntilDone:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
            //NSString *business_id
            //业务逻辑成功的情况下
        }else{
            [Utilities popUpAlertViewWithMsg:@"没找到你需要的酒店" andTitle:nil onView:self];
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
