//
//  ShareData.h
//  Isaac
//
//  Created by Shuwei on 15/7/23.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BossBean.h"

@interface ShareData : NSObject

@property(atomic,retain) BossBean *bossBean;
+(ShareData *) shareInstance;
@end
