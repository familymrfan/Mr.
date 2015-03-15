//
//  MrObject.h
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MrObject : NSObject

@property (nonatomic) NSNumber* rowId;

- (NSArray *)keyNames;
-(NSDictionary *)keyname2Value;
-(NSDictionary *)keyname2Class;

- (instancetype)deepCopy;

@end
