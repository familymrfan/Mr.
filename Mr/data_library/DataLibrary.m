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
@property (nonatomic) NSDictionary* tbName2DbLock;

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
        self.tbName2DbLock = [NSMutableDictionary dictionary];
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

+ (void)runInLock:(Class)class block:(void(^)())block
{
    DataLibrary* dataLibrary = [DataLibrary sharedInstace];
    NSLock* lock = [dataLibrary.tbName2DbLock objectForKey:NSStringFromClass(class)];
    if (lock == nil) {
        NSLock* lock = [[NSLock alloc] init];
        [lock lock];
        [dataLibrary.tbName2DbLock setValue:lock forKey:NSStringFromClass(class)];
        if (block) {
            block();
        }
        [lock unlock];
        return ;
    }
    [lock lock];
    if (block) {
        block();
    }
    [lock unlock];
}

@end
