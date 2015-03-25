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
@property (nonatomic, copy) SyncWorkBlock syncBlock;
@property (nonatomic, copy) AsyncWorkBlock asyncBlock;

@end

@implementation MrWork

- (instancetype)initWithSyncBlock:(SyncWorkBlock)block
{
    self = [super init];
    if (self) {
        _syncBlock = block;
    }
    return self;
}

- (instancetype)initWithAsyncBlock:(AsyncWorkBlock)block
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
        self.isFinish = YES;
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

- (void)setSyncWorkBlock:(SyncWorkBlock)block
{
    self.syncBlock = block;
}

- (SyncWorkBlock)getSyncWorkBlock:(SyncWorkBlock)block
{
    return block;
}

- (void)setAsyncWorkBlock:(AsyncWorkBlock)block
{
    self.asyncBlock = block;
}

- (AsyncWorkBlock)getAsyncWorkBlock:(AsyncWorkBlock)block
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
