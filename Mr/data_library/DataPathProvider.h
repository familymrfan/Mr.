//
//  DataPathProvider.h
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPathProvider : NSObject

- (NSString*)documentDirectory;
- (NSString *)tmpDirectory;

@end
