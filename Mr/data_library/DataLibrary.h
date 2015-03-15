//
//  DataLibrary.h
//  Mr
//
//  Created by FanFamily on 15/3/14.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSaver.h"
#import "DataQuerier.h"
#import "DataPathProvider.h"

@interface DataLibrary : NSObject

+ (instancetype)sharedInstace;
+ (DataSaver *)saver;
+ (DataQuerier *)querier;
+ (DataPathProvider *)pathProvider;

@end
