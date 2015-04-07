//
//  MrNotifyCenter.m
//  Mr
//
//  Created by FanFamily on 15/3/26.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MrNotifyCenter.h"
#import "Macro.h"

@interface MrNotifyCenter ()

@property (nonatomic) NSMutableArray* notifyBundles;

@end

@implementation MrNotifyCenter

+ (instancetype)sharedInstace
{
    SHARED_OBJECT(MrNotifyCenter);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.notifyBundles = [NSMutableArray array];
    }
    return self;
}

+ (void)bindNotifyWithWork:(MrWork *)work notifyBlock:(NotifyBlock)notifyBlock
{
    MrNotifyCenter* center = [MrNotifyCenter sharedInstace];
    NotifyBundle* bundle = [[NotifyBundle alloc] init];
    [center.notifyBundles addObject:bundle];
    NotifyBlock block = ^() {
        notifyBlock();
        [center.notifyBundles removeObject:bundle];
    };
    [bundle setNotifyBlock:block];
    [bundle bindWork:work];
}

+ (void)bindNotifyWithWorks:(NSArray *)works notifyBlock:(NotifyBlock)notifyBlock
{
    MrNotifyCenter* center = [MrNotifyCenter sharedInstace];
    NotifyBundle* bundle = [[NotifyBundle alloc] init];
    [center.notifyBundles addObject:bundle];
    NotifyBlock block = ^() {
        notifyBlock();
        [center.notifyBundles removeObject:bundle];
    };
    [bundle setNotifyBlock:block];
    [works enumerateObjectsUsingBlock:^(MrWork* work, NSUInteger idx, BOOL *stop) {
        [bundle bindWork:work];
    }];
    
    if ([bundle getWorks].count == 0) {
        if (notifyBlock) {
            notifyBlock();
        }
    }
}

@end
