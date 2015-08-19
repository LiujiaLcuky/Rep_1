//
//  MusicPlayerViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "MusicManager.h"
#import "MusicModel.h"
#import "MusicPlayerManager.h"

@interface MusicPlayerViewController ()<UITableViewDataSource,UITableViewDelegate,MusicPlayingDelegate>
{
    NSInteger _currentIndex; //记录当前歌曲模型下标

}

@property(nonatomic,weak)NSTimer * timer;



@property(nonatomic,strong)NSArray * musicViewArray;

@end

@implementation MusicPlayerViewController

#pragma mark - 单例获取 音乐播放器
+(instancetype)shareInstance
{
    static MusicPlayerViewController * musicPlayerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //根据Storyboard创建音乐播放器
        musicPlayerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"musicPlayer"];
   
        //计时器
        musicPlayerVC.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:musicPlayerVC selector:@selector(changeBlackgroundView) userInfo:nil repeats:YES];
    });
    
    return musicPlayerVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化当前下标
    _currentIndex = -1;
    
    //给管理类设置代理
    [MusicPlayerManager shareInstance].delegete = self;
    
    //设置imgageView的相关属性
    [self setImageView];
    
    //设置slider的可滑动
    self.sliderPlan.continuous = YES;
    
    [self.sliderPlan setThumbImage:[UIImage imageNamed:@"slider1.png"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"slider2.png"] forState:UIControlStateNormal];
}


//在视图要出现的时候给当前下标赋值
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_currentIndex == self.index) {
        
        return;
    }else{
        
        _currentIndex = self.index;
        
        [self updataUI];
    }
}


#pragma mark - 更新界面
- (void)updataUI
{
    //设置播放器 根据rul
    [[MusicPlayerManager shareInstance] setAVPlayerWithUrl:self.musicModel.mp3Url];
    
    //设置歌名
    self.songNameLabel.text = self.musicModel.name;
    
    //设置图片
    [self.singerImgView sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl]];
    
    //设置slider的最大值 duration是毫秒 转化成秒
    CGFloat duration = [self.musicModel.duration floatValue] / 1000;
    
    self.sliderPlan.maximumValue = duration;
    
    
    //音量slider
    self.volumeSlider.maximumValue = 100;
    self.volumeSlider.minimumValue = 0;
    self.volumeSlider.value = 30;
    
    //格式化已经加载的歌词
    [[LyricManager shareInstance] formatLyricModelWithLyric:self.musicModel.lyric];
    
    //更新歌词界面
    [self.LyricTableView reloadData];
    
    
    //初始化背景
    UIImageView * Bview = [[UIImageView alloc] init];
    [Bview sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl]];
    [self.LyricTableView setBackgroundView:Bview];
    
    
}

#pragma mark - 在get模型的时候 就赋值
//确定加载哪一首歌曲
-(MusicModel *)musicModel
{
    //根据下标得到单例类里面的模型
    MusicModel * model = [[MusicManager shareInstance] getMusicModelWithIndex:_currentIndex];
    
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置imgView的相关属性
- (void)setImageView
{
    [self.singerImgView layoutIfNeeded];
    //设置圆角
    self.singerImgView.layer.cornerRadius = 135;
    
    //设置圆角可用
    self.singerImgView.layer.masksToBounds = YES;
    
    
    //设置起始角度
    self.singerImgView.transform = CGAffineTransformMakeRotation(0);
}


#pragma mark - 执行协议中的方法

//播放过程中执行的方法
-(void)playingWithProgress:(CGFloat)progress
{
    //旋转图片
    self.singerImgView.transform = CGAffineTransformRotate(self.singerImgView.transform, M_1_PI/180);
    
    //进度调
    self.sliderPlan.value = progress;
    
    //当前时间
    self.nowTimeLabel.text = [self changeToStringWithTime:progress];
    
    //剩余时间 = 总时间 - 当前时间
    CGFloat duration = [self.musicModel.duration floatValue] / 1000;
    
    self.surplusTimeLabel.text = [self changeToStringWithTime:duration - progress];
    
    //根据当前播放时间 获取下表
    NSInteger index = [[LyricManager shareInstance] indexOfTime:progress];
    
    //组拼indexPath
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    //获取滚动的那一行
    UITableViewCell *cell = [self.LyricTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:24];
    
    
    NSIndexPath * indexPath1 = [NSIndexPath indexPathForRow:index-1 inSection:0];
    
    //获取滚动的上一行
    UITableViewCell *cell1 = [self.LyricTableView cellForRowAtIndexPath:indexPath1];
    cell1.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    
    //实现歌词滚动 根据indexPath 第三个参数是滚动方向
    [self.LyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

#pragma mark - 将时间格式转换为NSString
- (NSString *)changeToStringWithTime:(CGFloat)time
{
    //计算分钟
    int minutes = time / 60;
    //计算秒
    int seconds = (int)time % 60;
    
    NSString * str = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    
    return str;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//点击返回列表界面
- (IBAction)returnMusicList:(UIButton *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上一曲
- (IBAction)lastMusicButton:(UIButton *)sender
{
    
    //先暂停播放
    [[MusicPlayerManager shareInstance] pauseMusic];
    
    //让当前模型下标减一
//    _currentIndex--;
    
    [self playDidToEnd];
    
    //判断如果下标 < 0 播放最后一首
    if (_currentIndex < 0) {
        
        _currentIndex = [[MusicManager shareInstance] musicCount] - 1;
    }
    
    //更新界面
    [self updataUI];
    
}

//下一曲
- (IBAction)nextMusicButton:(UIButton *)sender
{
    [[MusicPlayerManager shareInstance] pauseMusic];
    
    [self playDidToEnd];
    
//    _currentIndex++;
    
    if (_currentIndex > [[MusicManager shareInstance] musicCount] - 1) {
        
        _currentIndex = 0;
    }
    
    [self updataUI];
}

//播放 暂停 在播放按钮上现实相应的文字
- (IBAction)playOrPauseMusicButton:(UIButton *)sender
{
    BOOL isplaying = [[MusicPlayerManager shareInstance] playOrPauseMusic];
    
    if (isplaying) {
        
        //停止图片
        self.singerImgView.transform = CGAffineTransformRotate(self.singerImgView.transform, 0);
        [sender setImage:[UIImage imageNamed:@"播放.jpg"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"暂停.jpg"] forState:UIControlStateNormal];
    }
}

#pragma mark - 滑动滑竿 对应相应的播放时间
- (IBAction)moveSliderAction:(UISlider *)sender
{
    CGFloat duration = [self.musicModel.duration floatValue] / 1000;
    
     
    
    if (sender.value >= duration) {
        [[MusicPlayerManager shareInstance] pauseMusic];
        return;
    }
    
    //播放指定的时间
    [[MusicPlayerManager shareInstance] seekToPlayWithTime:sender.value];

}

#pragma mark - 协议中必须要实现的方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[LyricManager shareInstance] countOfLyricModelArray];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"lyricCell" forIndexPath:indexPath];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.numberOfLines = 0;
    
    //获取歌词的数据源 点击这个列表的时候就加载数据源
    cell.textLabel.text = [[LyricManager shareInstance] lyricAtIndex:indexPath.row];
    
    //将cell的背景颜色弄为透明的
    UIView * selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectedView;

    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:(arc4random() % 256/256.0) green:(arc4random() % 256/256.0) blue:(arc4random() % 256/256.0) alpha:1];
    
    self.LyricTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return cell;
}
//更换背景
- (void)changeBlackgroundView
{
    UIImageView * Bview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%d.jpg",arc4random()%30+1]]];
    
    [self.LyricTableView setBackgroundView:Bview];
}

//滚动到的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - 点击歌词跳转对应的播放时间
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat time = [[LyricManager shareInstance] progressAtIndex:indexPath.row];
    
    //播放当前时间
    [[MusicPlayerManager shareInstance] seekToPlayWithTime:time];
}


#pragma mark - 调节音量大小
- (IBAction)moveVolmueSliderAction:(UISlider *)sender
{
    
    [[MusicPlayerManager shareInstance] seekVolumeWithValue:sender.value];
    
}

//播放顺序
static int oredr = 1;
- (IBAction)musicPlayTheOrder:(UIButton *)sender
{
    if (oredr == 1) {
        oredr++;
        [sender setTitle:@"单曲循环" forState:UIControlStateNormal];
    }else if (oredr == 2){
        oredr++;
        [sender setTitle:@"随机播放" forState:UIControlStateNormal];
    }else if (oredr == 3){
        oredr = 1;
        [sender setTitle:@"顺序播放" forState:UIControlStateNormal];
    }
}

#pragma mark - 播放结束
-(void)playDidToEnd
{
    if (oredr == 1) {
        NSLog(@"顺序播放");
        //播放结束  则播放下一首
        _currentIndex++;
        oredr = 1;
    }else if (oredr == 2){
        NSLog(@"单曲循环");
        _currentIndex++;
        _currentIndex--;
        oredr = 2;
    }else if (oredr == 3){
        oredr = 3;
        NSLog(@"随机播放");
        //随机
        int value = arc4random()%([[MusicManager shareInstance] musicCount] - 1);
        _currentIndex = value;
    }
    //如果是最后一首就播放第一首
    if (_currentIndex > [[MusicManager shareInstance] musicCount] - 1) {
        _currentIndex = 0;
    }
    //播放歌曲 更新界面
    [self updataUI];
}

@end
