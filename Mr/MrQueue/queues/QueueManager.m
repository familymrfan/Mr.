//
//  PipeManager.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "QueueManager.h"
#import "Macro.h"

@implementation QueueManager

+ (void)asyncDoWork:(MrWork *)work
{
    [[self createSerializeQueue] enqueueWork:work];
}

+ (void)asyncDoWorkInMainQueue:(MrWork *)work
{
    [[self mainQueue] enqueueWork:work];
}

+ (MrWork *)asyncDoWorkBlock:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWorkBlock:block];
    [[self createSerializeQueue] enqueueWork:work];
    return work;
}

+ (MrWork *)asyncDoWorkBlockInMainQueue:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] init];
    [work setWorkBlock:block];
    [[self mainQueue] enqueueWork:work];
    return work;
}

+ (MainQueue *)mainQueue
{
    SHARED_OBJECT(MainQueue);
}

// 创建
+ (SerializeQueue *)createSerializeQueue
{
    return [SerializeQueue new];
}

@end
