//
//  AboutSomething.m
//  Isaac
//
//  Created by Shuwei on 15/7/28.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "AboutSomething.h"
#import "ShareData.h"
#import "DBHelper.h"
#import "Common.h"
#import "IsaacBean.h"

@interface AboutSomething ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;

@end

@implementation AboutSomething{
    NSString *type;
    NSMutableArray *list;
    DBHelper *db;
    CGFloat screenWidth;
    NSDictionary *attributes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    type = [ShareData shareInstance].type;
    if(type==nil){
        type=@"1";
    }
    self.title = @"关于基础掉落";
    if([type isEqualToString:@"2"]){
        self.title = @"关于地形物体";
    }else if([type isEqualToString:@"3"]){
        self.title = @"关于房间的说";
    }
    
    list = [[NSMutableArray alloc] init];
    db = [DBHelper sharedInstance];
    screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
    [self loadData];
}
- (IBAction)onclick:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
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
        [cell addSubview:bImg];
        bImg.tag=1;
    }
    if(nameLab==nil){
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, screenWidth-60, 22)];
        nameLab.textColor=[UIColor blackColor];
        [cell addSubview:nameLab];
        nameLab.tag=2;
    }
    if(contLab==nil){
        contLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 42, screenWidth-70, 50)];
        contLab.numberOfLines=0;
        contLab.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:contLab];
        contLab.tag=3;
    }
    IsaacBean *temp = [list objectAtIndex:indexPath.row];
    if(temp){
        nameLab.text = [NSString stringWithFormat:@"%@(%@)",temp.name,temp.enName];
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
        bImg.frame = CGRectMake(10, line*size.height/2+20, 40, 40);
        contLab.text = temp.content;
        [contLab setFont:[UIFont systemFontOfSize:16.0]];
        contLab.frame = CGRectMake(60, 36, screenWidth-70, line*size.height+24);
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]>0){
        IsaacBean *temp = [list objectAtIndex:indexPath.row];
        if(temp){
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
            return line*size.height+62;
        }
    }
    return 44;
}
-(void)loadData{
    list = [db getOtherByType:type];
    [self.tableView reloadData];
}

@end
