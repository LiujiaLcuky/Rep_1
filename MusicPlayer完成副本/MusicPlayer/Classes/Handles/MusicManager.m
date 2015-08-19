//
//  MusicManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicManager.h"
#import "musicHeader.h"
#import "MusicModel.h"

@interface MusicManager ()

@property(nonatomic,strong)NSMutableArray * allModelArray;

@end

@implementation MusicManager

#pragma mark - 创建单例
+ (instancetype)shareInstance
{
    static MusicManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[MusicManager alloc] init];
    });
    
    return manager;
}

#pragma mark - 请求数据
-(void)requestAllDataDidFinish:(void (^)(NSMutableArray *))result
{

    NSURL * url = [NSURL URLWithString:kMusicUrl];
    
    //开辟子线程 避免假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //将数据装进数组
        NSArray * array = [NSArray arrayWithContentsOfURL:url];
        
        //遍历数组
        for (NSDictionary * dic in array) {
            
            MusicModel * model = [[MusicModel alloc] init];
            //赋值对象
            [model setValuesForKeysWithDictionary:dic];
            
            //装进数组
            [self.allModelArray addObject:model];
        }
        
        //返回主线程 并使用result这个block
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回装载模型对象的数组
            result(self.allModelArray);
        });
        
    });
    
}

//懒加载
-(NSMutableArray *)allModelArray
{
    if (!_allModelArray) {
        _allModelArray = [NSMutableArray array];
    }
    return _allModelArray;
}


#pragma mark - 根据下标返回模型
-(MusicModel *)getMusicModelWithIndex:(NSInteger)index
{
    MusicModel * model = [self.allModelArray objectAtIndex:index];
    
    return model;
}

#pragma mark - musicCount
-(NSInteger)musicCount
{
    return self.allModelArray.count;
}

@end
