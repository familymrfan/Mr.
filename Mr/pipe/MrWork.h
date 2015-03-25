//
//  MrWork.h
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyBundle.h"

typedef void(^SyncWorkBlock)(BOOL isCancel);
typedef void(^finishWorkBlock)();
typedef void(^AsyncWorkBlock)(BOOL isCancel, finishWorkBlock finishBlock);

@interface MrWork : NSObject

- (instancetype)initWithSyncBlock:(SyncWorkBlock)block;
- (instancetype)initWithAsyncBlock:(AsyncWorkBlock)block;

// 添加到通知束当中，当这些工作都完成的时候产生这个通知work
- (void)attachNotifyBundle:(NotifyBundle *)notify;

// 设置同步工作
- (void)setSyncWorkBlock:(SyncWorkBlock)block;
- (SyncWorkBlock)getSyncWorkBlock:(SyncWorkBlock)block;

// 设置异步工作
- (void)setAsyncWorkBlock:(AsyncWorkBlock)block;
- (AsyncWorkBlock)getAsyncWorkBlock:(AsyncWorkBlock)block;

// do work
- (void)doit;

// 是否正在执行
- (BOOL)isExecute;

// 让工作不再继续
- (void)cancel;
- (BOOL)isCancel;

// 标记工作已完成
- (void)finish;
- (BOOL)isFinish;

@end
