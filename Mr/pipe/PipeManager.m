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

+ (MrWork *)doWork:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWorkBlock:block];
    [[self createQueuePipe] addWork:work];
    return work;
}

+ (MrWork *)doWorkInMainPipe:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWorkBlock:block];
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