//
//  QueuePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "SerializeQueue.h"

@interface SerializeQueue ()

@property (nonatomic) dispatch_queue_t queue;

@end

@implementation SerializeQueue

-(void)run
{
    if (self.queue == nil) {
        self.queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    }
    [[self getWorks] enumerateObjectsUsingBlock:^(MrWork* work, NSUInteger idx, BOOL *stop) {
        if (!work.isExecute && !work.isFinish) {
            dispatch_async(self.queue, ^{
                [work run:[self preWorkResult:work]];
            });
        }
    }];
}

@end
