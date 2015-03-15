//
//  DataSaver.h
//  Mr
//
//  Created by FanFamily on 15/3/14.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MrObject.h"
#import "FMDatabase.h"

@interface DataSaver : NSObject

- (void)setDatabase:(FMDatabase *)database;
- (void)save:(MrObject *)object;

@end
