//
//  QueuePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "QueuePipe.h"
#import "PipeManager.h"


@interface QueuePipe ()

@property (nonatomic) dispatch_queue_t queue;

@end

@implementation QueuePipe

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

-(void)doWorks
{
    dispatch_async(self.queue, ^{
        [[self getWorks] bk_each:^(MrWork* work) {
            if (!work.isExecute && !work.isFinish) {
                [work doit];
                [work finish];
            }
        }];
    });
}

@end