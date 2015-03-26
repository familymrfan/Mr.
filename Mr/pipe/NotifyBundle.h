//
//  NotifyBundle.h
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MrWork.h"

typedef void(^NotifyBlock)();

@interface NotifyBundle : NSObject

@property (nonatomic, copy) NotifyBlock notifyBlock;

- (MrWork *)bindWork:(MrWork *)work;
- (MrWork *)bindWorkBlock:(WorkBlock)block;
- (MrWork *)bindWaitFinishWorkBlock:(WaitFinishWorkBlock)block;

- (void)start;

@end
