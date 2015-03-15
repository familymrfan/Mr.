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
}

@end
