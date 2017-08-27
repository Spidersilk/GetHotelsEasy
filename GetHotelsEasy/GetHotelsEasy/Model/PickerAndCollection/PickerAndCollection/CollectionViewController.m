//
//  CollectionViewController.m
//  PickerAndCollection
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "CollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"

@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    BOOL flag;
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)editAction:(UIBarButtonItem *)sender;


@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    flag = NO;
    index = 0;
    //刚来到这个页面禁止被选中
    _collectionView.allowsSelection = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
//每组有多少items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
//细胞长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.photoIV.image = [UIImage imageNamed:@"avatar"];
    //未选中时细胞的背景试图
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor blueColor];
    cell.backgroundView = bgView;
    //选中时细胞的背景试图
    UIView *bV = [UIView new];
    bV.backgroundColor = [UIColor redColor];
    cell.selectedBackgroundView = bV;
    return cell;
}
//设置collectionView的header和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuView = nil;
    if(kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.dateLabel.text = @"2017年7月15日";
        reuView = header;
    }
    return reuView;
}
//每个细胞的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat x = self.view.frame.size.width;
    CGFloat space = self.view.frame.size.width / 200;
    return CGSizeMake(( x-  space* 3) / 4, (x-  space* 3) / 4);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  self.view.frame.size.width / 200;
}
//细胞的横向间距（列间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.view.frame.size.height / 500;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editAction:(UIBarButtonItem *)sender {
//    if (flag) {
//        sender.title = @"编辑";
//    }else{
//        sender.title = @"取消";
//    }
//    flag = !flag;
    if (++index % 2 == 0) {
        sender.title = @"编辑";
        _collectionView.allowsSelection = NO;
    }else{
        sender.title = @"取消";
        _collectionView.allowsSelection = YES;
        _collectionView.allowsMultipleSelection = YES;
    }
}
@end
