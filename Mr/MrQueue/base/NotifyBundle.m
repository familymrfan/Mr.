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
    if (!work.isFinish) {
        [self.works addObject:work];
        [work addObserver:self forKeyPath:@"isFinish" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (MrWork* )bindWorkBlock:(WorkBlock)block
{
    MrWork* work = [[MrWork alloc] initWithWorkBlock:block];
    [self bindWork:work];
    return work;
}

- (NSArray *)getWorks
{
    return self.works;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(MrWork *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"isFinish"]) {
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
