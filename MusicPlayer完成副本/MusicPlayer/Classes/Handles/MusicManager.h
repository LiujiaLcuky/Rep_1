//
//  MusicManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//



#import <Foundation/Foundation.h>
@class MusicModel;

@interface MusicManager : NSObject


/**
 *  *根据url请求数据
 *
 *  @param url 数据接口
 *
 *  @param result 请求完数据后执行此block
 *
 *  @return dataArray 返回请求的数据
 */
- (void)requestAllDataDidFinish:(void(^)(NSMutableArray * dataArray))result;

/**
 *  根据下标返回模型
 *
 *  @param index 下标
 *
 *  @return model
 */
- (MusicModel *)getMusicModelWithIndex:(NSInteger)index;

#pragma mark - 创建单例
+ (instancetype)shareInstance;

/**
 *  返回数组个数
 */
- (NSInteger)musicCount;


@end
