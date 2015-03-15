//
//  DataPathProvider.m
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "DataPathProvider.h"

@implementation DataPathProvider

- (NSString *)documentDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)tmpDirectory
{
    return NSTemporaryDirectory();
}

@end
