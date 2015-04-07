//
//  Pipe.h
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MrWork.h"

@interface MrQueue : NSObject

- (instancetype)initWithInitResult:(id)initResult;

// 任务入队
- (void)enqueueWork:(MrWork *)work;
- (MrWork *)enqueueWorkBlock:(WorkBlock)block;

// 还没有执行的任务挂起，待以后执行
- (void)suspend;

// 待执行的任务恢复执行
- (void)resume;

// 获取所有队列中的任务
- (NSArray *)getWorks;

// 排在之前的工作
- (id)preWork:(MrWork* )work;

// 之前工作的产出结果
- (id)preWorkResult:(MrWork *)work;

// 运作执行单元
- (void)run;

// 等待完成
- (void)wait;

// 返回初始值
- (id)getInitResult;

@end
