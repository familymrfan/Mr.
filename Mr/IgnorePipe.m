//
//  IgnorePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "IgnorePipe.h"
#import "PipeManager.h"

@interface IgnorePipe ()

@property (nonatomic) dispatch_queue_t queue;

@end


@implementation IgnorePipe

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
    __block MrWork* executeWork = nil;
    [[self getWorks] bk_each:^(MrWork* work) {
        if (!work.isExecute && !work.isFinish) {
            if (executeWork == nil) {
                executeWork = work;
                dispatch_async(self.queue, ^{
                    [work doit];
                    [work finish];
                });
            } else {
                [work finish];
            }
        } else if (work.isExecute) {
            executeWork = work;
        }
    }];
}

@end
