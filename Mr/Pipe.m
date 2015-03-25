//
//  Pipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "Pipe.h"

@interface Pipe ()

@property (nonatomic) NSMutableArray* works;
@property (nonatomic) NSMutableArray* readyWorks;
@property (nonatomic) BOOL isReady;

@end

@implementation Pipe

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.works = [NSMutableArray array];
        self.readyWorks = [NSMutableArray array];
    }
    return self;
}

- (void)addWork:(MrWork *)work
{
    if (!self.isReady) {
        [self cleanFinishWorks];
        [self.works addObject:work];
        [self doWorks];
    } else {
        [self readyWork:work];
    }
}

- (void)cleanFinishWorks
{
    NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
    [self.works enumerateObjectsUsingBlock:^(MrWork* work, NSUInteger idx, BOOL *stop) {
        if (work.isFinish) {
            [indexSet addIndex:idx];
        }
    }];
    [self.works removeObjectsAtIndexes:indexSet];
}

- (void)ready
{
    self.isReady = YES;
}


- (void)readyWork:(MrWork *)work
{
    [self.readyWorks addObject:work];
}

- (void)addSyncWorkBlock:(SyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithSyncBlock:block];
    [self addWork:work];
}


- (void)readySyncWorkBlock:(SyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithSyncBlock:block];
    [self readyWork:work];
}

- (void)addAsyncWorkBlock:(AsyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithAsyncBlock:block];
    [self addWork:work];
}

- (void)readyAsyncWorkBlock:(AsyncWorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithAsyncBlock:block];
    [self readyWork:work];
}

- (void)flush
{
    [self cleanFinishWorks];
    [self.works addObjectsFromArray:self.readyWorks];
    [self doWorks];
    self.isReady = NO;
}

- (NSArray *)getWorks
{
    return self.works;
}

- (void)doWorks
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
