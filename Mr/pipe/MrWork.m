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
@property (nonatomic, copy) WorkBlock block;

@end

@implementation MrWork

- (instancetype)initWithBlock:(WorkBlock)block
{
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

- (void)attachNotifyBundle:(NotifyBundle *)notify
{
    
}

- (void)doit
{
    if (self.block && !self.isFinish) {
        self.isExecute = YES;
        self.block([self isCancel]);
        self.isExecute = NO;
        self.isFinish = YES;
    }
}

- (void)setWorkBlock:(WorkBlock)block
{
    self.block = block;
}

- (WorkBlock)getWorkBlock:(WorkBlock)block
{
    return block;
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
