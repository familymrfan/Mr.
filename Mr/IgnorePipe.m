//
//  IgnorePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "IgnorePipe.h"
#import "PipeManager.h"

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
    __block MrWork* executeWork = [self getWorks].firstObject;
    if (!executeWork.isExecute && !executeWork.isFinish) {
        dispatch_async(self.queue, ^{
            [[self getWorks] bk_each:^(MrWork* work) {
                if (work != executeWork) {
                    [work finish];
                }
            }];
            [executeWork doit];
        });
    }
}

@end
