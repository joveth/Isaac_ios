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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.tintColor = [UIColor greenColor];
    }
    for(UIView * view in [cell subviews] ){
        [view removeFromSuperview];
    }
    IsaacBean *bean = [contentList objectAtIndex:indexPath.row];
    if(bean){
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, self.view.frame.size.width-55, 21)];
        nameLabel.text = bean.name;
        nameLabel.lineBreakMode=NSLineBreakByWordWrapping;
        nameLabel.numberOfLines=0;
        [cell addSubview:nameLabel];
        if(![Common isEmptyString:bean.image]){
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bean.image]];
            image.frame = CGRectMake(8, cell.frame.size.height-18, 36, 36);
            [cell addSubview:image];
        }
        if(![Common isEmptyString:bean.content]){
            CGSize size = [bean.content sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:12.0f] forKey:NSFontAttributeName]];
            CGFloat width = [UIScreen mainScreen].applicationFrame.size.width-55;
            CGFloat lines = size.width/width;
            NSString *temp = [NSString stringWithFormat:@"%0.0f",lines];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, self.view.frame.size.width-55, 21*(temp.integerValue+1))];
            contentLabel.text = bean.content;
            contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
            contentLabel.numberOfLines=0;
            contentLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
            [cell addSubview:contentLabel];
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
            NSString *temp = [NSString stringWithFormat:@"%0.0f",lines];
            return 21*(temp.integerValue+1)+44;
        }
        
    }
    return 44;
}

-(void)loadData{
    [db openDB];
    contentList = [db getIsaacs:@"1"];
    [self.tableView reloadData];
}

@end
