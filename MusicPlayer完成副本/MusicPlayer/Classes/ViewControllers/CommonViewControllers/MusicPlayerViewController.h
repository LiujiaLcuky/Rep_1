//
//  MusicPlayerViewController.h
//  MusicPlayer
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayerViewController : UIViewController
//歌手图片
@property (strong, nonatomic) IBOutlet UIImageView *singerImgView;
//当前时间
@property (strong, nonatomic) IBOutlet UILabel *nowTimeLabel;
//剩余时间
@property (strong, nonatomic) IBOutlet UILabel *surplusTimeLabel;

//slider进度
@property (strong, nonatomic) IBOutlet UISlider *sliderPlan;

//上一曲
- (IBAction)lastMusicButton:(UIButton *)sender;

//play  pause
- (IBAction)playOrPauseMusicButton:(UIButton *)sender;

//歌曲名字
@property (strong, nonatomic) IBOutlet UILabel *songNameLabel;

//下一曲
- (IBAction)nextMusicButton:(UIButton *)sender;

//返回按钮
- (IBAction)returnMusicList:(UIButton *)sender;

//接收数据的音乐对象
@property (strong, nonatomic) MusicModel * musicModel;

//用来获取下标
@property(assign,nonatomic)NSInteger index;

//滑动进度滑竿 对应相应的时间
- (IBAction)moveSliderAction:(UISlider *)sender;

/**
 *  单例创建音乐播放器 接口
 */

+ (instancetype)shareInstance;

//歌词tableView
@property (strong, nonatomic) IBOutlet UITableView *LyricTableView;

//音量拉杆
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;

//拉动音量滑竿
- (IBAction)moveVolmueSliderAction:(UISlider *)sender;

//播放顺序button
- (IBAction)musicPlayTheOrder:(UIButton *)sender;




@end
