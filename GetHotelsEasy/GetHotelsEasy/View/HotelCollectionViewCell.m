//
//  CollectionViewCell.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 self. All rights reserved.
//

#import "HotelCollectionViewCell.h"

@implementation HotelCollectionViewCell
//- (instancetype)initWithFrame:(CGRect)frame:(NSString*)title
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _Btn = [[UIButton alloc] initWithFrame:frame];
//        [_Btn setTitle:title forState:UIControlStateNormal];
//        [_Btn.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];//设置字体大小
//        [_Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        _Btn.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
//        [_Btn.layer setBorderWidth:0.3];//设置边框
//        _Btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
//        //添加事件3
////    [_Btn addTarget:self action:@selector(Btn3Action) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
//        _topImage.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_topImage];
        
//        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        _botlabel.textAlignment = NSTextAlignmentCenter;
//        _botlabel.textColor = [UIColor blueColor];
//        _botlabel.font = [UIFont systemFontOfSize:15];
//        _botlabel.backgroundColor = [UIColor purpleColor];
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //[_button setTitle:@"智能排序" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];//设置字体大小
        [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //_button.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.8);
        //[_button.layer setBorderWidth:0.5];//设置边框
        //_button.layer.borderColor=[UIColor lightGrayColor].CGColor;
        //_button.layer.cornerRadius = 5.0 ;
        
        [self.contentView addSubview:_button];
    }
   
    
    return self;
}

@end
