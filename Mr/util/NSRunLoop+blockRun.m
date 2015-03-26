//
//  NSRunLoop+blockRun.m
//  mail
//
//  Created by familymrfan on 14-12-29.
//  Copyright (c) 2014年 NetEase (Hangzhou) Network Co., Ltd. All rights reserved.
//

#import "NSRunLoop+blockRun.h"

@implementation NSRunLoop (blockRun)

- (void)blockRun:(NSTimeInterval)time
{
    NSPort* workPort = [NSMachPort port];
    [[NSRunLoop currentRunLoop] addPort:workPort forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    [[NSRunLoop currentRunLoop] removePort:workPort forMode:NSDefaultRunLoopMode];
    [workPort invalidate];
}

@end
