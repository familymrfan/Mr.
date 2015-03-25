//
//  PipeManager.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "PipeManager.h"
#import "Macro.h"

@implementation PipeManager

+ (MrWork *)doSyncWork:(SyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setSyncWorkBlock:block];
    [[self createQueuePipe] addWork:work];
    return work;
}

+ (MrWork *)doSyncWorkInMainPipe:(SyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setSyncWorkBlock:block];
    [[self mainPipe] addWork:work];
    return work;
}

+ (MrWork *)doAyncWork:(AsyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setAsyncWorkBlock:block];
    [[self createQueuePipe] addWork:work];
    return work;
}

+ (MrWork *)doAyncWorkInMainPipe:(AsyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setAsyncWorkBlock:block];
    [[self mainPipe] addWork:work];
    return work;
}


+ (MainPipe *)mainPipe
{
    SHARED_OBJECT(MainPipe);
}

// 创建
+ (QueuePipe *)createQueuePipe
{
    return [QueuePipe new];
}

+ (IgnorePipe *)createIgnorePipe
{
    return [IgnorePipe new];
}

+ (ReplacePipe *)createReplacePipe
{
    return [ReplacePipe new];
}

@end
