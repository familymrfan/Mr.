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
#import "NSRunLoop+blockRun.h"

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

- (void)testObj
{
    TestObject* tObj = [[TestObject alloc] init];
    tObj.stringValue = @"string";
    tObj.numberValue = @100;
    
    XCTAssertTrue([tObj.stringValue isEqualToString:@"string"]);
    XCTAssertTrue([tObj.numberValue isEqualToNumber:@100]);
    XCTAssertTrue(tObj.keyNames.count == 2);
    
    [tObj.keyNames enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            XCTAssertTrue([key isEqualToString:@"stringValue"]);
            XCTAssertNotNil([tObj.keyname2Value objectForKey:key]);
            XCTAssertTrue([[tObj.keyname2Value objectForKey:key] isEqual:@"string"]);
            XCTAssertTrue([tObj.keyname2Class objectForKey:key] == [NSString class]);
        } else if (idx == 1) {
            XCTAssertTrue([key isEqualToString:@"numberValue"]);
            XCTAssertNotNil([tObj.keyname2Value objectForKey:key]);
            XCTAssertTrue([[tObj.keyname2Value objectForKey:key] isEqual:@100]);
            XCTAssertTrue([tObj.keyname2Class objectForKey:key] == [NSNumber class]);
        }
    }];
}

- (void)testObjSave
{
    /*TestObject* tObj = [[TestObject alloc] init];
    tObj.stringValue = @"string";
    tObj.numberValue = @100;
    
    [[DataLibrary saver] save:tObj];*/
}

- (void)testPipeManagerDoWork
{
    __block NSInteger i = 0;
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"async method"];
    
    [PipeManager asyncDoWork:^(BOOL isCancel) {
        i++;
        [completionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    XCTAssertEqual(i, 1);
    
    [PipeManager asyncDoWorkInMainPipe:^(BOOL isCancel) {
        XCTAssertEqual([NSThread currentThread], [NSThread mainThread]);
    }];
    
    completionExpectation = [self expectationWithDescription:@"async method"];
    
    [PipeManager asyncDoWork:^(BOOL isCancel) {
        i++;
        [PipeManager asyncDoWork:^(BOOL isCancel) {
            i++;
            [completionExpectation fulfill];
            
            MrWork* work = [PipeManager asyncDoWorkInMainPipe:^(BOOL isCancel) {
                XCTAssertEqual(isCancel, YES);
                XCTAssertEqual([NSThread currentThread], [NSThread mainThread]);
            }];
            [work cancel];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    XCTAssertEqual(i, 3);
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
}

- (void)testQueuePipe
{
    __block NSInteger i = 0;
    QueuePipe* pipe = [PipeManager createQueuePipe];
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"async method"];
    [pipe addWorkBlock:^(BOOL isCancel) {
        i++;
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    XCTAssertEqual(i, 1);
    
    [pipe addWorkBlock:^(BOOL isCancel) {
        [PipeManager asyncDoWork:^(BOOL isCancel) {
            [[NSRunLoop currentRunLoop] blockRun:1];
            i = i * 3;
        }];
    }];
    
    [pipe addWorkBlock:^(BOOL isCancel) {
        i = i % 3;
    }];
    
    [pipe wait];
    
    XCTAssertEqual(i, 1);

    __block NSInteger j = 1;
    
    [pipe addWaitFinishWorkBlock:^(BOOL isCancel, finishWorkBlock finishBlock) {
        [PipeManager asyncDoWork:^(BOOL isCancel) {
            [[NSRunLoop currentRunLoop] blockRun:1];
            j = j * 3;
            finishBlock();
        }];
    }];
    
    [pipe addWorkBlock:^(BOOL isCancel) {
        j = j % 3;
    }];
    
    [pipe wait];
    
    XCTAssertEqual(j, 0);
}

/*- (void)testExample {
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
    
    MrWork* work = [PipeManager doSyncWorkInMainPipe:^(BOOL isCancel) {
        if (isCancel) {
            NSLog(@"work has been canceled !");
        } else {
            NSLog(@"work in main queue ! thread:%@", [NSThread currentThread]);
        }
    }];
    [work cancel];
    
    [PipeManager doSyncWork:^(BOOL isCancel) {
        NSLog(@"work in other queue ! thread:%@", [NSThread currentThread]);
    }];
    
    QueuePipe* pipe = [PipeManager createQueuePipe];
    [pipe addSyncWorkBlock:^(BOOL isCancel) {
        NSLog(@"work1 in queue pipe ! thread:%@", [NSThread currentThread]);
    }];
    
    [pipe addAsyncWorkBlock:^(BOOL isCancel, finishWorkBlock finishBlock) {
        NSLog(@"work1.5 in queue pipe ! thread:%@", [NSThread currentThread]);
        finishBlock();
    }];
    
    [pipe addSyncWorkBlock:^(BOOL isCancel) {
        NSLog(@"work2 in queue pipe ! thread:%@", [NSThread currentThread]);
    }];
    
    IgnorePipe* ignorePipe = [PipeManager createIgnorePipe];
    
    [ignorePipe ready];
    
    [ignorePipe addSyncWorkBlock:^(BOOL isCancel) {
        NSLog(@"work4 in ignore pipe, the first work ! thread:%@", [NSThread currentThread]);
    }];
    
    for (NSInteger i = 0; i < 100; i++) {
        [ignorePipe addSyncWorkBlock:^(BOOL isCancel) {
            NSLog(@"work4 in ignore pipe ! thread:%@", [NSThread currentThread]);
        }];
    }
    
    [ignorePipe flush];
    
    ReplacePipe* replacePipe = [PipeManager createReplacePipe];
    
    [replacePipe ready];
    
    for (NSInteger i = 0; i < 100; i++) {
        [replacePipe addSyncWorkBlock:^(BOOL isCancel) {
            if (isCancel) {
                NSLog(@"work6 canceled in replace pipe ! thread:%@", [NSThread currentThread]);
            } else {
                NSLog(@"work6 in replace pipe ! thread:%@", [NSThread currentThread]);
            }
        }];
    }
    
    [replacePipe addSyncWorkBlock:^(BOOL isCancel) {
        NSLog(@"work6 in replace pipe, the end work ! thread:%@", [NSThread currentThread]);
    }];
    
    [replacePipe flush];
    
    [[NSRunLoop currentRunLoop] run];
}*/

@end
