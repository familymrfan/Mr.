//
//  MrWork.m
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MrWork.h"

@interface MrWork ()

@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, copy) WorkBlock block;

@end

@implementation MrWork

- (void)attachCollectBundle:(CollectBundle *)collect
{
    
}

- (void)attachNotifyBundle:(NotifyBundle *)notify
{
    
}

- (void)doit
{
    if (self.block) {
        self.block([self isCancel]);
    }
}

- (void)setWorkBlock:(WorkBlock)block
{
    self.block = block;
}

- (WorkBlock)getWorkBlock:(WorkBlock)block
{
    return block;
}

- (void)cancel
{
    self.isCancel = YES;
}

@end
