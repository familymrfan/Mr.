//
//  MrTests.m
//  MrTests
//
//  Created by FanFamily on 15/3/14.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DataLibrary.h"
#import "MrObject.h"
#import "PipeManager.h"

@interface TestObject : MrObject

@property (nonatomic) NSString* stringValue;
@property (nonatomic) NSNumber* numberValue;

@end

@implementation TestObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"number:%@, string:%@", self.numberValue, self.stringValue];
}

@end

@interface MrTests : XCTestCase

@end

@implementation MrTests

- (void)setUp {
    [super setUp];
    NSLog(@"-------------------------------------");
}

- (void)tearDown {
    NSLog(@"-------------------------------------");
    [super tearDown];
}

- (void)testExample {
    TestObject* obj = [[TestObject alloc] init];
    //obj.rowId = @3;
    obj.stringValue = @"string update";
    obj.numberValue = @100;
    NSLog(@"TestObject keyNames %@", [obj keyNames]);
    NSLog(@"TestObject keyname2Value %@", [obj keyname2Value]);
    NSLog(@"TestObject keyname2Class %@", [obj keyname2Class]);
    
    [[DataLibrary saver] save:obj];
    [[DataLibrary saver] remove:obj.class rowId:@3];
    
    NSLog(@"query %@", [[DataLibrary querier] query:obj.class]);
    NSLog(@"query condition %@", [[DataLibrary querier] query:obj.class otherCondition:@"WHERE rowId = 4" withParam:nil]);
    
    MrWork* work = [PipeManager doWorkInMainPipe:^(BOOL isCancel) {
        if (isCancel) {
            NSLog(@"work has been canceled !");
        } else {
            NSLog(@"work in main queue ! thread:%@", [NSThread currentThread]);
        }
    }];
    [work cancel];
    
    [PipeManager doWork:^(BOOL isCancel) {
        NSLog(@"work in other queue ! thread:%@", [NSThread currentThread]);
    }];
    
    QueuePipe* pipe = [PipeManager createQueuePipe];
    [pipe addWorkBlock:^(BOOL isCancel) {
        NSLog(@"work1 in queue pipe ! thread:%@", [NSThread currentThread]);
    }];
    [pipe addWorkBlock:^(BOOL isCancel) {
        NSLog(@"work2 in queue pipe ! thread:%@", [NSThread currentThread]);
    }];
    
    [pipe flush];
    
    [pipe readyWorkBlock:^(BOOL isCancel) {
        NSLog(@"work3 in queue pipe ! thread:%@", [NSThread currentThread]);
    }];
    
    [pipe flush];
    
    IgnorePipe* ignorePipe = [PipeManager createIgnorePipe];
    
    NSArray* array = @[@1, @2, @3, @4, @5];
    [array bk_each:^(id obj) {
        [ignorePipe addWorkBlock:^(BOOL isCancel) {
            NSLog(@"work4 in ignore pipe ! thread:%@", [NSThread currentThread]);
        }];
    }];
        
    ReplacePipe* replacePipe = [PipeManager createReplacePipe];
    
    array = @[@1, @2];
    [array bk_each:^(id obj) {
        [replacePipe addWorkBlock:^(BOOL isCancel) {
            if (isCancel) {
                NSLog(@"work6 canceled in replace pipe ! thread:%@", [NSThread currentThread]);
            } else {
                NSLog(@"work6 in replace pipe ! thread:%@", [NSThread currentThread]);
            }
        }];
    }];
    
    [[NSRunLoop currentRunLoop] run];
}

@end
