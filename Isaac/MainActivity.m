//
//  MainActivity.m
//  Isaac
//
//  Created by Shuwei on 15/7/3.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "MainActivity.h"
#import "DBHelper.h"
#import "IsaacBean.h"
#import "Common.h"

@interface MainActivity ()
@end

@implementation MainActivity{
    NSMutableArray *contentList;
    DBHelper *db;
    UITextField *searchHeader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    contentList  =[[NSMutableArray alloc] init];
    db = [DBHelper sharedInstance];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contentList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentifier = @"cellIdentifier";
  
    UILabel *nameLabel ;
    UIImageView *image;
    UILabel *contentLabel;
//    if (cell == nil) {
     UITableViewCell    *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.tintColor = [UIColor greenColor];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, self.view.frame.size.width-55, 21)];
        nameLabel.lineBreakMode=NSLineBreakByWordWrapping;
        nameLabel.numberOfLines=0;
        image = [[UIImageView alloc]init];
        contentLabel = [[UILabel alloc] init];
        contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
        contentLabel.numberOfLines=0;
        contentLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [cell addSubview:nameLabel];
        [cell addSubview:image];
        [cell addSubview:contentLabel];
    //}
    
    IsaacBean *bean = [contentList objectAtIndex:indexPath.row];
    if(bean){
        nameLabel.text = bean.name;
        if(![Common isEmptyString:bean.image]){
            image.image = [UIImage imageNamed:bean.image];
            image.frame = CGRectMake(8, cell.frame.size.height-18, 36, 36);
        }
        if(![Common isEmptyString:bean.content]){
            CGSize size = [bean.content sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:12.0f] forKey:NSFontAttributeName]];
            CGFloat width = [UIScreen mainScreen].applicationFrame.size.width-55;
            CGFloat lines = size.width/width;
//            NSString *temp = [NSString stringWithFormat:@"%0.0f",lines];
            contentLabel.frame=CGRectMake(50, 30, self.view.frame.size.width-55, size.height*(lines+1));
            contentLabel.text = bean.content;
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IsaacBean *bean = [contentList objectAtIndex:indexPath.row];
    if(bean){
        
        if(![Common isEmptyString:bean.content]){
            CGSize size = [bean.content sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:12.0f] forKey:NSFontAttributeName]];
            CGFloat width = [UIScreen mainScreen].applicationFrame.size.width-55;
            CGFloat lines = size.width/width;
            //NSString *temp = [NSString stringWithFormat:@"%0.0f",lines];
            return size.height*(lines+1)+44;
        }
        
    }
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    searchHeader =  [[UITextField alloc] initWithFrame:CGRectMake(5, 24, self.view.frame.size.width-10, 36)];
    searchHeader.backgroundColor=[UIColor whiteColor];
    searchHeader.placeholder=@"搜索";
    searchHeader.layer.cornerRadius=6;
    searchHeader.layer.masksToBounds=YES;
    searchHeader.layer.borderWidth=1;
    searchHeader.layer.borderColor=[Common colorWithHexString:@"e0e0e0"].CGColor;
    searchHeader.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchHeader.textAlignment = NSTextAlignmentCenter;
//    UIImageView *imgViewschoolRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search.png"]];
//    imgViewschoolRight.frame=CGRectInset(imgViewschoolRight.frame, 2, 2);
//    searchHeader.leftViewMode = UITextFieldViewModeUnlessEditing;
//    searchHeader.leftView = imgViewschoolRight;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 74)];
    headerView.backgroundColor = [Common colorWithHexString:@"e0e0e0"];
    UIView *inHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 68)];
    inHeaderView.backgroundColor = [UIColor whiteColor];
    [inHeaderView addSubview:searchHeader];
    [headerView addSubview:inHeaderView];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 74;
}

-(void)loadData{
    [db openDB];
    contentList = [db getIsaacs:@"1"];
    [self.tableView reloadData];
}

@end
