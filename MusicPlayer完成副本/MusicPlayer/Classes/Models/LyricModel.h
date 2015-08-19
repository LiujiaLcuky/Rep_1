//
//  LyricModel.h
//  MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

//每一句歌词
@property(nonatomic,strong)NSString * layric;

//每句歌词对应的时间
@property(nonatomic,assign)CGFloat time;

@end
