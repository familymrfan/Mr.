//
//  MrWork.h
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WorkBlock)(BOOL isCancel);
typedef void(^finishWorkBlock)();
typedef void(^WaitFinishWorkBlock)(BOOL isCancel, finishWorkBlock finishBlock);

@class NotifyBundle;
@interface MrWork : NSObject

- (instancetype)initWithWorkBlock:(WorkBlock)block;
- (instancetype)initWithWaitFinishWorkBlock:(WaitFinishWorkBlock)block;

// 添加到通知束当中，当这些工作都完成的时候产生这个通知work
- (void)attachNotifyBundle:(NotifyBundle *)notify;

// 设置同步工作
- (void)setWorkBlock:(WorkBlock)block;
- (WorkBlock)getWorkBlock:(WorkBlock)block;

// 设置异步工作
- (void)setWaitFinishWorkBlock:(WaitFinishWorkBlock)block;
- (WaitFinishWorkBlock)getWaitFinishWorkBlock:(WaitFinishWorkBlock)block;

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
