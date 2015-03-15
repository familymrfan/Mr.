//
//  DataLibrary.m
//  Mr
//
//  Created by FanFamily on 15/3/14.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "DataLibrary.h"
#import "FMDatabase.h"
#import "Macro.h"

@interface DataLibrary ()

@property (nonatomic) FMDatabase* database;

@end

@implementation DataLibrary

+ (instancetype)sharedInstace
{
    SHARED_OBJECT(DataLibrary);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* documentDirectory = [[DataLibrary pathProvider] documentDirectory];
        NSString* fullPath = [documentDirectory stringByAppendingPathComponent:@"Mr.db"];
        NSLog(@"database full path is %@", fullPath);
        FMDatabase* dataBase = [FMDatabase databaseWithPath:fullPath];
        if (dataBase == nil || ![dataBase open]) {
            NSLog(@"create database failed !");
        } else {
            self.database = dataBase;
        }
    }
    return self;
}

+ (DataSaver *)saver
{
    static DataSaver* once = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        once = [[DataSaver alloc] init];
        [once setDatabase:[DataLibrary sharedInstace].database];
    });
    return once;
}

+ (DataQuerier *)querier
{
    static DataQuerier* once = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        once = [[DataQuerier alloc] init];
        [once setDatabase:[DataLibrary sharedInstace].database];
    });
    return once;
}

+ (DataPathProvider *)pathProvider
{
    SHARED_OBJECT(DataPathProvider);
}

@end
