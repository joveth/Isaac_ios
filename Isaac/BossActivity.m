//
//  BossActivity.m
//  Isaac
//
//  Created by Shuwei on 15/7/22.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "BossActivity.h"
#import "BossItemCell.h"
#import "DBHelper.h"
#import "BossBean.h"
#import "BossFlowLayout.h"
#import "RatingView.h"
#import "ShareData.h"
#import "BossDetailActivity.h"
#import "Common.h"

@interface BossActivity ()

@end

@implementation BossActivity{
    NSMutableArray *contentList;
    DBHelper *db;
    CGFloat colWidth;
}

static NSString * const reuseIdentifier = @"BossItemCell";
static NSInteger const nameLabel = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[BossItemCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //self.collectionView.backgroundColor =[Common colorWithHexString:@"eb4f38"];
    contentList  =[[NSMutableArray alloc] init];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    BossFlowLayout *fl = [[BossFlowLayout alloc] init];
    fl.minimumInteritemSpacing = 10;
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = fl;
    //self.collectionView.bounces=NO;
    db = [DBHelper sharedInstance];
    colWidth = [UIScreen mainScreen].applicationFrame.size.width/2-12;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [contentList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BossItemCell *cell = (BossItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:nameLabel] ;
    UIImageView *image =(UIImageView *)[cell.contentView viewWithTag:2] ;
    if(name==nil){
        name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
        name.tag = nameLabel;
        [cell.contentView addSubview:name];
    }
    if(image==nil){
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
        image.tag = 2;
        [cell.contentView addSubview:image];
    }
    
    RatingView *starRatingView =(RatingView *)[cell.contentView viewWithTag:3];
    if(starRatingView==nil){
        starRatingView =[[RatingView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        starRatingView.tag=3;
        [cell.contentView addSubview:starRatingView];
        [starRatingView setImagesDeselected:@"star1.png" partlySelected:@"star2.png" fullSelected:@"star3.png" andDelegate:nil];
    }
    
    cell.layer.cornerRadius=4;
    cell.layer.masksToBounds=YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderWidth=0.2;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    BossBean *bean = [contentList objectAtIndex:indexPath.row];
    
    if(bean){
        UIImage *temp = [UIImage imageNamed:bean.image];
        name.frame = CGRectMake(6, 4, colWidth-12, 30);
        image.frame = CGRectMake(6, 36, colWidth-12, temp.size.height);
        image.image = temp;
        name.text = bean.name;
        starRatingView.frame = CGRectMake(6, 48+temp.size.height, colWidth-12, 30);
        [starRatingView displayRating:bean.score.floatValue/2];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeMake(colWidth, 0);
    BossBean *bean = [contentList objectAtIndex:indexPath.row];
    if(bean){
        UIImage *temp = [UIImage imageNamed:bean.image];
        returnSize = CGSizeMake(colWidth, temp.size.height+84);
    }
    return returnSize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [ShareData shareInstance].bossBean = [contentList objectAtIndex:indexPath.row];
    BossDetailActivity *detal = [[BossDetailActivity alloc] init];
    [self presentViewController:detal animated:YES completion:nil];
}

-(void)loadData{
    [db openDB];
    contentList = [db getBoss:@"1"];
    [self.collectionView reloadData];
}
@end
