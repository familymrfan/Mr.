//
//  ReplacePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "ReplacePipe.h"

@interface ReplacePipe ()

@property (nonatomic) dispatch_queue_t queue;

@end

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
    __block MrWork* replaceWork = [self getWorks].lastObject;
    [[self getWorks] bk_each:^(MrWork* work) {
        if (![work isEqual:replaceWork]) {
            [work cancel];
            [work finish];
        } else {
            dispatch_async(self.queue, ^{
                if (!work.isExecute && !work.isFinish) {
                    [work doit];
                    [work finish];
                }
            });
        }
    }];
}

@end
