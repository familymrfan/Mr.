//
//  NSRunLoop+blockRun.h
//  mail
//
//  Created by familymrfan on 14-12-29.
//  Copyright (c) 2014年 NetEase (Hangzhou) Network Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRunLoop (blockRun)

- (void)blockRun:(NSTimeInterval)time;

@end
