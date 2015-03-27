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

@property (nonatomic) dispatch_queue_t queue;

- (void)addWork:(MrWork *)work;
- (MrWork *)addWorkBlock:(WorkBlock)block;
- (MrWork *)addWaitFinishWorkBlock:(WaitFinishWorkBlock)block;

- (void)ready;
- (void)flush;
- (void)wait;

- (NSArray *)getWorks;
- (void)doWorks;

@end
