//
//  DataQuerier.m
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "DataQuerier.h"
#import "DataLibrary.h"
#import "MrObject.h"

@interface DataQuerier ()

@property (nonatomic) FMDatabase* database;

@end

@implementation DataQuerier

- (NSArray *)query:(Class)class
{
    return [self query:class otherCondition:nil withParam:nil];
}

- (NSArray *)query:(Class)class otherCondition:(NSString *)condition withParam:(NSArray*)param
{
    __block NSMutableArray* objects = [NSMutableArray array];
    [DataLibrary runInLock:class block:^{
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@", class];
        if (condition != nil || param != nil) {
            sql = [sql stringByAppendingFormat:@" %@", condition];;
        }
        FMResultSet* queryResult = [self.database executeQuery:sql withArgumentsInArray:param];
        if (queryResult == nil) {
            NSLog(@"query %@ failed, error is %@, sql is %@", class, self.database.lastError, sql);
        }
        while (queryResult.next) {
            id object = [[class alloc] init];
            NSAssert([object isKindOfClass:[MrObject class]], @"query class must kind of MrObject");
            [[object keyNames] enumerateObjectsUsingBlock:^(NSString* keyname, NSUInteger idx, BOOL *stop) {
                id value = [queryResult objectForColumnName:keyname];
                if ([[object keyname2Class] objectForKey:keyname] == [NSDate class]) {
                    value = [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
                }
                [object setValue:value forKey:keyname];
            }];
            [objects addObject:object];
        }
    }];
    return objects;
}

@end
