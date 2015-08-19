//
//  LyricManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "LyricManager.h"


@interface LyricManager ()

//装载点击的那一首歌 每一句的歌词模型  每一句歌词 都是一个模型
@property(nonatomic,strong)NSMutableArray * allLyricModelArray;

@end

@implementation LyricManager

#pragma mark - 创建单例 并初始化数组
+ (instancetype)shareInstance
{
    static LyricManager * lyricManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lyricManager = [[LyricManager alloc] init];
        
        //注意 在类方法里不能用self初始化数组  lyricManager就代表这个类 (self)
        lyricManager.allLyricModelArray = [NSMutableArray array];
        
    });
    
    return lyricManager;
}


#pragma mark - 初始化歌词
- (void)formatLyricModelWithLyric:(NSString *)lyric
{
    //换一首新歌曲的时候  要将数组中的数据移除
    [self.allLyricModelArray removeAllObjects];
    
    //切分每一行所显示的歌词 根据'\n' 切分后返回一个数组
    NSArray * contentLyric = [lyric componentsSeparatedByString:@"\n"];
    
    //遍历 装载这一首歌曲的歌词数组
    for (int i = 0; i < contentLyric.count; i++) {
        
        //获取 每行应该显示的歌词数据
        NSString * sourceStr = contentLyric[i];
        
        //歌词数据源：[00:4532] 如果能重来 根据"]"拆分时间和歌词
        NSArray * lyricArray = [sourceStr componentsSeparatedByString:@"]"];
        
        //有这个样的歌词 [] 作者xxx 避免拆分时候越界 加上一下判断
        if ([lyricArray.firstObject length] < 1) {
            
            break;
        }
        
        //拆分以后的每句歌词的时间 lyricArray.firstObject格式为"[00:4523" 所以需要从1开始获取
        NSString * timeStr = [lyricArray.firstObject substringFromIndex:1];
        
        //time格式为 00：4523 所以需要去掉":"
        NSArray * timeArray = [timeStr componentsSeparatedByString:@":"];
        
        //计算每句歌词 的总时间
        CGFloat timeTotal = [timeArray.firstObject floatValue] * 60 + [timeArray.lastObject floatValue];
        
        //每句歌词为
        NSString * lyricStr = lyricArray.lastObject;
        
        //初始化歌词模型  并给模型赋值
        LyricModel * lyricModel = [[LyricModel alloc] init];
        
        lyricModel.time = timeTotal;
        lyricModel.layric = lyricStr;
        
        //将每句歌词的模型装进数组
        [self.allLyricModelArray addObject:lyricModel];
    }
    
}


#pragma mark - 根据下标返回歌词
-(NSString *)lyricAtIndex:(NSInteger)index
{
    LyricModel * lyricModel = self.allLyricModelArray[index];
    
    return lyricModel.layric;
}

#pragma mark - 根据时间返回下标
-(NSInteger)indexOfTime:(CGFloat)time
{
    NSInteger index = 0;
    
    //遍历歌词数组
    for (int i = 0 ; i < self.allLyricModelArray.count; i++) {
        
        //每一个歌词模型
        LyricModel * lyricModel = self.allLyricModelArray[i];
        
        //如果歌词的时间 比 传进来的时间大   就显示 i-1 所对应的模型所对应的歌词下标
        if (lyricModel.time > time) {
            
            index = i-1 > 0 ? i-1:0;
            //遍历到有满足的模型 直接跳出遍历
            break;
        }
    }
    
    return index;
}

#pragma mark - 根据下标返回播放时间
//点击歌词 跳到对应的播放时间
-(CGFloat)progressAtIndex:(NSInteger)index
{
    LyricModel * lyricModel = self.allLyricModelArray[index];
    
    CGFloat time = lyricModel.time;
    
    return time;
}

#pragma mark - 返回歌词的tableView上应该显示的行数
//就是一首歌 有多少句歌词
-(NSInteger)countOfLyricModelArray
{
    return self.allLyricModelArray.count;
}

@end
