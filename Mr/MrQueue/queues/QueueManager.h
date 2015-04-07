//
//  PipeManager.h
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MrWork.h"
#import "MainQueue.h"
#import "SerializeQueue.h"

@interface QueueManager : NSObject

+ (void)asyncDoWork:(MrWork *)work;
+ (void)asyncDoWorkInMainQueue:(MrWork *)work;
+ (MrWork *)asyncDoWorkBlock:(WorkBlock)block;
+ (MrWork *)asyncDoWorkBlockInMainQueue:(WorkBlock)block;


// 获取main Queue只有一个
+ (MainQueue *)mainQueue;

// 创建
+ (SerializeQueue *)createSerializeQueue;

@end
