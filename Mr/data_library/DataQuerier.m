//
//  DataQuerier.m
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "DataQuerier.h"

@interface DataQuerier ()

@property (nonatomic) FMDatabase* dabase;

@end

@implementation DataQuerier

- (void)setDatabase:(FMDatabase *)database
{
    self.dabase = database;
}

@end
