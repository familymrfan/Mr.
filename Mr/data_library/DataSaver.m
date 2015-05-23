//
//  DataSaver.m
//  Mr
//
//  Created by FanFamily on 15/3/14.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "DataSaver.h"
#import "DataLibrary.h"

@interface DataSaver ()

@property (nonatomic) FMDatabase* database;

@property (nonatomic) NSDictionary* fieldTypeMap;

@end

@implementation DataSaver

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fieldTypeMap = @{@"NSString":@"TEXT", @"NSNumber":@"INTEGER", @"NSData":@"BLOB", @"NSDate":@"TEXT"};
    }
    return self;
}

- (void)createTableIfNeed:(MrObject *)object
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DataLibrary runInLock:object.class block:^{
            __block NSMutableString* sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", NSStringFromClass(object.class)];
            NSString* feild = [NSString stringWithFormat:@"%@ %@,", @"rowId", @"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"];
            [sql appendString:feild];
            [[object keyname2Class] enumerateKeysAndObjectsUsingBlock:^(NSString* keyname, Class class, BOOL *stop) {
                NSString* fieldType = [self.fieldTypeMap objectForKey:NSStringFromClass(class)];
                NSAssert(fieldType, @"fieldType %@ is not support", class);
                if (fieldType) {
                    NSString* feild = [NSString stringWithFormat:@"%@ %@,", keyname, fieldType];
                    [sql appendString:feild];
                }
            }];
            [sql deleteCharactersInRange:NSMakeRange(sql.length-1, 1)];
            [sql appendString:@")"];
            BOOL success = [self.database executeUpdate:sql];
            NSError *error = [self.database lastError];
            if (!success) {
                NSLog(@"create table %@ failed, error is %@, sql is %@", NSStringFromClass(object.class), error, sql);
            }
        }];
    });
}

- (void)save:(MrObject *)object
{
    [self createTableIfNeed:object];
    
    [DataLibrary runInLock:object.class block:^{
        NSMutableArray* marks = [NSMutableArray arrayWithCapacity:object.keyNames.count];
        for (NSInteger i=0; i<object.keyname2Value.allKeys.count; i++) {
            [marks addObject:@"?"];
        }
        NSString* sql = nil;
        // 如果rowId为空意味着添加
        if (object.rowId == nil) {
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", object.class, [object.keyname2Value.allKeys componentsJoinedByString:@", "],  [marks componentsJoinedByString:@", "]];
            BOOL success = [self.database executeUpdate:sql withArgumentsInArray:object.keyname2Value.allValues];
            NSError *error = [self.database lastError];
            if (!success) {
                NSLog(@"add object %@ failed, error is %@, sql is %@", object.class, error, sql);
            } else {
                object.rowId = [NSNumber numberWithLongLong:[self.database lastInsertRowId]];
            }
        } else {
            __block NSMutableArray* sets = [NSMutableArray array];
            [object.keyname2Value.allKeys enumerateObjectsUsingBlock:^(NSString* keyname, NSUInteger idx, BOOL *stop) {
                // 如果value为nil不会产生任何修改
                if ([object.keyname2Value objectForKey:keyname]) {
                    [sets addObject:[NSString stringWithFormat:@"%@=?", keyname]];
                }
            }];
            sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE rowId = %@", object.class, [sets componentsJoinedByString:@","], object.rowId];
            BOOL success = [self.database executeUpdate:sql withArgumentsInArray:object.keyname2Value.allValues];
            NSError *error = [self.database lastError];
            if (!success) {
                NSLog(@"update object %@ failed, error is %@, sql is %@", object.class, error, sql);
            }
        }
    }];
}

- (void)remove:(Class)class rowId:(NSNumber *)rowId
{
    [DataLibrary runInLock:class block:^{
        NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE rowId = %@", class, rowId];
        BOOL success = [self.database executeUpdate:sql];
        NSError *error = [self.database lastError];
        if (!success) {
            NSLog(@"update object %@ failed, error is %@, sql is %@", class, error, sql);
        }
    }];
}

@end
