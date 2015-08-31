//
//  H2Controller.m
//  Isaac
//
//  Created by Shuwei on 15/8/31.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "H2Controller.h"
#import "Common.h"

@interface H2Controller ()

@end
static NSString * const reuseIdentifier = @"Cell";
@implementation H2Controller{
    UISearchBar *searchBar;
    UICollectionView *collect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.tintColor = [Common colorWithHexString:@"eb4f38"];
    [self.tabBarController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setSelectedImage:[UIImage imageNamed:@"home"]];
    UIView *ver= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    ver.backgroundColor = [Common colorWithHexString:@"eb4f38"];
    //search = [[UISearchDisplayController alloc] initWithSearchBar:<#(UISearchBar *)#> contentsController:<#(UIViewController *)#>];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, self.view.frame.size.width, 30)];
    title.textColor=[UIColor whiteColor];
    title.text=@"以撒图鉴";
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:20];
    searchBar =  [[UISearchBar alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 40)];
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
    [ver addSubview:title];
    [self.view addSubview:ver];
    self.view.backgroundColor = [Common colorWithHexString:@"e0e0e0"];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
    collect  =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 195) collectionViewLayout:flowLayout];
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    collect.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:collect];
    collect.delegate =self;
    collect.dataSource = self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        name.text=@"以撒のNews";
        image.image=[UIImage imageNamed:@"news"];
    }else if(indexPath.row==1){
        name.text=@"MOD合集";
        image.image=[UIImage imageNamed:@"mod"];
    }else if(indexPath.row==2){
        name.text=@"各种Seed";
        image.image=[UIImage imageNamed:@"seed"];
    }else if(indexPath.row==3){
        name.text=@"以撒同人";
        image.image=[UIImage imageNamed:@"same"];
    }else if(indexPath.row==4){
        name.text=@"萌萌哒手绘";
        image.image=[UIImage imageNamed:@"pic"];
    }else if(indexPath.row==5){
        name.text=@"故事会";
        image.image=[UIImage imageNamed:@"stor"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeMake(self.view.frame.size.width/3-10, 90);
    return returnSize;
}

@end
