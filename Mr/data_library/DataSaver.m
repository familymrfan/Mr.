//
//  DataSaver.m
//  Mr
//
//  Created by FanFamily on 15/3/14.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "DataSaver.h"

@interface DataSaver ()

@property (nonatomic) FMDatabase* dabase;
@property (nonatomic) NSDictionary* tbName2DbLock;
@property (nonatomic) NSDictionary* fieldTypeMap;

@end

@implementation DataSaver

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tbName2DbLock = [NSMutableDictionary dictionary];
        self.fieldTypeMap = @{@"NSString":@"TEXT", @"NSNumber":@"INTEGER", @"NSData":@"BLOB", @"NSDate":@"TEXT"};
    }
    return self;
}

- (void)setDatabase:(FMDatabase *)database
{
    self.dabase = database;
}

- (void)createTableIfNeed:(MrObject *)object
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLock* lock = [[NSLock alloc] init];
        [self.tbName2DbLock setValue:lock forKey:NSStringFromClass(object.class)];
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
        BOOL success = [self.dabase executeUpdate:sql];
        NSError *error = [self.dabase lastError];
        if (!success) {
            NSLog(@"create table %@ failed, error is %@, sql is %@", NSStringFromClass(object.class), error, sql);
        }
    });
}

- (void)save:(MrObject *)object
{
    [self createTableIfNeed:object];
    
    
}

@end
