//
//  MusicPlayerManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/8/10.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  制定一个在播放过程中的协议
 */

@protocol MusicPlayingDelegate <NSObject>

/**
 *  播放过程中执行
 *
 *  @param progress 播放进度
 */

- (void)playingWithProgress:(CGFloat)progress;

/**
 *  播放结束执行
 */
- (void)playDidToEnd;

@end

@interface MusicPlayerManager : NSObject

/**
 *  根据url设置播放器
 *
 *  @param url 为音乐地址
 *
 *  @return
 */

- (void)setAVPlayerWithUrl:(NSString *)url;


#pragma mark - 创建单例
+ (instancetype)shareInstance;

/**
 *  播放音乐
 */

- (void)playMusic;

/**
 *  暂停音乐
 */

- (void)pauseMusic;

/**
 *  给管理类设置一个代理, 让他去做播放过程中要做的那些事
 */
@property(nonatomic,weak)id<MusicPlayingDelegate> delegete;


/**
 *  播放 / 暂停 
 *
 * @param 返回播放状态
 */

- (BOOL)playOrPauseMusic;

/**
 *  从指定时间开始播放
 *
 * @param time 指定的时间
 */
- (void)seekToPlayWithTime:(CGFloat)time;


#pragma mark - 音量调节

/**
 *  调节音量
 *
 *  @param value slider的值
 */

- (void)seekVolumeWithValue:(CGFloat)value;



@end
