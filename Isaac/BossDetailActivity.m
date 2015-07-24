//
//  BossDetailActivity.m
//  Isaac
//
//  Created by Shuwei on 15/7/23.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "BossDetailActivity.h"
#import "ShareData.h"
#import "Common.h"
#import "DBHelper.h"

@interface BossDetailActivity ()
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (nonatomic, strong, readwrite) UIViewController *theViewController;
@property (nonatomic, strong, readwrite) UIViewController *leftTab;
@end

@implementation BossDetailActivity{
    UIView *topView;
    UIImageView *bossImageView;
    UILabel *contentLabel;
    UILabel *nameLabel;
    UILabel *enLabel;
    UILabel *scoreLabel;
    BossBean *bossBean;
    UIButton *menuBtn;
    NSMutableArray *contentList;
    DBHelper *db;
    CGFloat screenWidth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Step 1: Create your controllers.
    self.frontViewController = [[UIViewController alloc] init];
    self.frontViewController.view.backgroundColor = [Common colorWithHexString:@"e0e0e0"];
    menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 40, 40)];
    [menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.frontViewController.view addSubview:menuBtn];
    contentList  =[[NSMutableArray alloc] init];
    db = [DBHelper sharedInstance];
    bossBean = [ShareData shareInstance].bossBean;
    if(!bossBean){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    UIImage *temp = [UIImage imageNamed:bossBean.image];
    CGFloat width = temp.size.width;
    if(temp.size.width<temp.size.height){
        width = temp.size.height;
    }
    screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    CGFloat height = [UIScreen mainScreen].applicationFrame.size.height;
    CGFloat yp = self.view.center.x-width/2-10;
    bossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(yp, 100, width+20, width+20)];
    bossImageView.backgroundColor = [UIColor whiteColor];
    bossImageView.image = temp;
    
    [bossImageView.layer setCornerRadius:(bossImageView.frame.size.width/2)];
    [bossImageView.layer setMasksToBounds:YES];
    [self.view setBackgroundColor:[Common colorWithHexString:@"e0e0e0"]];
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, screenWidth, 40)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = bossBean.name;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.frontViewController.view addSubview:nameLabel];
    [self.frontViewController.view addSubview:bossImageView];
    self.animationDuration = 0.25;
    
    self.leftTab = [[UIViewController alloc] init];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
    CGSize size = [bossBean.content sizeWithAttributes:attributes];
    CGFloat line = size.width/screenWidth;
    if(line<1){
        line=1;
    }else{
        NSString *th = [NSString stringWithFormat:@"%0.0f",line];
        NSInteger t = th.integerValue;
        if(line-t>0){
            line  = t+1;
        }else{
            line = t;
        }
    }
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140+width, screenWidth-20, line*24)];
    contentLabel.text = bossBean.content;
    [contentLabel setFont:[UIFont systemFontOfSize:16.0]];
    contentLabel.numberOfLines=0;
    contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
    
    [self.frontViewController.view addSubview:contentLabel];
    UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, screenWidth, height)];
    self.leftTab.view.backgroundColor=[Common colorWithHexString:@"eb4f38"];
    tab.backgroundColor = [Common colorWithHexString:@"eb4f38"];
    tab.delegate = self;
    tab.dataSource = self;
//    self.leftTab.tableView.backgroundColor = [Common colorWithHexString:@"eb4f38"];
//    self.leftTab.tableView.delegate = self;
//    self.leftTab.tableView.dataSource = self;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-100, 100)];
    UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 30, 100, 40)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];
    [self.leftTab.view addSubview:header];
    [self.leftTab.view addSubview:tab];
    self.leftViewController = self.leftTab;
    [self setMinimumWidth:screenWidth-60 maximumWidth:screenWidth-60 forViewController:self.leftTab];
    [menuBtn addTarget:self action:@selector(startPresentationMode) forControlEvents:UIControlEventTouchDown];
    contentList = [db getBoss:@"1"];
    [tab reloadData];
}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contentList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    UIImageView *bImg = (UIImageView*)[cell viewWithTag:1];
    UILabel *nameLab = (UILabel*)[cell viewWithTag:2];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        //cell.textLabel.frame = CGRectMake(70, 10, screenWidth-80, 50);
        //cell.imageView.frame=CGRectMake(10, 10, 50, 50);
        //[cell.imageView.layer setCornerRadius:25];
        cell.backgroundColor=[Common colorWithHexString:@"eb4f38"];
    }
    if(bImg==nil){
        bImg =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [bImg.layer setCornerRadius:25];
        [bImg.layer setMasksToBounds:YES];
        bImg.backgroundColor = [UIColor whiteColor];
        [cell addSubview:bImg];
        bImg.tag=1;
    }
    if(nameLab==nil){
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, screenWidth-80, 50)];
        nameLab.textColor=[UIColor whiteColor];
        [cell addSubview:nameLab];
        nameLab.tag=2;
    }
    
    BossBean *temp = [contentList objectAtIndex:indexPath.row];
    if(temp){
        nameLab.text = temp.name;
        //cell.imageView.image = [UIImage imageNamed:temp.image];
        bImg.image = [UIImage imageNamed:temp.image];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BossBean *temp = [contentList objectAtIndex:indexPath.row];
    if(![temp.image isEqualToString:bossBean.image]){
        bossBean=temp;
        [self refreshPage];
    }
    [self enterPresentationModeForViewController:PKRevealControllerShowsFrontViewController
                                        animated:YES
                                      completion:nil ];
}

-(void)refreshPage{
    UIImage *temp = [UIImage imageNamed:bossBean.image];
    CGFloat width = temp.size.width;
    if(temp.size.width<temp.size.height){
        width = temp.size.height;
    }
    
    CGFloat yp = self.view.center.x-width/2-10;
    bossImageView.frame=CGRectMake(yp, 100, width+20, width+20);
    bossImageView.image = temp;
    [bossImageView.layer setCornerRadius:(bossImageView.frame.size.width/2)];
    nameLabel.text = bossBean.name;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
    CGSize size = [bossBean.content sizeWithAttributes:attributes];
    CGFloat line = size.width/screenWidth;
    if(line<1){
        line=1;
    }else{
        NSString *th = [NSString stringWithFormat:@"%0.0f",line];
        NSInteger t = th.integerValue;
        if(line-t>0){
            line  = t+1;
        }else{
            line = t;
        }
    }
    contentLabel.frame = CGRectMake(10, 140+width, screenWidth-20, line*24);
    contentLabel.text = bossBean.content;
}

-(IBAction)presetMenu:(id)sender{
    [self showViewController:self.leftViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)startPresentationMode
{
    NSLog(@"clicked");
    if (![self isPresentationModeActive])
    {
        [self enterPresentationModeForViewController:PKRevealControllerShowsLeftViewControllerInPresentationMode
                                            animated:YES
                                          completion:nil ];
    }
    else
    {
        [self resignPresentationModeEntirely:NO animated:YES completion:nil];
    }
}

@end
