//
//  MusicPlayerManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/8/10.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicPlayerManager.h"

@interface MusicPlayerManager ()
//判断是否在播放
{
    BOOL isPlaying;
}
//声明个计时器属性
@property(nonatomic,weak)NSTimer * timer;

@end

@implementation MusicPlayerManager

#pragma mark - 创建单例
#pragma mark - 因为音乐播放器是唯一的只创建一次
static AVPlayer * avPlayer = nil;
+ (instancetype)shareInstance
{
    static MusicPlayerManager * musicPlayerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        musicPlayerManager = [[MusicPlayerManager alloc] init];
        
        avPlayer = [[AVPlayer alloc] init];
        
    });
    
    return musicPlayerManager;
}

#pragma mark - 注册通知 当音乐播放完成以后 执行相应的方法
-(instancetype)init
{
    if ([super init]) {
        
        //用系统自带的key 注册
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicDidFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
    return self;
}

#pragma mark - 根据url设置音乐播放器
-(void)setAVPlayerWithUrl:(NSString *)url
{
    //创建音乐元素
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    
    //将item给创建好的播放器
    [avPlayer replaceCurrentItemWithPlayerItem:item];
    
    //播放当前的item
    [self playMusic];
    
}

#pragma mark - 播放音乐
-(void)playMusic
{
    isPlaying = YES;
    
    //播放音乐的时候创建计时器   每0.1秒执行一次playingAction这个方法 重复
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingAction) userInfo:nil repeats:YES];
    
    //让音乐播放器 走起 (系统方法)
    [avPlayer play];
    
}

#pragma mark - 暂停音乐
-(void)pauseMusic
{
    isPlaying = NO;
    
    //播放器停止
    [avPlayer pause];
    
    //计时器设为不可用
    [self.timer invalidate];
    
    //置空
    self.timer = nil;
}

#pragma mark - 播放过程中执行的
//实现 播放过程中每0.1秒重复执行的方法
- (void)playingAction
{
    //把当前的播放进度 传值给musicPlayer界面
    CGFloat time = avPlayer.currentTime.value / avPlayer.currentTime.timescale;
    
    //判断是否有代理 并完成了代理中的方法
    if (self.delegete && [self.delegete performSelector:@selector(playingWithProgress:)]) {
        
        //如果实现了 就通知代理做相应的事情
        [self.delegete playingWithProgress:time];
    }
}

#pragma mark - 播放 / 暂停
-(BOOL)playOrPauseMusic
{
    if (isPlaying) {
        
        [self pauseMusic];
        return NO;
    }else{
        
        [self playMusic];
        return YES;
    }
}

#pragma mark - 指定时间开始播放
-(void)seekToPlayWithTime:(CGFloat)time
{
    //先暂停播放器
    [self pauseMusic];
    
    //将传过来的时间 换算成CMTime
    CMTime times = CMTimeMakeWithSeconds(time, avPlayer.currentTime.timescale);
    
    //将时间设定为指定时间
    [avPlayer seekToTime:times completionHandler:^(BOOL finished) {
        
        //播放音乐
        if (finished) {
            
            [self playMusic];
        }
    }];
}


#pragma mark - 音量调节
- (void)seekVolumeWithValue:(CGFloat)value
{
    avPlayer.volume = value;
}




#pragma mark - 播放结束的时候执行
- (void)musicDidFinished
{
//    //判断的时候要执行一次playDidToEnd方法 所以下标在判断的时候已经加一 在执行的时候又加一
//    if (self.delegete && [self.delegete respondsToSelector:@selector(playDidToEnd) {
//    
//    //通知代理 播放结束 让播放器执行响应的方法
//    [self.delegete playDidToEnd];
//        
//    }
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(playDidToEnd)]) {
        
        //通知代理 播放结束 让播放器执行响应的方法
        [self.delegete playDidToEnd];
    }
    
}

@end
