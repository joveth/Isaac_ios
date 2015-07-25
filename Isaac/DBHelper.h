//
//  DBHelper.h
//  Isaac
//
//  Created by Shuwei on 15/7/2.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBHelper : NSObject
+(id)sharedInstance;
-(BOOL)openDB;
-(void)initData;
-(NSInteger)getCnt;
-(NSMutableArray *)getIsaacs:(NSString *)offset;
-(NSMutableArray *)getIsaacsByKey:(NSString *)keyword;
-(NSMutableArray *)getIsaacsByType:(NSString *)type;
-(NSMutableArray *)getBoss:(NSString *)offset;
-(NSMutableArray *)getSmall:(NSString *)offset;

@end
