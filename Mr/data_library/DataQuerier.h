//
//  DataQuerier.h
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataQuerier : NSObject

- (void)setDatabase:(FMDatabase *)database;
- (NSArray *)query:(Class)class;
- (NSArray *)query:(Class)class otherCondition:(NSString *)condition withParam:(NSArray*)param;

@end
