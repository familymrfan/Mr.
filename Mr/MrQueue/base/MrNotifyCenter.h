//
//  MrNotifyCenter.h
//  Mr
//
//  Created by FanFamily on 15/3/26.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyBundle.h"

@interface MrNotifyCenter : NSObject

+ (void)bindNotifyWithWork:(MrWork *)work notifyBlock:(NotifyBlock)notifyBlock;
+ (void)bindNotifyWithWorks:(NSArray *)work notifyBlock:(NotifyBlock)notifyBlock;

@end
