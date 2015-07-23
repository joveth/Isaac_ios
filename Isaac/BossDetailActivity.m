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

@interface BossDetailActivity ()

@end

@implementation BossDetailActivity{
    UIView *topView;
    UIImageView *bossImageView;
    UILabel *contentLabel;
    UILabel *nameLabel;
    UILabel *enLabel;
    UILabel *scoreLabel;
    BossBean *bossBean;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bossBean = [ShareData shareInstance].bossBean;
    if(!bossBean){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    UIImage *temp = [UIImage imageNamed:bossBean.image];
    CGFloat width = temp.size.width;
    if(temp.size.width<temp.size.height){
        width = temp.size.height;
    }
    CGFloat yp = self.view.center.x-width/2-10;
    bossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(yp, 100, width+20, width+20)];
    bossImageView.backgroundColor = [UIColor whiteColor];
    bossImageView.image = temp;
    bossImageView.
    [bossImageView.layer setCornerRadius:(bossImageView.frame.size.width/2)];
    [bossImageView.layer setMasksToBounds:YES];
    [self.view setBackgroundColor:[Common colorWithHexString:@"e0e0e0"]];
    [self.view addSubview:bossImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
