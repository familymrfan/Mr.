//
//  QueuePipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "QueuePipe.h"
#import "BlocksKit/BlocksKit.h"

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
    [[self getWorks] bk_each:^(MrWork* work) {
        if (!work.isExecute) {
            dispatch_async(self.queue, ^{
                [work doit];
            });
        }
    }];
}

@end
