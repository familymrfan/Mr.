//
//  MrWork.h
//  Mr
//
//  Created by FanFamily on 15/3/21.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyBundle.h"

typedef void(^WorkBlock)(BOOL isCancel);

@interface MrWork : NSObject

// 添加到通知束当中，当这些工作都完成的时候产生这个通知work
- (void)attachNotifyBundle:(NotifyBundle *)notify;

// 设置工作的具体内容
- (void)setWorkBlock:(WorkBlock)block;
- (WorkBlock)getWorkBlock:(WorkBlock)block;

// do work
- (void)doit;

// 是否正在执行
- (BOOL)isExecute;

// 让工作不再产生回调
- (void)cancel;
- (BOOL)isCancel;

@end
