//
//  HomeController.m
//  Isaac
//
//  Created by Shuwei on 15/8/31.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "HomeController.h"
#import "Common.h"

@interface HomeController ()

@end

@implementation HomeController{
    UISearchDisplayController *search;
    UISearchBar *searchBar;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    UIView *ver= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    ver.backgroundColor = [Common colorWithHexString:@"eb4f38"];
    //search = [[UISearchDisplayController alloc] initWithSearchBar:<#(UISearchBar *)#> contentsController:<#(UIViewController *)#>];
    searchBar =  [[UISearchBar alloc] initWithFrame:CGRectMake(40, 24, self.view.frame.size.width-80, 36)];
    searchBar.backgroundColor=[UIColor whiteColor];
    searchBar.placeholder=@"搜索";
    searchBar.layer.cornerRadius=6;
    searchBar.layer.masksToBounds=YES;
    searchBar.layer.borderWidth=1;
    searchBar.layer.borderColor=[Common colorWithHexString:@"e0e0e0"].CGColor;
    searchBar.barStyle=UIBarStyleDefault;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor whiteColor] ;
    [ver addSubview:searchBar];
    [self.view addSubview:ver];
    CGRect frame =self.collectionView.frame;
    frame.origin.y=70;
    frame.size.height-=70;
    self.collectionView.frame=frame;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 14;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:1] ;
    UIImageView *image =(UIImageView *)[cell.contentView viewWithTag:2] ;
    CGFloat width=self.view.frame.size.width/3;
    if(name==nil){
        name = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, width-10, 20)];
        name.tag = 1;
        name.textAlignment=NSTextAlignmentCenter;
        name.textColor = [Common colorWithHexString:@"eb4f38"];
        [cell.contentView addSubview:name];
    }
    if(image==nil){
        image = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-22, 10, 44, 44)];
        image.tag = 2;
        [cell.contentView addSubview:image];
    }
    if(indexPath.row==0){
        name.text=@"图鉴";
        image.image=[UIImage imageNamed:@"s"];
    }else if(indexPath.row==1){
        name.text=@"Boss";
        image.image=[UIImage imageNamed:@"b1"];
    }else if(indexPath.row==2){
        name.text=@"小怪";
        image.image=[UIImage imageNamed:@"l"];
    }else if(indexPath.row==3){
        name.text=@"以撒のNews";
        image.image=[UIImage imageNamed:@"news"];
    }else if(indexPath.row==4){
        name.text=@"MOD合集";
        image.image=[UIImage imageNamed:@"mod"];
    }else if(indexPath.row==5){
        name.text=@"各种Seed";
        image.image=[UIImage imageNamed:@"seed"];
    }else if(indexPath.row==6){
        name.text=@"以撒同人";
        image.image=[UIImage imageNamed:@"same"];
    }else if(indexPath.row==7){
        name.text=@"萌萌哒手绘";
        image.image=[UIImage imageNamed:@"pic"];
    }else if(indexPath.row==8){
        name.text=@"故事会";
        image.image=[UIImage imageNamed:@"stor"];
    }else if(indexPath.row==9){
        name.text=@"基础掉落";
        image.image=[UIImage imageNamed:@"luo"];
    }else if(indexPath.row==10){
        name.text=@"地形物体";
        image.image=[UIImage imageNamed:@"earth"];
    }else if(indexPath.row==11){
        name.text=@"房间的说";
        image.image=[UIImage imageNamed:@"room"];
    }else if(indexPath.row==12){
        name.text=@"Boss Rush";
        image.image=[UIImage imageNamed:@"rush"];
    }else if(indexPath.row==13){
        name.text=@"更多";
        image.image=[UIImage imageNamed:@"mor"];

    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeMake(self.view.frame.size.width/3-10, 90);
    return returnSize;
}

@end
