//
//  NotifyBundle.m
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "NotifyBundle.h"

@interface NotifyBundle ()

@property (nonatomic) NSMutableArray* works;
@property (nonatomic, assign) BOOL isStart;

@end

@implementation NotifyBundle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.works = [NSMutableArray array];
    }
    return self;
}

- (void)bindWork:(MrWork *)work
{
    NSAssert(self.isStart == NO, @"bind is started ! you can not bind work");
    NSAssert(!work.isExecute && !work.isFinish, @"the work should not execute if you want bind notify !");
    [self.works addObject:work];
}

- (MrWork* )bindWorkBlock:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithWorkBlock:block];
    [self bindWork:work];
    return work;
}

- (MrWork *)bindWaitFinishWorkBlock:(WaitFinishWorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithWaitFinishWorkBlock:block];
    [self bindWork:work];
    return work;
}

- (void)start
{
    self.isStart = YES;
    [self.works enumerateObjectsUsingBlock:^(MrWork* work, NSUInteger idx, BOOL *stop) {
        [work addObserver:self forKeyPath:@"isFinish" options:NSKeyValueObservingOptionNew context:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(MrWork *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"isFinish"]) {
        NSLog(@"object %@ change %@", object, change);
        
        if ([object isFinish]) {
            [self.works removeObject:object];
            [object removeObserver:self forKeyPath:@"isFinish"];
            if ([self.works count] == 0) {
                if (self.notifyBlock) {
                    self.notifyBlock();
                    self.notifyBlock = nil;
                }
            }
        }
    }
}

@end
