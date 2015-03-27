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

+ (void)doWork:(MrWork *)work
{
    [[self createQueuePipe] addWork:work];
}

+ (void)doWorkInMainPipe:(MrWork *)work
{
    [[self mainPipe] addWork:work];
}

+ (MrWork *)asyncDoWork:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWorkBlock:block];
    [[self createQueuePipe] addWork:work];
    return work;
}

+ (MrWork *)asyncDoWorkInMainPipe:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWorkBlock:block];
    [[self mainPipe] addWork:work];
    return work;
}

+ (MrWork *)asyncDoWorkWaitFinish:(WaitFinishWorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWaitFinishWorkBlock:block];
    [[self createQueuePipe] addWork:work];
    return work;
}

+ (MrWork *)ayncDoWorkWaitFinishInMainPipe:(WaitFinishWorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWaitFinishWorkBlock:block];
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
