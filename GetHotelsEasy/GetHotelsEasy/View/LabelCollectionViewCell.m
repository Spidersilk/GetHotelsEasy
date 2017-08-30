//
//  LabelCollectionViewCell.m
//  GetHotelsEasy
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 self. All rights reserved.
//

#import "LabelCollectionViewCell.h"

@implementation LabelCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _lable.textAlignment = NSTextAlignmentCenter;
        //_lable.textColor = [UIColor blueColor];
        //_lable.font = [UIFont systemFontOfSize:15];
        //_lable.backgroundColor = [UIColor purpleColor];
        [_lable.layer setBorderWidth:0.5];//设置边框
        _lable.layer.cornerRadius = 5.0 ;
        [_lable setFont:[UIFont boldSystemFontOfSize:9]];
        _lable.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_lable];
    }
    
    return self;
}

@end
