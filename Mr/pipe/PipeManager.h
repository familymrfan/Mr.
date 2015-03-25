//
//  PipeManager.h
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainPipe.h"
#import "QueuePipe.h"
#import "IgnorePipe.h"
#import "ReplacePipe.h"

@interface PipeManager : NSObject

+ (MrWork *)doSyncWork:(SyncWorkBlock)block;
+ (MrWork *)doSyncWorkInMainPipe:(SyncWorkBlock)block;

+ (MrWork *)doAyncWork:(AsyncWorkBlock)block;
+ (MrWork *)doAyncWorkInMainPipe:(AsyncWorkBlock)block;


// 获取main pipe只有一个
+ (MainPipe *)mainPipe;

// 创建
+ (QueuePipe *)createQueuePipe;
+ (IgnorePipe *)createIgnorePipe;
+ (ReplacePipe *)createReplacePipe;

@end
