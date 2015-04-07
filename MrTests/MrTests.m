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
#import "QueueManager.h"
#import "MrNotifyCenter.h"
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

- (void)testQueueManagerDoWork
{
    __block NSInteger i = 0;
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"async method"];
    
    // 直接工作在其他线程，不要忘记调用finish，queue不会释放哦直到work finish
    [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        XCTAssertNotEqual([NSThread currentThread], [NSThread mainThread]);
        i++;
        finishBlock(nil);
        [completionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    XCTAssertEqual(i, 1);
    
    // 传递性
    [QueueManager asyncDoWorkBlockInMainQueue:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        XCTAssertEqual([NSThread currentThread], [NSThread mainThread]);
        finishBlock(@1);
    }];
    
    [QueueManager asyncDoWorkBlockInMainQueue:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        XCTAssertEqual([NSThread currentThread], [NSThread mainThread]);
        XCTAssert([result isEqualToNumber:@1]);
        finishBlock(@2);
    }];
    
    [QueueManager asyncDoWorkBlockInMainQueue:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        XCTAssertEqual([NSThread currentThread], [NSThread mainThread]);
        XCTAssert([result isEqualToNumber:@2]);
        finishBlock(nil);
    }];
    
    completionExpectation = [self expectationWithDescription:@"async method"];
    
    // 可嵌套性
    [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        i++;
        [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
            i++;
            finishBlock(nil);
            [completionExpectation fulfill];
            
            MrWork* work = [QueueManager asyncDoWorkBlockInMainQueue:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
                XCTAssertEqual(isCancel, YES);
                XCTAssertEqual([NSThread currentThread], [NSThread mainThread]);
                finishBlock(nil);
            }];
            [work cancel];
        }];
        finishBlock(nil);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    XCTAssertEqual(i, 3);
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
}

// queue难道不会在出域的时候释放么，请相信你的眼睛
- (void)stackQueue:(NSMutableDictionary *)change
{
    SerializeQueue* queue = [QueueManager createSerializeQueue];
    
    // 传递性
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [change setObject:@"green" forKey:@"color"];
        finishBlock(@"yellow");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [change setObject:result forKey:@"color"];
        finishBlock(@"white");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [change setObject:result forKey:@"color"];
        finishBlock(@"blue");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [change setObject:result forKey:@"color"];
        finishBlock(nil);
    }];
}

// queue 会同步等待所有任务完成
- (void)waitQueue:(NSMutableDictionary *)change
{
    SerializeQueue* queue = [QueueManager createSerializeQueue];
    
    // 传递性
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:@"green" forKey:@"color"];
        finishBlock(@"yellow");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:result forKey:@"color"];
        finishBlock(@"white");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:result forKey:@"color"];
        finishBlock(@"blue");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:result forKey:@"color"];
        finishBlock(nil);
    }];
    
    [queue wait];
}

// 被挂起的queue，我是否可以先去吃饭，然后再工作，是的，这是我们对你的福利
- (void)suspendQueue:(NSMutableDictionary *)change
{
    SerializeQueue* queue = [QueueManager createSerializeQueue];
    
    // 传递性
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:@"green" forKey:@"color"];
        finishBlock(@"yellow");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:result forKey:@"color"];
        finishBlock(@"white");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:result forKey:@"color"];
        finishBlock(@"blue");
    }];
    
    [queue enqueueWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        [change setObject:result forKey:@"color"];
        finishBlock(nil);
    }];
    
    [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:4];
        [queue suspend];
    }];
    
    [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:10];
        [queue resume];
    }];
    
    [queue wait];
}

- (void)testSerializeQueue
{
    NSMutableDictionary* change = [NSMutableDictionary dictionaryWithDictionary:@{@"color":@"red"}];
    [self stackQueue:change];
    
    [[NSRunLoop currentRunLoop] blockRun:2];
    
    NSLog(@"stackQueue test over ");
    
    NSString* color = [change objectForKey:@"color"];
    XCTAssert([color isEqualToString:@"blue"]);
    
    [self waitQueue:change];
    
    color = [change objectForKey:@"color"];
    XCTAssert([color isEqualToString:@"blue"]);
    
    NSLog(@"waitQueue test over ");
    
    [self suspendQueue:change];
    
    color = [change objectForKey:@"color"];
    XCTAssert([color isEqualToString:@"blue"]);
    
    NSLog(@"suspendQueue test over ");
}

// 绑起来，绑起来
- (void)testNotifyBundle
{
    // 单个work绑定
    __block NSInteger i = 0;
    MrWork* work = [[MrWork alloc] initWithWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        i++;
        finishBlock(nil);
    }];
    
    [MrNotifyCenter bindNotifyWithWork:work notifyBlock:^{
        XCTAssertEqual(i, 1);
    }];
    
    [QueueManager asyncDoWork:work];
    
    __block NSInteger j = 0;
    // 多个works绑定
    MrWork* work1 = [[MrWork alloc] initWithWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        j++;
        finishBlock(nil);
    }];

    MrWork* work2 = [[MrWork alloc] initWithWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        j++;
        finishBlock(nil);
    }];

    MrWork* work3 = [[MrWork alloc] initWithWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [[NSRunLoop currentRunLoop] blockRun:2];
        j++;
        finishBlock(nil);
    }];
    
    [MrNotifyCenter bindNotifyWithWorks:@[work1, work2, work3] notifyBlock:^{
        XCTAssertEqual(j, 3);
    }];
    
    [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        [work1 run];
        [work2 run];
        [work3 run];
        finishBlock(nil);
    }];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
}

@end
