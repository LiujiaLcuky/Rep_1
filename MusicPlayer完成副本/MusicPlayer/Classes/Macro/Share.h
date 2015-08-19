//
//  Share.h
//  MusicPlayer
//
//  Created by lanou3g on 15/8/12.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#ifndef MusicPlayer_Share_h
#define MusicPlayer_Share_h

///写在.h文件中
#define singleton_interface(className) \
+ (className *)shared##className;
//singleton_interface(className) 在.h里用类的名字代替括号里的className
//singleton_implementation(className) .m里用这个
//等你想用单例的时候 就用[类的名字 shared..]就调用了 这个是根据##前面的名字决定的


///写在.m文件中
#define singleton_implementation(className) \
static className *_instance; \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[[self class] alloc] init]; \
}); \
return _instance; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \

#endif
