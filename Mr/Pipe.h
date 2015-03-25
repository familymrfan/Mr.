//
//  Pipe.h
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MrWork.h"

@interface Pipe : NSObject

- (void)addWork:(MrWork *)work;
- (void)addSyncWorkBlock:(SyncWorkBlock)block;
- (void)addAsyncWorkBlock:(AsyncWorkBlock)block;

- (void)ready;
- (void)flush;

- (NSArray *)getWorks;
- (void)doWorks;

@end
