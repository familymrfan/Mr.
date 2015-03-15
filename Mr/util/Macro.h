//
//  Macro.h
//  Mr
//
//  Created by FanFamily on 15/3/15.
//  Copyright (c) 2015年 familymrfan. All rights reserved.
//

#ifndef Mr_Macro_h
#define Mr_Macro_h

#define SHARED_OBJECT(class_name) \
do { \
static class_name* once = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
once = [[class_name alloc] init]; \
}); \
return once; \
} while (0)

#endif
