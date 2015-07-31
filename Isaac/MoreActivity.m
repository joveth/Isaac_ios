//
//  MoreActivity.m
//  Isaac
//
//  Created by jov jov on 7/26/15.
//  Copyright (c) 2015 Shuwei. All rights reserved.
//

#import "MoreActivity.h"
#import "Common.h"
#import "ShareData.h"

@interface MoreActivity ()

@end

@implementation MoreActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[Common colorWithHexString:@"#e0e0e0"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myHeader = [[UIView alloc] init];
    UILabel *myLabel = [[UILabel alloc] init];
    [myLabel setFrame:CGRectMake(8, 0, 200, 10)];
    [myLabel setTag:101];
    [myLabel setAlpha:0.5];
    [myLabel setFont: [UIFont fontWithName:@"Arial" size:14]];
    [myLabel setBackgroundColor:[UIColor clearColor]];
    [myHeader setBackgroundColor:[Common colorWithHexString:@"#e0e0e0"]];
    [myLabel setText:[NSString stringWithFormat:@" "]];
    [myHeader addSubview:myLabel];
    
    return myHeader;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        [ShareData shareInstance].type=[NSString stringWithFormat:@"%ld",(indexPath.row+1)];
        [self performSegueWithIdentifier:@"toDetail" sender:nil];
        return;
    }else if(indexPath.section==1){
        [ShareData shareInstance].type=[NSString stringWithFormat:@"%ld",(indexPath.row+1)];
        [self performSegueWithIdentifier:@"showHtml" sender:nil];
        return;
    }else if(indexPath.section==2){
        [self performSegueWithIdentifier:@"aboutMe" sender:nil];
    }
}
- (IBAction)toMoreMng:(UIStoryboardSegue *)segue
{
    [[segue sourceViewController] class];
}

@end
