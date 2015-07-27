//
//  SmallActivity.m
//  Isaac
//
//  Created by Shuwei on 15/7/25.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "SmallActivity.h"
#import "DBHelper.h"
#import "BossBean.h"


@interface SmallActivity ()

@end

@implementation SmallActivity{
    NSMutableArray *list;
    DBHelper *db;
    CGFloat screenWidth;
    NSDictionary *attributes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    list= [[NSMutableArray alloc] init];
    db = [DBHelper sharedInstance];
    screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    UIImageView *bImg = (UIImageView*)[cell viewWithTag:1];
    UILabel *nameLab = (UILabel*)[cell viewWithTag:2];
    UILabel *contLab = (UILabel*)[cell viewWithTag:3];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    if(bImg==nil){
        bImg =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [bImg.layer setCornerRadius:25];
        [bImg.layer setMasksToBounds:YES];
        [cell addSubview:bImg];
        bImg.tag=1;
    }
    if(nameLab==nil){
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, screenWidth-60, 40)];
        [cell addSubview:nameLab];
        nameLab.tag=2;
    }
    if(contLab==nil){
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 60, screenWidth-70, 50)];
        contLab.numberOfLines=0;
        contLab.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:nameLab];
        nameLab.tag=3;
    }
    BossBean *temp = [list objectAtIndex:indexPath.row];
    if(temp){
        nameLab.text = temp.name;
        //cell.imageView.image = [UIImage imageNamed:temp.image];
        bImg.image = [UIImage imageNamed:temp.image];
        CGSize size=[temp.content sizeWithAttributes:attributes];
        CGFloat line = size.width/(screenWidth-70);
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
        bImg.frame = CGRectMake(10, 10+line*size.height, 40, 40);
        contLab.text = temp.content;
        [contLab setFont:[UIFont systemFontOfSize:16.0]];
        contLab.frame = CGRectMake(60, 60, screenWidth-70, line*size.height+40);
    }

    return cell;
}


-(void)loadData{
    list = [db getSmall:@"1"];
    [self.tableView reloadData];
}
@end
