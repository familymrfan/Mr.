//
//  QueuePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "SerializeQueue.h"

@implementation SerializeQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

-(void)run
{
    [[self getWorks] enumerateObjectsUsingBlock:^(MrWork* work, NSUInteger idx, BOOL *stop) {
        if (!work.isExecute && !work.isFinish) {
            dispatch_async(self.queue, ^{
                NSUInteger idx = [[self getWorks] indexOfObject:work];
                id result = [self preWorkResult:idx];
                [work run:result];
            });
        }
    }];
}

@end
