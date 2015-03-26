//
//  MrWork.m
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MrWork.h"
#import "NotifyBundle.h"

@interface MrWork ()

@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) BOOL isExecute;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, copy) WorkBlock syncBlock;
@property (nonatomic, copy) WaitFinishWorkBlock asyncBlock;

@end

@implementation MrWork

- (instancetype)initWithWorkBlock:(WorkBlock)block
{
    self = [super init];
    if (self) {
        _syncBlock = block;
    }
    return self;
}

- (instancetype)initWithWaitFinishWorkBlock:(WaitFinishWorkBlock)block
{
    self = [super init];
    if (self) {
        _asyncBlock = block;
    }
    return self;
}

- (void)attachNotifyBundle:(NotifyBundle *)notify
{
    
}

- (void)doit
{
    if (self.syncBlock && !self.isFinish) {
        self.isExecute = YES;
        self.syncBlock([self isCancel]);
        self.isExecute = NO;
        [self finish];
    } else if (self.asyncBlock && !self.isFinish) {
        self.isExecute = YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        self.asyncBlock([self isCancel], ^(){
            [self finish];
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
}

- (void)setWorkBlock:(WorkBlock)block
{
    self.syncBlock = block;
}

- (WorkBlock)getWorkBlock:(WorkBlock)block
{
    return block;
}

- (void)setWaitFinishWorkBlock:(WaitFinishWorkBlock)block
{
    self.asyncBlock = block;
}

- (WaitFinishWorkBlock)getWaitFinishWorkBlock:(WaitFinishWorkBlock)block
{
    return self.asyncBlock;
}

- (void)cancel
{
    self.isCancel = YES;
}

// 标记工作已完成
- (void)finish;
{
    self.isFinish = YES;
}

@end
