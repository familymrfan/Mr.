//
//  MainPipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MainPipe.h"
#import "BlocksKit/BlocksKit.h"

@implementation MainPipe

-(void)doWorks
{
    [[self getWorks] bk_each:^(MrWork* work) {
        if (!work.isExecute && !work.isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [work doit];
                [work finish];
            });
        }
    }];
}

@end
