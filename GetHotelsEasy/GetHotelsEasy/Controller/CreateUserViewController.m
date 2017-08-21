//
//  CreateUserViewController.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 self. All rights reserved.
//

#import "CreateUserViewController.h"

@interface CreateUserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
- (IBAction)createAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation CreateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)createAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
