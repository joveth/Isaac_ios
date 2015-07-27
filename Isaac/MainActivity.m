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
    UISearchBar *searchHeader;
    UIButton *rightBtn;
    UIButton *leftBtn;
    NSArray *titleArr ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    contentList  =[[NSMutableArray alloc] init];
    db = [DBHelper sharedInstance];
    titleArr= [[NSArray alloc] initWithObjects:@"全部",@"主动", @"被动",@"饰品",@"塔牌",@"符文",@"胶囊",@"人物",@"成就", nil];
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 24, 35, 36)];
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self  action:@selector(showMenu) forControlEvents:UIControlEventTouchDown];
    [self loadData];
}
-(void)reginText{
    if([searchHeader isFirstResponder]){
        [searchHeader resignFirstResponder];
    }else{
        [searchHeader becomeFirstResponder];
    }
    
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
        nameLabel.text = [NSString stringWithFormat:@"%@(%@)",bean.name,bean.enName];
        if(![Common isEmptyString:bean.image]){
            image.image = [UIImage imageNamed:bean.image];
            image.frame = CGRectMake(8, cell.frame.size.height-18, 30, 30);
        }
        if(![Common isEmptyString:bean.content]){
            CGSize size = [bean.content sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:12.0f] forKey:NSFontAttributeName]];
            CGFloat width = [UIScreen mainScreen].applicationFrame.size.width-55;
            CGFloat lines = size.width/width;
            //            NSString *temp = [NSString stringWithFormat:@"%0.0f",lines];
            contentLabel.frame=CGRectMake(50, 30, self.view.frame.size.width-55, size.height*(lines+1)+44);
            contentLabel.text = bean.content;
        }else{
            image.frame = CGRectMake(8, 8, 30, 30);
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
            return size.height*(lines+1)+60;
        }
        
    }
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    
    searchHeader =  [[UISearchBar alloc] initWithFrame:CGRectMake(40, 24, frame.size.width-80, 36)];
    searchHeader.backgroundColor=[UIColor whiteColor];
    searchHeader.placeholder=@"搜索";
    searchHeader.layer.cornerRadius=6;
    searchHeader.layer.masksToBounds=YES;
    searchHeader.layer.borderWidth=1;
    searchHeader.layer.borderColor=[Common colorWithHexString:@"e0e0e0"].CGColor;
    searchHeader.barStyle=UIBarStyleDefault;
    searchHeader.returnKeyType = UIReturnKeySearch;
    searchHeader.delegate = self;
    searchHeader.barTintColor = [UIColor whiteColor] ;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 74)];
    headerView.backgroundColor = [Common colorWithHexString:@"e0e0e0"];

    UIView *inHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 73)];
    inHeaderView.backgroundColor = [UIColor whiteColor];
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-35, 26, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"scan.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(onClickScan) forControlEvents:UIControlEventTouchDown];
    
    [inHeaderView addSubview:leftBtn];
    [inHeaderView addSubview:rightBtn];
    [inHeaderView addSubview:searchHeader];
    [headerView addSubview:inHeaderView];
    return headerView;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText=%@",searchText);
    if([Common isEmptyString:searchText]){
        contentList = [db getIsaacs:@"1"];
        [self.tableView reloadData];
    }
}


-(void)onClickScan{
    NSLog(@"do scan ...");
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchHeader.showsCancelButton = YES;
   
    for(id cc in [searchHeader subviews])
    {
        for (id zz in [cc subviews]) {
            if([zz isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
            }
        }
    }
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if([Common isEmptyString:searchHeader.text]){
        contentList = [db getIsaacs:@"1"];
        [self.tableView reloadData];
    }else{
        contentList = [db getIsaacsByKey:searchHeader.text];
        [self.tableView reloadData];
    }
    //[searchHeader resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    contentList = [db getIsaacs:@"1"];
    [self.tableView reloadData];
    searchHeader.showsCancelButton = NO;
    [searchHeader resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 74;
}

-(void)loadData{
    [db openDB];
    contentList = [db getIsaacs:@"1"];
    [self.tableView reloadData];
}

-(void)showMenu{
    [searchHeader resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部",@"主动", @"被动",@"饰品",@"塔牌",@"符文",@"胶囊",@"人物",@"成就",nil];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    [sheet showInView:[self.view window]];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        contentList = [db getIsaacs:@"1"];
        [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
        [self.tableView reloadData];
    }else if(buttonIndex!=9) {
        contentList=[db getIsaacsByType:[NSString stringWithFormat:@"%ld",(long)buttonIndex]];
        [leftBtn setTitle:[titleArr objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 48;
}

@end
