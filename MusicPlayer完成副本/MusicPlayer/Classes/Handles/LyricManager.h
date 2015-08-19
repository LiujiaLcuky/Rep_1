//
//  LyricManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

/**
 *  歌词管理类
 *
 *  @param
 *
 */


#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

/**
 *  格式化歌词 创建歌词模型 放进数组
 *
 *  @param NSString lyric 歌词数据 每个model的歌词
 *
 *  @return non
 */

- (void)formatLyricModelWithLyric:(NSString *)lyric;

/**
 *  返回 你点击的那首歌有多少句歌词
 *
 *
 *  @return NSInteger
 */

- (NSInteger)countOfLyricModelArray;

/**
 *  根据下标返回歌词 一首歌的 所有歌词 就是数据源
 *
 *  @param NSInteger index 传入cell的下标
 *
 *  @return NSString 格式化好的 一首歌的所有歌词
 */

- (NSString *)lyricAtIndex:(NSInteger)index;

/**
 *  根据传入的当前播放时间 返回下标
 *
 *  @param CGFloat time 当前播放的时间
 *
 *  @return NSInteger index 当前播放时间所对应在cell上的歌词
 */

- (NSInteger)indexOfTime:(CGFloat)time;

/**
 *  点击歌词的时候 根据下标 返回对应的播放时间
 *
 *  @param NSInteger index cell上歌词对应的下标
 *
 *  @return CGFloat time 当前应该播放的时间
 */

- (CGFloat)progressAtIndex:(NSInteger)index;


/**
 *  单例创建方法
 */

+ (instancetype)shareInstance;

@end
