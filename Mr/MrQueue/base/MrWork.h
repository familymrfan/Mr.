//
//  MrWork.h
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^finishWorkBlock)(id result);
typedef void(^WorkBlock)(id result, BOOL isCancel, finishWorkBlock finishBlock);

@interface MrWork : NSObject

- (instancetype)initWithWorkBlock:(WorkBlock)block;

- (void)setWorkBlock:(WorkBlock)block;
- (WorkBlock)getWorkBlock;

// do work
- (void)run;
- (void)run:(id)result;

// 是否正在执行
- (BOOL)isExecute;

// 让工作不再继续
- (void)cancel;
- (BOOL)isCancel;

// 标记工作已完成
- (void)finish;
- (BOOL)isFinish;

// 等待完成
- (void)wait;

// 结束后的结果
- (id)finishResult;

@end
