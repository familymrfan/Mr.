//
//  ReplacePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "ReplacePipe.h"

@implementation ReplacePipe

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
    __block MrWork* executeWork = [self getWorks].lastObject;
    if (!executeWork.isExecute && !executeWork.isFinish) {
        dispatch_async(self.queue, ^{
            executeWork = [self getWorks].lastObject;
            [[self getWorks] bk_each:^(MrWork* work) {
                if (work != executeWork) {
                    [work cancel];
                    [work finish];
                }
            }];
            [executeWork doit];
            [executeWork finish];
        });
    }
}

@end
