//
//  MrWork.m
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MrWork.h"

@interface MrWork ()

@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) BOOL isExecute;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, copy) WorkBlock internalBlock;
@property (nonatomic, copy) WorkBlock workBlock;
@property (nonatomic, copy) dispatch_semaphore_t semaphore;
@property (nonatomic) id result;

@end

@implementation MrWork

- (instancetype)initWithWorkBlock:(WorkBlock)block
{
    self = [super init];
    if (self) {
        [self setWorkBlock:block];
    }
    return self;
}

- (void)run
{
    [self run:nil];
}

- (void)run:(id)result
{
    if (self.workBlock && !self.isFinish) {
        self.isExecute = YES;
        self.workBlock(result, [self isCancel], ^(id result){
            [self finish];
            self.result = result;
        });
    }
}

- (void)setWorkBlock:(WorkBlock)block
{
    _internalBlock = block;
    __weak typeof(self) weakSelf = self;
    _workBlock = ^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.internalBlock(result, isCancel, finishBlock);
    };
}

- (WorkBlock)getWorkBlock
{
    return _workBlock;
}

- (void)cancel
{
    self.isCancel = YES;
}

// 标记工作已完成
- (void)finish
{
    self.internalBlock = nil;
    self.workBlock = nil;
    self.isExecute = NO;
    self.isFinish = YES;
    if (self.semaphore) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_signal(self.semaphore);
        });
    }
}

- (void)wait
{
    if (!self.isFinish) {
        self.semaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    }
}

- (id)finishResult
{
    return self.result;
}

@end
