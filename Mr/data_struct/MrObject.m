//
//  MrObject.m
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#import "MrObject.h"
#import <objc/runtime.h>

@implementation MrObject

- (NSArray *)keyNames
{
    NSMutableArray* propNames = [NSMutableArray array];
    unsigned int propCount;
    objc_property_t *props = class_copyPropertyList([self class], &propCount);
    for(int i = 0; i < propCount; i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        [propNames addObject:propName];
    }
    free(props);
    return propNames;
}

-(NSDictionary *)keyname2Value
{
    __block NSMutableDictionary *propName2value = [NSMutableDictionary dictionary];
    [[self keyNames] enumerateObjectsUsingBlock:^(id propName, NSUInteger idx, BOOL *stop) {
        id propValue = [self valueForKey:propName];
        if(propValue){
            [propName2value setObject:propValue forKey:propName];
        }
    }];
    return propName2value;
}

-(NSDictionary *)keyname2Class
{
    NSMutableDictionary *propname2Class = [NSMutableDictionary dictionary];
    unsigned int propCount;
    objc_property_t *props = class_copyPropertyList([self class], &propCount);
    for(int i=0; i<propCount; i++){
        objc_property_t prop = props[i];
        NSString* propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        NSString* propAttribute = [[NSString alloc]initWithCString:property_getAttributes(prop) encoding:NSUTF8StringEncoding];
        NSRange rangeBegin = [propAttribute rangeOfString:@"T@\""];
        NSRange rangeEnd   = [propAttribute rangeOfString:@"\"" options:NSBackwardsSearch];
        NSString* propClass = [propAttribute substringWithRange:NSMakeRange(rangeBegin.location + rangeBegin.length, rangeEnd.location - rangeBegin.location - rangeBegin.length)];
        if (propName && propClass) {
            [propname2Class setObject:NSClassFromString(propClass) forKey:propName];
        }
    }
    free(props);
    return propname2Class;
}

- (instancetype)deepCopy
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.class, self.keyname2Value];
}

@end
