//
//  Pipe.m
//  Mr
//
//  Created by FanFamily on 15/3/23.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "Pipe.h"

@interface Pipe ()

@property (nonatomic) NSMutableArray* works;
@property (nonatomic) NSMutableArray* readyWorks;

@end

@implementation Pipe

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.works = [NSMutableArray array];
        self.readyWorks = [NSMutableArray array];
    }
    return self;
}

- (void)addWork:(MrWork *)work
{
    [self.works addObject:work];
    [self doWorks];
    [self.works removeObject:work];
}

- (void)readyWork:(MrWork *)work
{
    [self.readyWorks addObject:work];
}

- (void)flush
{
    [self.works addObjectsFromArray:self.readyWorks];
    [self doWorks];
    [self.works removeObjectsInArray:self.readyWorks];
}

- (NSArray *)getWorks
{
    return self.works;
}

- (void)doWorks
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
