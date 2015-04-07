//
//  Pipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MrQueue.h"
#import "MrNotifyCenter.h"

@interface MrQueue ()

@property (nonatomic) NSMutableArray* works;
@property (nonatomic) NSMutableArray* suspendWorks;
@property (nonatomic) BOOL isSuspend;
@property (nonatomic) id initResult;

@end

@implementation MrQueue

- (instancetype)initWithInitResult:(id)initResult
{
    self = [super init];
    if (self) {
        self = [self init];
        self.initResult = initResult;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.works = [NSMutableArray array];
        self.suspendWorks = [NSMutableArray array];
    }
    return self;
}

- (void)enqueueWork:(MrWork *)work
{
    if (!self.isSuspend) {
        [self.works addObject:work];
        [self run];
    } else {
        [self suspendWork:work];
    }
}

- (void)suspend
{
    self.isSuspend = YES;
    [self.works enumerateObjectsUsingBlock:^(MrWork* obj, NSUInteger idx, BOOL *stop) {
        if (obj.isFinish) {
            [self suspendWork:obj];
        }
    }];
    [self.works removeObjectsInArray:self.suspendWorks];
}

- (void)suspendWork:(MrWork *)work
{
    [self.suspendWorks addObject:work];
}

- (MrWork *)enqueueWorkBlock:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithWorkBlock:block];
    [self enqueueWork:work];
    return work;
}

- (void)resume
{
    [self.works addObjectsFromArray:self.suspendWorks];
    [self.suspendWorks removeAllObjects];
    [self run];
    self.isSuspend = NO;
}

- (NSArray *)getWorks
{
    return [self.works arrayByAddingObjectsFromArray:self.suspendWorks];
}

- (id)preWork:(MrWork *)work
{
    NSInteger index = [[self getWorks] indexOfObject:work];
    if (index - 1 < 0 || index - 1 >= [self getWorks].count) {
        return nil;
    }
    MrWork* preWork = [[self getWorks] objectAtIndex:index-1];
    return preWork;
}

- (id)preWorkResult:(MrWork *)work
{
    id result;
    id preWork = [self preWork:work];
    if (preWork == nil) {
        result = [self getInitResult];
    } else {
        result = [preWork finishResult];
    }
    return result;
}

- (void)run
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)wait
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [MrNotifyCenter bindNotifyWithWorks:[self getWorks] notifyBlock:^{
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (id)getInitResult
{
    return self.initResult;
}

@end
