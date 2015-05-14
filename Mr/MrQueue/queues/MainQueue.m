//
//  MainPipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MainQueue.h"

@implementation MainQueue

-(void)run
{
    [[self getWorks] enumerateObjectsUsingBlock:^(MrWork* work, NSUInteger idx, BOOL *stop) {
        if (!work.isExecute && !work.isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [work run:[self preWorkResult:work]];
            });
        }
    }];
}

@end
