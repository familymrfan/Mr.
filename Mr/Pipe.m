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
    [self cleanFinishWorks];
    [self.works addObject:work];
    [self doWorks];
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

- (void)addWorkBlock:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithBlock:block];
    [self addWork:work];
}

- (void)readyWork:(MrWork *)work
{
    [self.readyWorks addObject:work];
}

- (void)readyWorkBlock:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithBlock:block];
    [self readyWork:work];
}

- (void)flush
{
    [self cleanFinishWorks];
    [self.works addObjectsFromArray:self.readyWorks];
    [self doWorks];
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
